import 'package:intl/intl.dart';
import '../../features/cards/domain/models/credit_card.dart';
import '../utils/file_helper.dart';

class IcsService {
  IcsService._();

  /// Generates and triggers download of an .ics calendar file for a card's due date.
  static Future<void> generateAndDownloadIcs(CreditCard card, DateTime resolvedDueDate) async {
    final bankName = card.bankName;
    final outstanding = card.outstandingAmount;
    final notes = card.notes;
    final reminderDays = card.reminderDaysBefore;

    final dateFormat = DateFormat('yyyyMMdd');
    final dtstampFormat = DateFormat("yyyyMMdd'T'HHmmss'Z'");

    final now = DateTime.now().toUtc();
    final dtstamp = dtstampFormat.format(now);
    final dtstart = dateFormat.format(resolvedDueDate);
    
    // All-day event end date is exclusive (day after start date)
    final dtend = dateFormat.format(resolvedDueDate.add(const Duration(days: 1)));

    // Alarm trigger (e.g., -P1D for 1 day before, or -PT9H for 9:00 AM on due day)
    final trigger = reminderDays > 0 ? '-P${reminderDays}D' : '-PT9H';

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
      ..writeln('DTSTART;VALUE=DATE:$dtstart')
      ..writeln('DTEND;VALUE=DATE:$dtend')
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
