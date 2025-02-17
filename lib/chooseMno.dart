import 'package:Trackery/Animation/FadeAnimation.dart';
import 'package:Trackery/homepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'gradappbar.dart';
import 'dart:convert';

class ChooseMno extends StatelessWidget {
  final String data;
  final String type;
  const ChooseMno({Key key, @required this.data, @required this.type})
      : super(key: key);

  Future<List<String>> searchMno() async {
    List<String> silist = [];
    if (type == "sno") {
      var url =
          'https://napecinventory.azurewebsites.net/Api/SearchSiSno/' + data;
      var response = await http.get(url);
      var strlist = json.decode(response.body);
      for (var x in strlist) {
        final sno = x;
        silist.add(sno);
      }
      return silist;
    } else if (type == "mno") {
      var url =
          'https://napecinventory.azurewebsites.net/Api/SearchSiMno/' + data;
      var response = await http.get(url);
      var strlist = json.decode(response.body);

      for (var x in strlist) {
        silist.add(x);
      }
      return silist;
    }
    return silist;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradAppBar(
        title: "Trackery",
        gradBegin: Colors.indigo[500],
        gradEnd: Colors.indigo[200],
      ),
      body: Container(
        child: FutureBuilder(
          future: searchMno(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              print(data);
              return makeBody(data);
            } else {
              return Container(
                child: Center(child: Text("Trackery is loading...")),
              );
            }
          },
        ),
      ),
    );
  }

  _ChooseMno createState() => _ChooseMno();
}

class _ChooseMno extends State {
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ChooseSno extends StatelessWidget {
  final String data;
  const ChooseSno({Key key, @required this.data}) : super(key: key);

  Future<List<String>> searchMnoEx() async {
    List<String> silist = [];
    var url =
        'https://napecinventory.azurewebsites.net/Api/SearchSiMnoEx/' + data;
    var response = await http.get(url);
    var strlist = json.decode(response.body);

    for (var x in strlist) {
      silist.add(x);
    }
    return silist;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradAppBar(
        title: "Trackery",
        gradBegin: Colors.indigo[500],
        gradEnd: Colors.indigo[200],
      ),
      body: Container(
        child: FutureBuilder(
          future: searchMnoEx(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              print(data);
              return makeBodySno(data);
            } else {
              return Container(
                child: Center(child: Text("Trackery is loading...")),
              );
            }
          },
        ),
      ),
    );
  }

  _ChooseSno createState() => _ChooseSno();
}

class _ChooseSno extends State {
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ShowDetails extends StatelessWidget {
  final String sno;
  const ShowDetails({Key key, @required this.sno}) : super(key: key);

  checkDetails() async {
    var url =
        'https://napecinventory.azurewebsites.net/Api/SearchSiSnoEx/' + sno;
    var response = await http.get(url);
    var x = json.decode(response.body);
    FullSno result = new FullSno(
        x['sno'],
        x['brand'],
        x['eq'],
        x['mno'],
        x['ava'],
        x['location'],
        x['owner'],
        x['status'],
        x['eos'],
        x['eol'],
        x['image'],
        x['remarks'],
        x['firmware']);
    if (result.eos == null) {
      result.eos = "-";
    }
    if (result.eol == null) {
      result.eol = "-";
    }
    if (result.remarks == null) {
      result.remarks = "-";
    }
    if (result.firmware == null) {
      result.firmware = "-";
    }
    if (result.image == null) {
      result.image = "https://img.icons8.com/ios/452/no-image.png";
    }
    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradAppBar(
        title: "Trackery",
        gradBegin: Colors.indigo[500],
        gradEnd: Colors.indigo[200],
      ),
      body: Container(
        child: FutureBuilder(
          future: checkDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              FullSno data = snapshot.data;
              print(data);
              return Card(
                  elevation: 10.0,
                  margin: new EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 130.0),
                  child: new Container(
                      decoration: BoxDecoration(color: Colors.indigo.shade300),
                      child: Column(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.all(10.0)),
                          buildRow("• Serial Number : ", data.sno),
                          buildRow("• Model Number : ", data.mno),
                          buildRow("• Brand : ", data.brand),
                          buildRow("• Type : ", data.eq),
                          buildRow("• Availability : ", data.ava),
                          buildRow("• Location : ", data.location),
                          buildRow("• Status : ", data.status),
                          buildRow("• Owner : ", data.owner),
                          buildRow("• EOS : ", data.eos),
                          buildRow("• EOL : ", data.eol),
                          buildRow("• Firmware : ", data.firmware),
                          buildRow("• Remarks : ", data.remarks + "\n"),
                          Center(child: Image.network(data.image, width: 150.0))
                        ],
                      )));
            } else {
              return Container(
                child: Center(child: Text("Trackery is loading...")),
              );
            }
          },
        ),
      ),
    );
  }
}

//Display details
buildRow(text, datareturn) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(padding: new EdgeInsets.all(5.0)),
      Text(
        text,
        style: TextStyle(
            color: Colors.orange.shade100,
            fontSize: 17.0,
            fontFamily: 'Roboto'),
      ),
      Expanded(
        child: Text(
          datareturn,
          maxLines: 3,
          style: TextStyle(
              color: Colors.white, fontSize: 17.0, fontFamily: "Roboto"),
        ),
      ),
    ],
  );
}

//FullSno model
class FullSno {
  final String sno;
  final String brand;
  final String eq;
  final String mno;
  final String ava;
  final String location;
  final String owner;
  final String status;
  String eos;
  String eol;
  String image;
  String firmware;
  String remarks;

  FullSno(
      this.sno,
      this.brand,
      this.eq,
      this.mno,
      this.ava,
      this.location,
      this.owner,
      this.status,
      this.eos,
      this.eol,
      this.image,
      this.remarks,
      this.firmware);
}

//Result of search SNO
makeBody(datax) {
  return ListView.builder(
    itemCount: datax.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.indigo.shade300),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Text((index + 1).toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(
                datax[index],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ChooseSno(data: datax[index])));
              },
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0)),
        ),
      );
    },
  );
}

makeBodySno(datax) {
  return ListView.builder(
    itemCount: datax.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.indigo.shade300),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: Text((index + 1).toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(
                datax[index],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ShowDetails(sno: datax[index])));
              },
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0)),
        ),
      );
    },
  );
}
