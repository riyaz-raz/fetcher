import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import '../../models/image_model.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final List<String> _supportedExtensions = [
    'iso',
    'img',
    'dmg',
    'bin',
    'raw',
    'gz',
    'xz',
  ];

  Future<ImageModel?> selectImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: _supportedExtensions,
        allowMultiple: false,
        withData: false,
      );

      if (result == null) return null;

      final file = result.files.first;
      final path = file.path;

      if (path == null) return null;

      final fileInfo = File(path);
      final size = await fileInfo.length();
      final extension = path.split('.').last.toLowerCase();

      return ImageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.name,
        path: path,
        size: size,
        type: _getImageType(extension),
        fileExtension: extension,
        dateAdded: DateTime.now(),
        isValid: await _validateImage(fileInfo, extension),
        isCompressed: _isCompressed(extension),
        compressionType: _getCompressionType(extension),
      );
    } catch (e) {
      print('Error selecting image: $e');
      return null;
    }
  }

  ImageType _getImageType(String extension) {
    switch (extension) {
      case 'iso':
        return ImageType.iso;
      case 'img':
        return ImageType.img;
      case 'dmg':
        return ImageType.dmg;
      case 'bin':
        return ImageType.bin;
      case 'raw':
        return ImageType.raw;
      case 'gz':
        return ImageType.gz;
      case 'xz':
        return ImageType.xz;
      default:
        return ImageType.other;
    }
  }

  bool _isCompressed(String extension) {
    return extension == 'gz' || extension == 'xz' || extension == 'zip';
  }

  String? _getCompressionType(String extension) {
    if (extension == 'gz') return 'gzip';
    if (extension == 'xz') return 'xz';
    if (extension == 'zip') return 'zip';
    return null;
  }

  Future<bool> _validateImage(File file, String extension) async {
    try {
      // Basic validation: check if file exists and is readable
      if (!await file.exists()) return false;

      // Check if file size is reasonable (at least 1MB for images)
      final size = await file.length();
      if (size < 1024 * 1024) return false;

      // Additional validation based on file type
      switch (extension) {
        case 'iso':
          return await _validateIso(file);
        case 'img':
          return await _validateImg(file);
        default:
          return true;
      }
    } catch (e) {
      print('Error validating image: $e');
      return false;
    }
  }

  Future<bool> _validateIso(File file) async {
    try {
      // Read only the first 32768 bytes
      final bytes = await file.readAsBytes().then(
        (data) => data.sublist(0, 32768),
      );

      // Check for CD001 at offset 32769
      if (bytes.length > 32774) {
        final cd001 = String.fromCharCodes(bytes.sublist(32769, 32774));
        if (cd001 == 'CD001') {
          return true;
        }
      }

      // Check for CD001 anywhere
      final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      return hex.contains('4344303031');
    } catch (e) {
      print('Error validating ISO: $e');
      return false;
    }
  }

  Future<bool> _validateImg(File file) async {
    try {
      // Simple validation: check if file has data
      final size = await file.length();
      return size > 1024 * 1024; // At least 1MB
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> calculateChecksums(String path) async {
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();

      final md5sum = md5.convert(bytes);
      final sha256sum = sha256.convert(bytes);

      return {'md5': md5sum.toString(), 'sha256': sha256sum.toString()};
    } catch (e) {
      print('Error calculating checksums: $e');
      return {};
    }
  }

  // Alternative method to read specific bytes from a file
  Future<Uint8List> _readFileBytes(File file, int offset, int length) async {
    final raf = await file.open(mode: FileMode.read);
    try {
      // Seek to the specified offset
      await raf.setPosition(offset);
      // Read the specified length
      return await raf.read(length);
    } finally {
      raf.close();
    }
  }
}
