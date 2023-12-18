import 'package:hive/hive.dart';
import 'package:store_data/Model/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box('notes');
}
