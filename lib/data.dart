import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart';

class DataTes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Data Handling'),
        ),
        body: FutureBuilder<List<User>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<User> users = snapshot.data ?? [];
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].username),
                    subtitle: Text(users[index].email),
                    onTap: () {
                      // Check username and password
                      if (users[index].username == 'developer1' && users[index].password== '123') {
                        // Show success Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login success!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // Show failure Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
