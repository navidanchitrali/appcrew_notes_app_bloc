import 'package:appcrew_notes_app/data/model/note_model.dart';
import 'package:equatable/equatable.dart';

 
abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String title, content;
  AddNoteEvent(this.title, this.content);
}

class UpdateNoteEvent extends NotesEvent {
  final NoteModel note;
  UpdateNoteEvent(this.note);
}

class DeleteNoteEvent extends NotesEvent {
  final String noteId;
  DeleteNoteEvent(this.noteId);
}

class SearchNotesEvent extends NotesEvent {
  final String query;
  SearchNotesEvent(this.query);
}
