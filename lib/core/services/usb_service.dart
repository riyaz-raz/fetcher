import 'dart:ffi';
import 'dart:io';
import 'package:flusbserial/flusbserial.dart';
import 'package:disk_space/disk_space.dart';
import '../../models/drive_model.dart';

class UsbService {
  static final UsbService _instance = UsbService._internal();
  factory UsbService() => _instance;
  UsbService._internal();

  List<UsbDevice>? _cachedDevices;
  DateTime? _lastScanTime;
  static const Duration _cacheDuration = Duration(seconds: 5);
  bool _isInitialized = false;
  bool _libusbLoaded = false;

  // Load libusb using various methods
  void _loadLibusb() {
    if (_libusbLoaded) return;

    if (Platform.isMacOS) {
      // Method 1: Try to open via DynamicLibrary
      try {
        final paths = [
          '/opt/homebrew/lib/libusb-1.0.dylib',
          '/opt/homebrew/lib/libusb-1.0.0.dylib',
          '/usr/local/lib/libusb-1.0.dylib',
        ];

        for (var path in paths) {
          if (File(path).existsSync()) {
            DynamicLibrary.open(path);
            print('libusb loaded from: $path');
            _libusbLoaded = true;
            return;
          }
        }
      } catch (e) {
        print('DynamicLibrary loading failed: $e');
      }

      // Method 2: Try to set environment variable
      try {
        final libPath = '/opt/homebrew/lib';
        final currentPath = Platform.environment['DYLD_LIBRARY_PATH'] ?? '';
        if (!currentPath.contains(libPath)) {
          // Note: This might not work on all macOS versions
          Platform.environment['DYLD_LIBRARY_PATH'] =
              '$libPath:${Platform.environment['DYLD_LIBRARY_PATH'] ?? ''}';
          print(
            'Set DYLD_LIBRARY_PATH to: ${Platform.environment['DYLD_LIBRARY_PATH']}',
          );
        }
      } catch (e) {
        print('Setting environment variable failed: $e');
      }

      // Method 3: Check if libusb exists and log info
      try {
        final result = Process.runSync('ls', [
          '-la',
          '/opt/homebrew/lib/libusb*',
        ]);
        print('libusb files found:\n${result.stdout}');
      } catch (e) {
        print('Could not list libusb files: $e');
      }
    }
  }

  Future<void> _initializeUsb() async {
    if (_isInitialized) return;

    try {
      // Load libusb first
      _loadLibusb();

      // Initialize USB
      UsbSerialDevice.init();
      _isInitialized = true;
      print('USB Serial Device initialized successfully');
    } catch (e) {
      print('Error initializing USB: $e');
      // Don't rethrow - continue with fallback methods
      _isInitialized = true; // Mark as initialized to prevent retry loops
    }
  }

  Future<List<DriveModel>> getAvailableDrives() async {
    try {
      // Initialize USB (will load libusb)
      await _initializeUsb();

      // Try to get USB devices
      List<UsbDevice> usbDevices = [];
      try {
        usbDevices = await _getUSBDevices();
        print('Found ${usbDevices.length} USB devices');

        // Log device details
        for (var device in usbDevices) {
          print(
            'USB Device: ${device.identifier} - VID: ${device.vendorId}, PID: ${device.productId}',
          );
        }
      } catch (e) {
        print('Error getting USB devices: $e');
        // Continue without USB devices - we'll fall back to direct detection
      }

      final drives = <DriveModel>[];
      final drivePaths = await _getDrivePaths();
      print('Found ${drivePaths.length} drive paths: $drivePaths');

      // Try to match USB devices with drive paths
      for (var device in usbDevices) {
        try {
          final driveInfo = await _getDriveInfo(device, drivePaths);
          if (driveInfo != null) {
            drives.add(driveInfo);
            print(
              'Added drive from USB device: ${driveInfo.name} at ${driveInfo.path}',
            );
          }
        } catch (e) {
          print('Error processing device ${device.identifier}: $e');
        }
      }

      // If no USB drives found, try direct drive detection
      if (drives.isEmpty && drivePaths.isNotEmpty) {
        print('No USB drives found from devices, trying direct detection');
        final directDrives = await _getDirectDriveInfo(drivePaths);
        drives.addAll(directDrives);
        print('Added ${directDrives.length} drives from direct detection');
      }

      // If still no drives found, try a more aggressive scan
      if (drives.isEmpty) {
        print('No drives found, trying aggressive scan');
        final aggressiveDrives = await _aggressiveDriveScan();
        drives.addAll(aggressiveDrives);
      }

      return drives;
    } catch (e) {
      print('Error in getAvailableDrives: $e');
      // Final fallback
      return await _getDirectDriveInfo(await _getDrivePaths());
    }
  }

