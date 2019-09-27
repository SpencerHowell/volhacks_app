/* Code by Alfian Losari const Medium
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
  final DocumentSnapshot document;

  ScanScreen(this.document);

  @override
  _ScanState createState() => new _ScanState(document);
}

class _ScanState extends State<ScanScreen> {
  final DocumentSnapshot document;
  String barcode = "";
  CollectionReference attendees = Firestore.instance.collection("people");

  _ScanState(this.document);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(document['name'] + ' Scan In'),
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

  register(String username) async {

    // Add attendee name to master list of attendees and increase their score
    // by one for each event
    final personSnapshot = await attendees.document(username).get();

    if (personSnapshot == null || !personSnapshot.exists) {
      attendees.document(username).setData({
        'name': username,
        'score': 0,
      });
    }

    //TODO refresh snapshot so next scan in has new data

    // Ensure that attendees can't be counted twice for the same event
    var eventAttendees = new List<String>.from(document['attendees']);
    if (!eventAttendees.contains(username)) {
      attendees.document(username).updateData({
        'score': FieldValue.increment(1),
      });

      document.reference.updateData({
        'attendees': FieldValue.arrayUnion([username])}
      );
    }
  }
}
