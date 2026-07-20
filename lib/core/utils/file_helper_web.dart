import 'dart:convert';
import 'package:web/web.dart' as web;

Future<void> downloadFileImpl({
  required String content,
  required String fileName,
  required String mimeType,
}) async {
  final encodedUri = Uri.dataFromString(
    content,
    mimeType: mimeType,
    encoding: utf8,
  ).toString();
  
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = encodedUri;
  anchor.style.display = 'none';
  anchor.download = fileName;
  
  web.document.body?.appendChild(anchor);
  anchor.click();
  web.document.body?.removeChild(anchor);
}
