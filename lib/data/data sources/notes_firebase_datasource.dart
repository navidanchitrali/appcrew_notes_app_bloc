import 'package:appcrew_notes_app/data/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesFirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference getNotesRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes');
  }

  Future<void> addNote(NoteModel note) async {
    await getNotesRef(note.userId).doc(note.id).set(note.toJson());
  }

  Future<void> updateNote(NoteModel note) async {
    await getNotesRef(note.userId).doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'updated_at': note.updatedAt,
    });
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await getNotesRef(userId).doc(noteId).delete();
  }

  Stream<List<NoteModel>> getNotes(String userId) {
    return getNotesRef(userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
