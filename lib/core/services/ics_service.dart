import 'package:intl/intl.dart';
import '../../features/cards/domain/models/credit_card.dart';
import '../utils/file_helper.dart';

class IcsService {
  IcsService._();

  /// Generates and triggers download of an .ics calendar file for a card's due date at a custom time.
  static Future<void> generateAndDownloadIcs(CreditCard card, DateTime resolvedDueDate) async {
    final bankName = card.bankName;
    final outstanding = card.outstandingAmount;
    final notes = card.notes;
    final reminderDays = card.reminderDaysBefore;
    final reminderTime = card.reminderTime; // e.g. '09:00' or '20:30'

    // Parse hour and minute from the custom reminderTime setting
    final timeParts = reminderTime.split(':');
    final hour = timeParts.isNotEmpty ? (int.tryParse(timeParts[0]) ?? 9) : 9;
    final minute = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

    // Create the start and end DateTime in local floating time
    final eventStart = DateTime(
      resolvedDueDate.year,
      resolvedDueDate.month,
      resolvedDueDate.day,
      hour,
      minute,
    );
    final eventEnd = eventStart.add(const Duration(hours: 1));

    // Formatter for UTC stamping
    final dtstampFormat = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    final now = DateTime.now().toUtc();
    final dtstamp = dtstampFormat.format(now);

    // Formatter for local floating time (No 'Z' suffix, so it floats to user's device local timezone)
    final floatTimeFormat = DateFormat("yyyyMMdd'T'HHmmss");
    final dtstart = floatTimeFormat.format(eventStart);
    final dtend = floatTimeFormat.format(eventEnd);

    // Alarm trigger: exactly at event time ('PT0M') or relative days before ('-P[N]D')
    final trigger = reminderDays > 0 ? '-P${reminderDays}D' : 'PT0M';

    final cleanNotes = notes.replaceAll('\n', '\\n').replaceAll('\r', '');

    final icsContent = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//CardDue//Credit Card Reminder//EN')
      ..writeln('CALSCALE:GREGORIAN')
      ..writeln('METHOD:PUBLISH')
      ..writeln('BEGIN:VEVENT')
      ..writeln('UID:${card.id}_${resolvedDueDate.millisecondsSinceEpoch}@carddue.com')
      ..writeln('DTSTAMP:$dtstamp')
      ..writeln('DTSTART:$dtstart')
      ..writeln('DTEND:$dtend')
      ..writeln('SUMMARY:Pay $bankName Credit Card Bill')
      ..writeln('DESCRIPTION:Outstanding Amount: ${outstanding.toStringAsFixed(2)}\\nMinimum Due: ${card.minimumDue.toStringAsFixed(2)}\\nNotes: $cleanNotes')
      ..writeln('BEGIN:VALARM')
      ..writeln('TRIGGER:$trigger')
      ..writeln('ACTION:DISPLAY')
      ..writeln('DESCRIPTION:Reminder')
      ..writeln('END:VALARM')
      ..writeln('END:VEVENT')
      ..writeln('END:VCALENDAR');

    final formattedBank = bankName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final fileName = 'pay_${formattedBank}_bill.ics';
    
    await FileHelper.downloadFile(
      content: icsContent.toString(),
      fileName: fileName,
      mimeType: 'text/calendar',
    );
  }
}
