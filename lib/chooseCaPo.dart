import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'animatedloading.dart';
import 'gradappbar.dart';
import 'dart:convert';

class FullCa {
  String cname;
  String sla;
  String necstart;
  String necend;
  String pono;
  String industry;
  String brand;
  String mno;
  String sno;
  String equipment;
  String distributor;
  String vendorcno;
  String vendstart;
  String vendend;
  String projectname;
  String itq;
  String remarks;
  String smartnet;
  String salesman;

  FullCa(
      this.cname,
      this.sla,
      this.necstart,
      this.necend,
      this.pono,
      this.industry,
      this.brand,
      this.mno,
      this.sno,
      this.equipment,
      this.distributor,
      this.vendorcno,
      this.vendstart,
      this.vendend,
      this.projectname,
      this.itq,
      this.remarks,
      this.smartnet,
      this.salesman);
}

class CaPoSno {
  String pono;
  String sno;
  CaPoSno(this.pono, this.sno);
}

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
                        builder: (context) =>
                            ChooseCaPoEx(pono: datax[index])));
              },
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0)),
        ),
      );
    },
  );
}

makeBody2(datax) {
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
                datax[index].sno,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // subtitle: Row(
              //   children: <Widget>[
              //     Text("PO# : " + datax[index].pono,
              //         style: TextStyle(color: Colors.white))
              //   ],
              // ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ShowDetails(
                            sno: datax[index].sno, pono: datax[index].pono)));
              },
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0)),
        ),
      );
    },
  );
}

//1st Method
class ChooseCaPo extends StatelessWidget {
  final String data;
  const ChooseCaPo({Key key, @required this.data}) : super(key: key);

  Future<List<String>> searchbypo() async {
    List<String> calist = [];
    var url = 'https://napecinventory.azurewebsites.net/Api/Searchbypo/' + data;
    var response = await http.get(url);
    var strlist = json.decode(response.body);
    for (var x in strlist) {
      calist.add(x);
    }
    return calist;
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
          future: searchbypo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              print(data);
              return makeBody(data);
            } else {
              return Container(
                  child: Column(
                children: <Widget>[
                  Padding(padding: new EdgeInsets.only(top: 200.0)),
                  Center(child: AnimatedAppBar()),
                  Center(child: Text("Trackery is loading..."))
                ],
              ));
            }
          },
        ),
      ),
    );
  }

  _ChooseCaPo createState() => _ChooseCaPo();
}

class _ChooseCaPo extends State {
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//2nd Method
class ChooseCaPoEx extends StatelessWidget {
  final String pono;
  const ChooseCaPoEx({Key key, @required this.pono}) : super(key: key);

  Future<List<CaPoSno>> searchbypoex() async {
    List<CaPoSno> calist = [];
    var url =
        'https://napecinventory.azurewebsites.net/Api/Searchbypoex/' + pono;
    var response = await http.get(url);
    var strlist = json.decode(response.body);
    for (var x in strlist) {
      CaPoSno rs = new CaPoSno(x['po'], x['sno']);
      calist.add(rs);
    }
    return calist;
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
          future: searchbypoex(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              print(data);
              return makeBody2(data);
            } else {
              return Container(
                  child: Column(
                children: <Widget>[
                  Padding(padding: new EdgeInsets.only(top: 200.0)),
                  Center(child: AnimatedAppBar()),
                  Center(child: Text("Trackery is loading..."))
                ],
              ));
            }
          },
        ),
      ),
    );
  }

  _ChooseCaPoEx createState() => _ChooseCaPoEx();
}

class _ChooseCaPoEx extends State {
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//3rd Method
class ShowDetails extends StatelessWidget {
  final String sno;
  final String pono;
  const ShowDetails({Key key, @required this.pono, @required this.sno})
      : super(key: key);

  checkDetails() async {
    var url = 'https://napecinventory.azurewebsites.net/Api/Searchbypoex2/' +
        pono +
        '/' +
        sno;
    var response = await http.get(url);
    var x = json.decode(response.body);
    FullCa result = new FullCa(
        x['cname'],
        x['sla'],
        x['necstart'],
        x['necend'],
        x['pono'],
        x['industry'],
        x['brand'],
        x['mno'],
        x['sno'],
        x['equipment'],
        x['distributor'],
        x['vendorcno'],
        x['vendstart'],
        x['vendend'],
        x['projectname'],
        x['itq'],
        x['remarks'],
        x['smartnet'],
        x['salesman']);

    if (result.sla == null || result.sla == "") {
      result.sla = "-";
    }
    if (result.necstart == null || result.necstart == "") {
      result.necstart = "-";
    }
    if (result.necend == null || result.necend == "") {
      result.necend = "-";
    }
    if (result.vendorcno == null || result.vendorcno == "") {
      result.vendorcno = "-";
    }
    if (result.vendstart == null || result.vendstart == "") {
      result.vendstart = "-";
    }
    if (result.vendend == null || result.vendend == "") {
      result.vendend = "-";
    }
    if (result.distributor == null || result.distributor == "") {
      result.distributor = "-";
    }
    if (result.projectname == null || result.projectname == "") {
      result.projectname = "-";
    }
    if (result.itq == null || result.itq == "") {
      result.itq = "-";
    }
    if (result.remarks == null || result.remarks == "") {
      result.remarks = "-";
    }
    if (result.smartnet == null || result.smartnet == "") {
      result.smartnet = "-";
    }
    if (result.salesman == null || result.salesman == "") {
      result.salesman = "-";
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
              FullCa data = snapshot.data;
              print(data);
              return Card(
                  elevation: 10.0,
                  margin: new EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 50.0),
                  child: new Container(
                      decoration: BoxDecoration(color: Colors.indigo.shade300),
                      child: Column(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.all(10.0)),
                          buildRow("• Serial Number : ", data.sno),
                          buildRow("• Customer PO# : ", data.pono),
                          new Divider(
                            color: Colors.white,
                          ),
                          buildRow("• Company : ", data.cname),
                          buildRow("• SLA : ", data.sla),
                          buildRow("• NEC Maintenance \n  Cert Start Date : ",
                              data.necstart),
                          buildRow("• NEC Maintenance \n  Cert End Date : ",
                              data.necend),
                          buildRow("• Industry : ", data.industry),
                          new Divider(
                            color: Colors.white,
                          ),
                          buildRow("• Model Number : ", data.mno),
                          buildRow("• Brand : ", data.brand),
                          buildRow("• Smartnet : ", data.smartnet),
                          buildRow("• Distributor : ", data.distributor),
                          buildRow("• Vendor Contact# : ", data.vendorcno),
                          buildRow("• Vendor Maintenance \n  Start Date : ",
                              data.vendstart),
                          buildRow("• Vendor Maintenance \n  End Date : ",
                              data.vendend),
                          buildRow("• Project Name  : ", data.projectname),
                          buildRow("• ITQ No./Bulk Tender No. : ", data.itq),
                          buildRow("• Remarks : ", data.remarks + "\n"),
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
