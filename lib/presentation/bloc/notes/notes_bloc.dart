// ignore_for_file: avoid_print

import 'dart:async';
import 'package:appcrew_notes_app/data/data%20sources/notes_firebase_datasource.dart';
import 'package:appcrew_notes_app/data/model/note_model.dart';
import 'package:appcrew_notes_app/presentation/bloc/notes/notes_event.dart';
import 'package:appcrew_notes_app/presentation/bloc/notes/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesFirebaseDatasource datasource;
  final String userId;
  StreamSubscription? _sub;

  NotesBloc(this.datasource, this.userId) : super(const NotesState()) {
    on<LoadNotes>(_load);
    on<AddNoteEvent>(_add);
    on<UpdateNoteEvent>(_update);
    on<DeleteNoteEvent>(_delete);
    on<SearchNotesEvent>(_search);
  }

Future<void> _load(LoadNotes event, Emitter<NotesState> emit) async {
  emit(state.copyWith(loading: true));

  await _sub?.cancel();

  _sub = datasource.getNotes(userId).listen(null); // placeholder

  await for (final notes in datasource.getNotes(userId)) {
    if (emit.isDone) return;
    emit(state.copyWith(notes: notes, allNotes: notes, loading: false));
  }
}




  Future<void> _add(AddNoteEvent event, Emitter<NotesState> emit) async {
    final note = NoteModel(
      id: const Uuid().v4(),
      title: event.title,
      content: event.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: userId,
    );
    await datasource.addNote(note);
  }

Future<void> _update(UpdateNoteEvent event, Emitter<NotesState> emit) async {
  try {
    await datasource.updateNote(event.note);
    
    // Update local state immediately after update
    final updatedNotes = state.notes.map((n) {
      return n.id == event.note.id ? event.note : n;
    }).toList();

    emit(state.copyWith(notes: updatedNotes));
  } catch (e) {
    // Handle error if needed
    print("Update failed: $e");
  }
}


  Future<void> _delete(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    await datasource.deleteNote(userId, event.noteId);
  }

void _search(SearchNotesEvent event, Emitter<NotesState> emit) {
  final query = event.query.toLowerCase();
  if (query.isEmpty) {
    emit(state.copyWith(notes: state.allNotes));
  } else {
    final filtered = state.allNotes
        .where((n) => n.title.toLowerCase().contains(query))
        .toList();
    emit(state.copyWith(notes: filtered));
  }
}


  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
