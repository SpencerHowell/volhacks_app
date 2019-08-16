import 'package:flutter/material.dart';

class ScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        _EventViewWidget(),
        _EventViewWidget(),
        _EventViewWidget(),
      ],
    );
  }
}

class _EventViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        InkWell(
          onTap: () => showDialog(
              context: context, builder: (context) => _dialogBuilder(context)),
          child: Material(
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text('12:00 PM',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ],
              ),
            ),
            color: Colors.lightBlue,
          ),
        ),
        Container(
          // Padding
          height: 10,
        )
      ],
    );
  }

  Widget _dialogBuilder(BuildContext context) {
    return SimpleDialog(children: [Container(width: 80.0, height: 80.0)]);
  }
}
