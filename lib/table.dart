import 'dart:convert';

import 'package:flutter/material.dart';
import 'db.dart';

class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadReports();
  }

  // Load all users from the database
  _loadUsers() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = users;
    });
  }

  // Load all users from the database
  _loadReports() async {
    List<Map<String, dynamic>> reports = await DatabaseHelper.instance.queryAllFloodReport();
    setState(() {
      _reports = reports;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUserTable(),
          ],
        ),
      ),
    );
  }

  // Create a Table widget to display users' details
  Widget _buildUserTable() {
    if (_users.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Username')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Password')),
          ],
          rows: _reports.map((report) {
            return DataRow(cells: [
              DataCell(Text(report['id'].toString())),
              DataCell(Image.memory(base64Decode(report['photo']))),
              DataCell(Text(report['description'])),
              DataCell(Text(report['location'])),
            ]);
          }).toList(),
        ),
      );
    }
  }
}
