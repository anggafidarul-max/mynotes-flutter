import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  void _openWhatsApp() async {
    final text = Uri.encodeComponent(
        "Judul: ${note.title}\n\n${note.content}");
    final url = "https://wa.me/?text=$text";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Tidak bisa membuka WhatsApp");
    }
  }

  void _openEmail() async {
    final subject = Uri.encodeComponent(note.title);
    final body = Uri.encodeComponent(note.content);
    final url = "mailto:?subject=$subject&body=$body";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Tidak bisa membuka Email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Catatan"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(note.content, style: const TextStyle(fontSize: 16)),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openWhatsApp,
                    icon: const Icon(Icons.chat),
                    label: const Text("WhatsApp"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openEmail,
                    icon: const Icon(Icons.email),
                    label: const Text("Email"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
