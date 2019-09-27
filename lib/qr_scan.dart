/* Modified code from Alfian Losari on Medium
   "Building Flutter QR Code Generator, Scanner, and Sharing App"
   https://medium.com/flutter-community/building-flutter-qr-code-generator-scanner-and-sharing-app-703e73b228d3
 */

import 'dart:async';
import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanScreen extends StatefulWidget {
  final DocumentReference eventDoc;

  ScanScreen(this.eventDoc);

  @override
  _ScanState createState() => new _ScanState(eventDoc);
}

class _ScanState extends State<ScanScreen> {
  final DocumentReference eventDoc;
  String barcode = "";
  CollectionReference attendees = Firestore.instance.collection("people");

  _ScanState(this.eventDoc);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Scan In'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  barcode,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      register(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  /* Add attendee name to list of attendees for this event, as well as to the
   * master list if it has not already been added. Increase the attendee's score
   * by one for this event */
  register(String username) async {
    final personSnapshot = await attendees.document(username).get();
    DocumentSnapshot eventSnapshot = await eventDoc.get();

    if (personSnapshot == null || !personSnapshot.exists) {
      attendees.document(username).setData({
        'name': username,
        'score': 0,
      });
    }

    // Refresh snapshot so next scan in has new data
    eventSnapshot = await eventDoc.get();

    // Ensure that attendees can't be counted twice for the same event
    var eventAttendees = new List<String>.from(eventSnapshot['attendees']);
    if (!eventAttendees.contains(username)) {
      attendees.document(username).updateData({
        'score': FieldValue.increment(1),
      });

      eventSnapshot.reference.updateData({
        'attendees': FieldValue.arrayUnion([username])}
      );
    }
  }
}
