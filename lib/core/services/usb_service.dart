import 'dart:convert';
import 'dart:io';
import 'package:flutter_usb/flutter_usb.dart';
import 'package:disk_space/disk_space.dart';
import '../../models/drive_model.dart';

class UsbService {
  static final UsbService _instance = UsbService._internal();
  factory UsbService() => _instance;
  UsbService._internal();

  Future<List<DriveModel>> getAvailableDrives() async {
    try {
      final usbDevices = await _getUSBDevices();
      final drives = <DriveModel>[];

      // Get drive paths from platform-specific methods
      final drivePaths = await _getDrivePaths();

      for (var device in usbDevices) {
        try {
          final driveInfo = await _getDriveInfo(device, drivePaths);
          if (driveInfo != null) {
            drives.add(driveInfo);
          }
        } catch (e) {
          print('Error processing device: $e');
        }
      }

      return drives;
    } catch (e) {
      print('Error getting USB devices: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getUSBDevices() async {
    try {
      final jsonString = await FlutterUsb.getUsbJson();
      if (jsonString.isEmpty) return [];

      final jsonData = jsonDecode(jsonString);
      if (jsonData is List) {
        return jsonData.cast<Map<String, dynamic>>();
      } else if (jsonData is Map<String, dynamic>) {
        return _extractDevicesFromMap(jsonData);
      }
      return [];
    } catch (e) {
      print('Error parsing USB data: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _extractDevicesFromMap(Map<String, dynamic> data) {
    final devices = <Map<String, dynamic>>[];

    // Try to find devices in common structures
    for (var key in data.keys) {
      final value = data[key];
      if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            devices.add(item);
          }
        }
      } else if (value is Map<String, dynamic>) {
        devices.add(value);
      }
    }

    return devices;
  }

  Future<List<String>> _getDrivePaths() async {
    final paths = <String>[];

    if (Platform.isWindows) {
      // On Windows, check common drive letters
      for (
        var letter = 'D'.codeUnitAt(0);
        letter <= 'Z'.codeUnitAt(0);
        letter++
      ) {
        final driveLetter = String.fromCharCode(letter);
        final path = '$driveLetter:\\';
        try {
          final dir = Directory(path);
          if (await dir.exists()) {
            // Check if we can get free space (means it's accessible)
            try {
              final freeSpace = await DiskSpace.getFreeDiskSpaceForPath(path);
              if (freeSpace != null) {
                paths.add(path);
              }
            } catch (e) {
              // Drive not accessible
            }
          }
        } catch (e) {
          // Drive doesn't exist or is not accessible
        }
      }
    } else if (Platform.isLinux) {
      try {
        final result = await Process.run('lsblk', [
          '-P',
          '-o',
          'NAME,FSTYPE,LABEL,SIZE,FSAVAIL,MOUNTPOINT,RM,HOTPLUG,TRAN,TYPE,MODEL,SERIAL',
        ]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('RM="1"') ||
              line.contains('HOTPLUG="1"') ||
              (line.contains('TRAN="usb"') && line.contains('TYPE="disk"'))) {
            final match = RegExp(r'NAME="([^"]+)"').firstMatch(line);
            if (match != null) {
              final name = match.group(1);
              if (name != null &&
                  !name.contains('loop') &&
                  !name.contains('sr')) {
                paths.add('/dev/$name');
              }
            }
          }
        }
      } catch (e) {
        print('Error getting Linux drive paths: $e');
        // Fallback to common paths
        paths.addAll(['/dev/sda', '/dev/sdb', '/dev/sdc', '/dev/sdd']);
      }
    } else if (Platform.isMacOS) {
      try {
        final result = await Process.run('diskutil', ['list']);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('external') && line.contains('physical')) {
            final match = RegExp(r'/dev/(disk\d+)').firstMatch(line);
            if (match != null) {
              final disk = match.group(1);
              if (disk != null) {
                paths.add('/dev/$disk');
              }
            }
          }
        }
      } catch (e) {
        print('Error getting macOS drive paths: $e');
        paths.addAll(['/dev/disk2', '/dev/disk3', '/dev/disk4']);
      }
    }

    return paths;
  }

  Future<DriveModel?> _getDriveInfo(
    Map<String, dynamic> device,
    List<String> drivePaths,
  ) async {
    try {
      // Extract device information from USB data
      final name =
          device['_name'] ??
          device['product_name'] ??
          device['Manufacturer'] ??
          device['Product Name'] ??
          device['description'] ??
          'USB Device';

      final vendor =
          device['Manufacturer'] ??
          device['vendor_name'] ??
          device['Vendor ID'] ??
          'Unknown';

      final serial =
          device['serial_num'] ??
          device['Serial Number'] ??
          device['serial_number'] ??
          '';

      final id = serial.isNotEmpty
          ? serial
          : '${DateTime.now().millisecondsSinceEpoch}';

      // Try to find a valid drive path with accessible space
      String? validPath;
      int totalBytes = 0;
      int freeBytes = 0;

      for (var path in drivePaths) {
        try {
          // Get free space in GB and convert to bytes
          final freeGB = await DiskSpace.getFreeDiskSpaceForPath(path);

          if (freeGB != null && freeGB > 0) {
            // Try to get total space using platform-specific methods
            final totalGB = await _getTotalSpaceForPath(path);

            if (totalGB > 0) {
              freeBytes = (freeGB * 1024 * 1024 * 1024).round();
              totalBytes = (totalGB * 1024 * 1024 * 1024).round();
              validPath = path;
              break;
            }
          }
        } catch (e) {
          // This path is not accessible, try next one
          continue;
        }
      }

      // If no valid drive found, return null
      if (validPath == null || totalBytes == 0) {
        return null;
      }

      final usedBytes = totalBytes - freeBytes;

      // Determine mount point
      final mountPoint = await _getMountPoint(validPath);

      return DriveModel(
        id: id,
        name: name,
        path: validPath,
        totalSpace: totalBytes,
        usedSpace: usedBytes,
        isRemovable: true,
        mountPoint: mountPoint,
        type: DriveType.usb,
        isSelected: false,
        vendor: vendor,
        model: name,
        serialNumber: serial,
        isMounted: true,
      );
    } catch (e) {
      print('Error creating drive model: $e');
      return null;
    }
  }

  Future<double> _getTotalSpaceForPath(String path) async {
    try {
      if (Platform.isWindows) {
        // Use PowerShell to get total drive size
        final drive = path[0];
        final result = await Process.run('powershell', [
          '-Command',
          '(Get-WmiObject Win32_LogicalDisk -Filter "DeviceID=\'$drive:\'").Size/1GB',
        ]);
        final output = result.stdout.toString().trim();
        if (output.isNotEmpty) {
          return double.tryParse(output) ?? 0.0;
        }
        return 0.0;
      } else if (Platform.isLinux) {
        // Use df to get total size
        final result = await Process.run('df', ['-BG', path]);
        final lines = result.stdout.toString().split('\n');
        if (lines.length >= 2) {
          final parts = lines[1].split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            final sizeStr = parts[1].replaceAll('G', '');
            return double.tryParse(sizeStr) ?? 0.0;
          }
        }
        return 0.0;
      } else if (Platform.isMacOS) {
        // Use diskutil to get total size
        final result = await Process.run('diskutil', ['info', path]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('Total Size:')) {
            final match = RegExp(
              r'Total Size:\s+([\d.]+)\s+GB',
            ).firstMatch(line);
            if (match != null) {
              return double.tryParse(match.group(1) ?? '0') ?? 0.0;
            }
          }
        }
        return 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Error getting total space: $e');
      return 0.0;
    }
  }

  Future<String> _getMountPoint(String path) async {
    if (Platform.isWindows) {
      return path; // On Windows, path is the mount point
    } else if (Platform.isLinux) {
      try {
        final result = await Process.run('lsblk', [
          '-P',
          '-o',
          'NAME,MOUNTPOINT',
          path,
        ]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          final match = RegExp(r'MOUNTPOINT="([^"]+)"').firstMatch(line);
          if (match != null) {
            final mountPoint = match.group(1);
            if (mountPoint != null && mountPoint.isNotEmpty) {
              return mountPoint;
            }
          }
        }
      } catch (e) {
        print('Error getting mount point: $e');
      }
      return '/media';
    } else if (Platform.isMacOS) {
      try {
        final result = await Process.run('diskutil', ['info', path]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('Mount Point:')) {
            final match = RegExp(r'Mount Point:\s+(.+)').firstMatch(line);
            if (match != null) {
              return match.group(1) ?? '';
            }
          }
        }
      } catch (e) {
        print('Error getting mount point: $e');
      }
      return '/Volumes';
    }
    return '';
  }

  Future<bool> unmountDrive(DriveModel drive) async {
    try {
      if (Platform.isWindows) {
        // Use PowerShell to eject drive
        final result = await Process.run('powershell', [
          '-Command',
          'Remove-Drive -DriveLetter ${drive.path[0]} -Force',
        ]);
        return result.exitCode == 0;
      } else if (Platform.isLinux) {
        final result = await Process.run('umount', [drive.mountPoint]);
        return result.exitCode == 0;
      } else if (Platform.isMacOS) {
        final result = await Process.run('diskutil', [
          'unmount',
          drive.mountPoint,
        ]);
        return result.exitCode == 0;
      }
      return false;
    } catch (e) {
      print('Error unmounting drive: $e');
      return false;
    }
  }

  Future<bool> validateDrive(DriveModel drive, int requiredSize) async {
    // Check if drive has enough space and is writable
    return drive.hasEnoughSpace(requiredSize) && drive.isWritable;
  }

  Future<void> refreshDrives() async {
    // Force a refresh of the drive list
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
