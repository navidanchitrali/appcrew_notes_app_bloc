import 'package:appcrew_notes_app/data/data%20sources/notes_firebase_datasource.dart';
import 'package:appcrew_notes_app/data/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes/notes_bloc.dart';
import '../../bloc/notes/notes_event.dart';
import '../../bloc/notes/notes_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
 
 



 

class NotesScreen extends StatelessWidget {
  final String userId;

  const NotesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: BlocProvider(
        create: (_) => NotesBloc(
          NotesFirebaseDatasource(),
          userId,
        )..add(LoadNotes()),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
  backgroundColor: Colors.indigo,
  iconTheme: const IconThemeData(color: Colors.white),
  title: const Text(
    'My Notes',
    style: TextStyle(color: Colors.white),
  ),
  actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'logout') {
          context.read<AuthBloc>().add(const LogoutEvent());
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18,color: Colors.black,),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
    ),
  ],
),

            body: Column(
              children: [
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (q) {
                      context.read<NotesBloc>().add(SearchNotesEvent(q));
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.notes.isEmpty) {
                        return const Center(child: Text('No notes yet'));
                      }
      
                    return ListView.separated(
  padding: const EdgeInsets.all(16),
  itemCount: state.notes.length,
  separatorBuilder: (_, __) => const SizedBox(height: 12),
  itemBuilder: (context, index) {
    final note = state.notes[index];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                _showEditNoteDialog(context, note);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<NotesBloc>().add(DeleteNoteEvent(note.id));
              },
            ),
          ],
        ),
      ),
    );
  },
);

                    
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: SizedBox(
              width: 120,
              child: FloatingActionButton(
                backgroundColor: Colors.indigo,
                onPressed: () => _showAddNoteDialog(context),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Add Note ',style: TextStyle(color: Colors.white),),
                    Icon(Icons.add,color: Colors.white,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }




  void _showEditNoteDialog(BuildContext context, NoteModel note) {
  final titleCtrl = TextEditingController(text: note.title);
  final contentCtrl = TextEditingController(text: note.content);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: contentCtrl,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedNote = note.copyWith(
              title: titleCtrl.text.trim(),
              content: contentCtrl.text.trim(),
              updatedAt: DateTime.now(),
            );

            context.read<NotesBloc>().add(UpdateNoteEvent(updatedNote));
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}


  void _showAddNoteDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NotesBloc>().add(
                    AddNoteEvent(
                      titleCtrl.text.trim(),
                      contentCtrl.text.trim(),
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
