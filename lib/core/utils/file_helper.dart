import 'file_helper_stub.dart'
    if (dart.library.js_interop) 'file_helper_web.dart'
    if (dart.library.io) 'file_helper_io.dart';

class FileHelper {
  FileHelper._();

  /// Downloads text content as a file conditionally per platform.
  static Future<void> downloadFile({
    required String content,
    required String fileName,
    required String mimeType,
  }) async {
    await downloadFileImpl(
      content: content,
      fileName: fileName,
      mimeType: mimeType,
    );
  }
}
