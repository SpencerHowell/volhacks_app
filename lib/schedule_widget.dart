import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleWidget extends StatelessWidget {
  static const List<MockEventInfo> _eventList = [
    const MockEventInfo(
        name: "Kick Off",
        datetime: "2019-09-27 17:00:00Z",
        location: "Auditorium",
        description: "Let's get started!"),
    const MockEventInfo(
        name: "Breakfast",
        datetime: "2019-09-28 07:00:00Z",
        location: "Min Kao 601",
        description: "Eggs and bacon"),
    const MockEventInfo(
        name: "Final Presentations",
        datetime: "2019-09-29 09:00:00Z",
        location: "Daughtery Auditorium",
        description: "Demo to everyone!"),
  ];

  static final timeFormat = new DateFormat.jm();
  static final dateTimeFormat = new DateFormat.EEEE().add_jm();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _eventList.length,
        itemBuilder: (context, index) =>
            _buildEventListItem(context, _eventList[index]));
  }

  Widget _buildEventListItem(BuildContext context, MockEventInfo eventInfo) {
    var dateTime = DateTime.parse(eventInfo.datetime);

    return new Column(
      children: <Widget>[
        InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (context) => _dialogBuilder(context, eventInfo)),
          child: Material(
            child: Container(
              height: 79,
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    eventInfo.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 19.0,
                    ),
                  ),
                  Text(
                    timeFormat.format(dateTime),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 19.0,
                    ),
                  ),
                ],
              ),
            ),
            color: Colors.lightBlue,
          ),
        ),
        SizedBox(
          // Padding
          height: 10,
        ),
      ],
    );
  }

  Widget _dialogBuilder(BuildContext context, MockEventInfo eventInfo) {

    var dateTimeString = dateTimeFormat.format(DateTime.parse(eventInfo.datetime));

    return SimpleDialog(
      children: [
        Text(
          eventInfo.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        Text(
          dateTimeString,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        Text(
          eventInfo.location,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        Text(
          eventInfo.description,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontSize: 19.0,
          ),
        ),
      ],
    );
  }
}

class MockEventInfo {
  const MockEventInfo({this.name, this.datetime, this.location = "", this.description});

  final String name;
  final String datetime;
  final String location;
  final String description;
}
