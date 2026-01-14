import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/db_service.dart';
import 'note_form_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DbService _dbService = DbService();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await _dbService.getNotes();
    setState(() {
      notes = data;
    });
  }

  Future<void> deleteNote(int id) async {
    await _dbService.deleteNote(id);
    loadNotes();
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Catatan"),
        content: const Text("Yakin ingin menghapus catatan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              deleteNote(id);
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
      ),
      body: notes.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final note = notes[i];
                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NoteDetailScreen(note: note),
                        ),
                      );
                      loadNotes(); // refresh setelah balik
                    },
                    onLongPress: () =>
                        showDeleteDialog(note.id!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteFormScreen(),
            ),
          );

          loadNotes(); 
        },
      ),
    );
  }
}
