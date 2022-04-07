import 'package:flutter/material.dart';
import 'package:querybuildertask/formgenerator.dart';
import 'package:querybuildertask/models/user_model.dart';
import 'package:querybuildertask/services/database/user_table.dart';
import 'package:querybuildertask/view/pages/form_screen.dart';

class UserProfileListing extends StatefulWidget {
  const UserProfileListing({Key? key}) : super(key: key);

  @override
  _UserProfileListingState createState() => _UserProfileListingState();
}

class _UserProfileListingState extends State<UserProfileListing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Profiles'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * .80,
            child: FutureBuilder(
              future: UserTable('users').fetchAllUser(),
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(children: const [
                    Center(child: CircularProgressIndicator()),
                    Spacer(),
                  ]);
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text(
                        'Something went Wrong to fetching the data!');
                  } else if (snapshot.hasData) {
                    List<User> users = snapshot.data!;
                    return (users.isNotEmpty)
                        ? Center(
                            child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 80,
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 5),
                                    elevation: 3,
                                    child: ListTile(
                                      title: Text('${users[index].name}'),
                                      leading: Text('${users[index].id}'),
                                      subtitle: Text('${users[index].cnic}'),
                                      trailing: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Colors.blue.shade50,
                                        radius: 30,
                                        child: SizedBox(
                                          height: 80,
                                          width: 60,
                                          child: Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade300),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          FormGenerator().initData(
                                              users[index].id, context);
                                          // Navigator.push<void>(
                                          //   context,
                                          //   MaterialPageRoute<void>(
                                          //     builder: (BuildContext context) =>
                                          //          FormGenerator().initData(userid, context);
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text('no data found!'),
                          );
                  } else {
                    return const Center(child: Text('No Data found!'));
                  }
                } else {
                  return Center(
                      child: Text('State: ${snapshot.connectionState}'));
                }
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const FormScreen(),
                    ),
                  );
                },
                child: const Text('Add User')),
          )
        ],
      ),
    );
  }
}
