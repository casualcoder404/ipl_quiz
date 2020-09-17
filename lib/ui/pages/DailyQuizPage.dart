import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class DailyQuizPage extends StatefulWidget {
  @override
  _DailyQuizPageState createState() => _DailyQuizPageState();
}

class _DailyQuizPageState extends State<DailyQuizPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  String dailyQ = '';
  Map<int, String> op = {1: '', 2: '', 3: '', 4: ''};
  String op1 = '';
  String op2 = '';
  String op3 = '';
  String op4 = '';

  int selectedA = 0;
  int correctO = 0;

  bool loading = false;
  bool answered = false;

  @override
  void initState() {
    getDailyQA();
    super.initState();
  }

  getDailyQA() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .doc('dailyQ/data')
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        if (doc.data()['q'] != '') {
          setState(() {
            dailyQ = doc.data()['q'];
            op = {
              1: doc.data()['o1'],
              2: doc.data()['o2'],
              3: doc.data()['o3'],
              4: doc.data()['o4'],
            };

            correctO = int.parse(doc.data()['a']);
          });
        }
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('Daily Quiz'),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: (loading)
                  ? CircularProgressIndicator()
                  : Column(
                      children: <Widget>[
                        (loading)
                            ? CircularProgressIndicator()
                            : Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Text("Q"),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      dailyQ,
                                      softWrap: true,
                                      style: MediaQuery.of(context).size.width >
                                              800
                                          ? _questionStyle.copyWith(
                                              fontSize: 30.0)
                                          : _questionStyle,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 20.0),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //todo:show options
                              RadioListTile(
                                title: Text(
                                  op[1],
                                  style: MediaQuery.of(context).size.width > 800
                                      ? TextStyle(fontSize: 30.0)
                                      : null,
                                ),
                                groupValue: selectedA,
                                value: 1,
                                onChanged: (value) {
                                  setState(() {
                                    if (!answered) selectedA = 1;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text(
                                  op[2],
                                  style: MediaQuery.of(context).size.width > 800
                                      ? TextStyle(fontSize: 30.0)
                                      : null,
                                ),
                                groupValue: selectedA,
                                value: 2,
                                onChanged: (value) {
                                  setState(() {
                                    if (!answered) selectedA = 2;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text(
                                  op[3],
                                  style: MediaQuery.of(context).size.width > 800
                                      ? TextStyle(fontSize: 30.0)
                                      : null,
                                ),
                                groupValue: selectedA,
                                value: 3,
                                onChanged: (value) {
                                  setState(() {
                                    if (!answered) selectedA = 3;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text(
                                  op[4],
                                  style: MediaQuery.of(context).size.width > 800
                                      ? TextStyle(fontSize: 30.0)
                                      : null,
                                ),
                                groupValue: selectedA,
                                value: 4,
                                onChanged: (value) {
                                  setState(() {
                                    if (!answered) selectedA = 4;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              padding: MediaQuery.of(context).size.width > 800
                                  ? const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 64.0)
                                  : null,
                              child: Text(
                                "Submit",
                                style: MediaQuery.of(context).size.width > 800
                                    ? TextStyle(fontSize: 30.0)
                                    : null,
                              ),
                              onPressed: _nextSubmit,
                            ),
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    //todo: design for answer submission

    setState(() {
      answered = true;
    });

    //if correct
    if (selectedA == correctO) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF222222),
            title: Text(
              'Congratulations!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'You\'ve earned 10 coins',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  new FlatButton(
                    child: new Text("Cool!"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              // usually buttons at the bottom of the dialog
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF222222),
            title: Text(
              'Try again next time.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Correct answer is ${op[correctO]}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  new FlatButton(
                    child: new Text("Alright!"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              // usually buttons at the bottom of the dialog
            ],
          );
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
