import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

Future<void> downloadFileImpl({
  required String content,
  required String fileName,
  required String mimeType,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = io.File('${directory.path}/$fileName');
  await file.writeAsString(content);
}
