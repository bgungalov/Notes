import 'package:flutter/material.dart';

class NoteInheritedWidget extends InheritedWidget {

  final notes = [
    {
      'title': 'My note title',
      'text': 'My note text'
    },
  ];

  NoteInheritedWidget(Widget child) : super(child: child);

  static NoteInheritedWidget of(BuildContext context) {
    // ignore: deprecated_member_use
    return (context.inheritFromWidgetOfExactType(NoteInheritedWidget)as NoteInheritedWidget);
  }

  @override
  bool updateShouldNotify( NoteInheritedWidget oldWidget) {
    return oldWidget.notes != notes;
  }
}