import 'package:flutter/material.dart';

class ChannelList extends StatelessWidget {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 250,
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    color: Colors.grey[200],
                    child: Container(
                      child: Center(
                          child: Text(
                        'Channel  ' + numbers[index].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 36.0),
                      )),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
