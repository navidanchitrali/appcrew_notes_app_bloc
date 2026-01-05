import 'package:appcrew_notes_app/data/model/note_model.dart';
  

class NotesState {
  final List<NoteModel> notes;     
  final List<NoteModel> allNotes;  
  final bool loading;

  const NotesState({
    this.notes = const [],
    this.allNotes = const [],
    this.loading = false,
  });

  NotesState copyWith({
    List<NoteModel>? notes,
    List<NoteModel>? allNotes,
    bool? loading,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      allNotes: allNotes ?? this.allNotes,
      loading: loading ?? this.loading,
    );
  }
}
