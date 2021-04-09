import 'package:flutter/material.dart';
import '../Classroom/EnrollClassrooms/ClassroomPanelEnrolled.dart';
import '../Classroom/UserClassrooms/ClassroomPanel.dart';
import 'dart:math' as math;

class SearchList extends StatefulWidget {
  final classList;
  final enrolled;

  const SearchList({Key key, this.classList, this.enrolled}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  void initState() {
    super.initState();
    print(this.widget.classList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {
                    showSearch(
                        context: context,
                        delegate: DataSearch(
                            this.widget.classList, this.widget.enrolled))
                  })
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final classrooms;
  final enrolled;

  DataSearch(this.classrooms, this.enrolled);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final classList = query.isEmpty
        ? this.classrooms
        : this
            .classrooms
            .where((obj) => obj['name'].toString().startsWith(query))
            .toList();

    return ListView.builder(
        itemCount: classList.length,
        itemBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
              child: Container(
                margin: EdgeInsets.only(right: 10.0),
                width: 250,
                child: InkWell(
                  onTap: enrolled
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClassroomPanelEnrolled(
                                    classId: classList[index]['uid'],
                                  )));
                        }
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClassroomPanel(
                                    classId: classList[index]['uid'],
                                  )));
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7)),
                          ),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.60),
                          child: Container(
                            height: 130,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                classList[index]['name'].toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 36.0),
                              )),
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person_pin_outlined),
                                  ),
                                  Text(
                                    classList[index]['teacher']['username']
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montseratt',
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
