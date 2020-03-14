import 'package:flutter/material.dart';
import 'package:notes/inherited_widgets/note_inherited_widget.dart';
import 'package:notes/providers/note_provider.dart';

enum NoteMode {
  Editing,
  Adding
}

class Note extends StatefulWidget {

  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note);

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
            widget.noteMode == NoteMode.Adding ? 'Add note' : 'Edit note'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: 'Note title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ),
                autofocus: false,
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
              Container(height: 8,),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                    hintText: 'Note text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ),
                autofocus: false,
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
              Container(width: null, height: 16.0,),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _NoteButton('Save', Colors.green, () {
                      final title = _titleController.text;
                      final text = _textController.text;

                      if (widget?.noteMode == NoteMode.Adding) {
                        NoteProvider.insertNote({
                          'title': title,
                          'text': text
                        });
                      } else if (widget?.noteMode == NoteMode.Editing) {
                        NoteProvider.updateNote({
                          'id': widget.note['id'],
                          'title': _titleController.text,
                          'text': _textController.text,
                        });
                      }
                      Navigator.pop(context);
                    }),
                    Container(width: null, height: 16.0,),
                    _NoteButton('Discard', Colors.grey, () {
                      Navigator.pop(context);
                    }),
                    widget.noteMode == NoteMode.Editing ?

                    _NoteButton('Delete', Colors.red, () async {
                      await NoteProvider.deleteNote(widget.note['id']);
                      Navigator.pop(context);
                    })
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 40,
      color: _color,
    );
  }
}