  // Aggressive drive scan for macOS
  Future<List<DriveModel>> _aggressiveDriveScan() async {
    final drives = <DriveModel>[];

    if (Platform.isMacOS) {
      try {
        // Use diskutil to find all external drives
        final result = await Process.run('diskutil', ['list', 'external']);
        final lines = result.stdout.toString().split('\n');

        for (var line in lines) {
          if (line.contains('/dev/disk') && line.contains('external')) {
            final match = RegExp(r'/dev/(disk\d+)').firstMatch(line);
            if (match != null) {
              final disk = match.group(1);
              if (disk != null) {
                // Get mount point for this disk
                final infoResult = await Process.run('diskutil', [
                  'info',
                  '/dev/$disk',
                ]);
                final infoLines = infoResult.stdout.toString().split('\n');

                for (var infoLine in infoLines) {
                  if (infoLine.contains('Mount Point:')) {
                    final mountMatch = RegExp(
                      r'Mount Point:\s+(.+)',
                    ).firstMatch(infoLine);
                    if (mountMatch != null) {
                      final mountPoint = mountMatch.group(1)?.trim();
                      if (mountPoint != null &&
                          mountPoint.isNotEmpty &&
                          mountPoint != '/' &&
                          !mountPoint.contains('Macintosh HD')) {
                        final driveInfo = await _getDriveInfoFromPath(
                          mountPoint,
                        );
                        if (driveInfo != null) {
                          drives.add(driveInfo);
                          print(
                            'Found drive via aggressive scan: ${driveInfo.name} at $mountPoint',
                          );
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        print('Aggressive scan error: $e');
      }
    }

    return drives;
  }

  Future<List<UsbDevice>> _getUSBDevices() async {
    try {
      // Check cache
      if (_cachedDevices != null &&
          _lastScanTime != null &&
          DateTime.now().difference(_lastScanTime!) < _cacheDuration) {
        return _cachedDevices!;
      }

      // Try to list devices
      final devices = await UsbSerialDevice.listDevices();

      _cachedDevices = devices;
      _lastScanTime = DateTime.now();

      return devices;
    } catch (e) {
      print('Error listing USB devices: $e');
      return [];
    }
  }

  // Add these methods after _getUSBDevices() and before the closing brace of the class

  Future<List<DriveModel>> _getDirectDriveInfo(List<String> drivePaths) async {
    final drives = <DriveModel>[];

    for (var path in drivePaths) {
      try {
        final driveInfo = await _getDriveInfoFromPath(path);
        if (driveInfo != null) {
          drives.add(driveInfo);
        }
      } catch (e) {
        print('Error getting direct drive info for $path: $e');
      }
    }

    return drives;
  }

  Future<DriveModel?> _getDriveInfoFromPath(String path) async {
    try {
      final freeBytes = await _getFreeSpace(path);
      if (freeBytes == null || freeBytes <= 0) return null;

      final totalBytes = await _getTotalSpace(path);
      if (totalBytes <= 0) return null;

      final usedBytes = totalBytes - freeBytes;
      final mountPoint = await _getMountPoint(path);
      final name = await _getVolumeName(path) ?? 'USB Drive';

      return DriveModel(
        id: path,
        name: name,
        path: path,
        totalSpace: totalBytes,
        usedSpace: usedBytes,
        isRemovable: true,
        mountPoint: mountPoint,
        type: DriveType.usb,
        isSelected: false,
        vendor: 'Unknown',
        model: name,
        serialNumber: '',
        isMounted: true,
      );
    } catch (e) {
      print('Error getting drive info from path: $e');
      return null;
    }
  }

  Future<DriveModel?> _getDriveInfo(
    UsbDevice device,
    List<String> drivePaths,
  ) async {
    try {
      // Try to find a matching drive path for this USB device
      String? validPath;
      int totalBytes = 0;
      int freeBytes = 0;

      // On macOS, try to find external volumes
      if (Platform.isMacOS) {
        for (var path in drivePaths) {
          try {
            final isExternal = await _isExternalVolume(path);
            if (isExternal) {
              final free = await _getFreeSpace(path);
              final total = await _getTotalSpace(path);

              if (free != null && total != null && total > 0) {
                validPath = path;
                freeBytes = free;
                totalBytes = total;
                print('Found external volume: $path');
                break;
              }
            }
          } catch (e) {
            continue;
          }
        }
      } else {
        // For other platforms, try to match with drive paths
        for (var path in drivePaths) {
          try {
            final free = await _getFreeSpace(path);
            final total = await _getTotalSpace(path);

            if (free != null && total != null && total > 0) {
              if (Platform.isLinux && path.startsWith('/media/')) {
                validPath = path;
                freeBytes = free;
                totalBytes = total;
                break;
              } else if (Platform.isWindows) {
                validPath = path;
                freeBytes = free;
                totalBytes = total;
                break;
              }
            }
          } catch (e) {
            continue;
          }
        }
      }

      if (validPath == null || totalBytes == 0) {
        return null;
      }

      final usedBytes = totalBytes - freeBytes;
      final mountPoint = await _getMountPoint(validPath);

      // Generate a name from the device ID or path
      final name =
          'USB Device ${device.identifier}' ??
          (await _getVolumeName(validPath) ?? 'USB Drive');

      return DriveModel(
        id: device.identifier.isNotEmpty ? device.identifier : validPath,
        name: name,
        path: validPath,
        totalSpace: totalBytes,
        usedSpace: usedBytes,
        isRemovable: true,
        mountPoint: mountPoint,
        type: DriveType.usb,
        isSelected: false,
        vendor: 'Unknown',
        model: name,
        serialNumber: device.identifier,
        isMounted: true,
      );
    } catch (e) {
      print('Error creating drive model from device: $e');
      return null;
    }
  }

  Future<List<String>> _getDrivePaths() async {
    final paths = <String>[];

    if (Platform.isWindows) {
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
            try {
              final freeSpace = await DiskSpace.getFreeDiskSpaceForPath(path);
              if (freeSpace != null && freeSpace > 0) {
                paths.add(path);
              }
            } catch (e) {
              // Drive not accessible
            }
          }
        } catch (e) {
          // Drive doesn't exist
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
                final mountMatch = RegExp(
                  r'MOUNTPOINT="([^"]*)"',
                ).firstMatch(line);
                if (mountMatch != null) {
                  final mountPoint = mountMatch.group(1);
                  if (mountPoint != null && mountPoint.isNotEmpty) {
                    paths.add(mountPoint);
                  } else {
                    paths.add('/dev/$name');
                  }
                } else {
                  paths.add('/dev/$name');
                }
              }
            }
          }
        }
      } catch (e) {
        print('Error getting Linux drive paths: $e');
        paths.addAll(['/dev/sda', '/dev/sdb', '/dev/sdc', '/dev/sdd']);
      }
    } else if (Platform.isMacOS) {
      // On macOS, check mounted volumes
      try {
        final volumesDir = Directory('/Volumes');
        if (await volumesDir.exists()) {
          final entries = await volumesDir.list().toList();
          for (var entry in entries) {
            if (entry is Directory) {
              final path = entry.path;
              // Skip system volumes
              if (!path.contains('Macintosh HD') &&
                  !path.contains('System') &&
                  !path.contains('Recovery') &&
                  !path.contains('com.apple')) {
                try {
                  final isExternal = await _isExternalVolume(path);
                  if (isExternal) {
                    final freeSpace = await DiskSpace.getFreeDiskSpaceForPath(
                      path,
                    );
                    if (freeSpace != null && freeSpace > 0) {
                      paths.add(path);
                    }
                  }
                } catch (e) {
                  // Volume not accessible
                }
              }
            }
          }
        }
      } catch (e) {
        print('Error getting macOS drive paths: $e');
        // Fallback to common USB mount points
        paths.addAll([
          '/Volumes/USB',
          '/Volumes/UNTITLED',
          '/Volumes/NO NAME',
          '/Volumes/Untitled',
        ]);
      }
    }

    return paths;
  }

  Future<int?> _getFreeSpace(String path) async {
    try {
      final freeGB = await DiskSpace.getFreeDiskSpaceForPath(path);
      if (freeGB != null && freeGB > 0) {
        return (freeGB * 1024 * 1024 * 1024).round();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<int> _getTotalSpace(String path) async {
    try {
      if (Platform.isWindows) {
        final drive = path[0];
        final result = await Process.run('powershell', [
          '-Command',
          '(Get-WmiObject Win32_LogicalDisk -Filter "DeviceID=\'$drive:\'").Size/1GB',
        ]);
        final output = result.stdout.toString().trim();
        if (output.isNotEmpty) {
          final totalGB = double.tryParse(output) ?? 0.0;
          return (totalGB * 1024 * 1024 * 1024).round();
        }
        return 0;
      } else if (Platform.isLinux) {
        final result = await Process.run('df', ['-BG', path]);
        final lines = result.stdout.toString().split('\n');
        if (lines.length >= 2) {
          final parts = lines[1].split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            final sizeStr = parts[1].replaceAll('G', '');
            final totalGB = double.tryParse(sizeStr) ?? 0.0;
            return (totalGB * 1024 * 1024 * 1024).round();
          }
        }
        return 0;
      } else if (Platform.isMacOS) {
        final result = await Process.run('diskutil', ['info', path]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('Total Size:')) {
            Match? match = RegExp(
              r'Total Size:\s+([\d.]+)\s+GB',
            ).firstMatch(line);
            if (match != null) {
              final totalGB = double.tryParse(match.group(1) ?? '0') ?? 0.0;
              return (totalGB * 1024 * 1024 * 1024).round();
            }
            match = RegExp(r'Total Size:\s+([\d.]+)\s+TB').firstMatch(line);
            if (match != null) {
              final totalTB = double.tryParse(match.group(1) ?? '0') ?? 0.0;
              return (totalTB * 1024 * 1024 * 1024 * 1024).round();
            }
          }
        }
        return 0;
      }
      return 0;
    } catch (e) {
      print('Error getting total space for $path: $e');
      return 0;
    }
  }

  Future<String> _getMountPoint(String path) async {
    if (Platform.isWindows) {
      return path;
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
              return match.group(1)?.trim() ?? '';
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

  Future<String?> _getVolumeName(String path) async {
    try {
      if (Platform.isWindows) {
        final drive = path[0];
        final result = await Process.run('powershell', [
          '-Command',
          '(Get-WmiObject Win32_LogicalDisk -Filter "DeviceID=\'$drive:\'").VolumeName',
        ]);
        final name = result.stdout.toString().trim();
        return name.isNotEmpty ? name : null;
      } else if (Platform.isLinux) {
        final result = await Process.run('lsblk', [
          '-P',
          '-o',
          'NAME,LABEL,MOUNTPOINT',
          path,
        ]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          final match = RegExp(r'LABEL="([^"]*)"').firstMatch(line);
          if (match != null) {
            final label = match.group(1);
            if (label != null && label.isNotEmpty) {
              return label;
            }
          }
        }
        return null;
      } else if (Platform.isMacOS) {
        final result = await Process.run('diskutil', ['info', path]);
        final lines = result.stdout.toString().split('\n');
        for (var line in lines) {
          if (line.contains('Volume Name:')) {
            final match = RegExp(r'Volume Name:\s+(.+)').firstMatch(line);
            if (match != null) {
              final name = match.group(1)?.trim();
              if (name != null && name.isNotEmpty && name != '') {
                return name;
              }
            }
          }
        }
        return null;
      }
      return null;
    } catch (e) {
      print('Error getting volume name: $e');
      return null;
    }
  }

  Future<bool> _isExternalVolume(String path) async {
    try {
      final result = await Process.run('diskutil', ['info', path]);
      final output = result.stdout.toString();

      if (output.contains('External: Yes') ||
          output.contains('Removable: Yes')) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking if volume is external: $e');
      return false;
    }
  }

  Future<bool> unmountDrive(DriveModel drive) async {
    try {
      if (Platform.isWindows) {
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
          'eject',
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
    return drive.hasEnoughSpace(requiredSize) && drive.isWritable;
  }

  Future<void> refreshDrives() async {
    _cachedDevices = null;
    _lastScanTime = null;
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> dispose() async {
    _cachedDevices = null;
    _isInitialized = false;
    _libusbLoaded = false;
  }
}
