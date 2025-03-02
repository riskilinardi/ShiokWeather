import 'package:flutter/material.dart';
import 'db.dart';

class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load all users from the database
  _loadUsers() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Table'),
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
          rows: _users.map((user) {
            return DataRow(cells: [
              DataCell(Text(user['id'].toString())),
              DataCell(Text(user['username'])),
              DataCell(Text(user['email'])),
              DataCell(Text(user['password'])),
            ]);
          }).toList(),
        ),
      );
    }
  }
}
