import 'package:flutter/material.dart';

class UniversalSearchPanel extends SearchDelegate {
  final classrooms;
  final enrolledClassrooms;
  final q;
  var _userList;

  UniversalSearchPanel(this.classrooms, this.enrolledClassrooms, this.q);

  @override
  String get searchFieldLabel => q.toString();

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
