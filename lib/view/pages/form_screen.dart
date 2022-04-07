import 'package:flutter/material.dart';
import 'package:querybuildertask/models/user_model.dart';
import 'package:querybuildertask/services/database/user_table.dart';
import 'package:querybuildertask/view/pages/user_list.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  UserTable userTable = UserTable('users');
  FormGroup buildForm() => fb.group(<String, Object>{
        'name': FormControl<String>(
          validators: [Validators.required],
        ),
        'city': ['', Validators.required, Validators.minLength(3)],
        'address': ['', Validators.required],
        'country': ['', Validators.required],
        'age': ['', Validators.required],
        'cnic': ['', Validators.required],
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("SQFLITE"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  children: [
                    ReactiveTextField<String>(
                      formControlName: 'name',
                      decoration: const InputDecoration(
                        labelText: 'name',
                      ),
                      validationMessages: (errors) => {
                        ValidationMessage.required:
                            'first name must  not be empty',
                        ValidationMessage.minLength:
                            'name must  be greater 2 characters',
                      },
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'address',
                      decoration: const InputDecoration(
                        labelText: 'address',
                      ),
                      validationMessages: (errors) => {
                        ValidationMessage.required: 'address must not be empty',
                        ValidationMessage.minLength: 'enter valid address name',
                      },
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'city',
                      decoration: const InputDecoration(
                        labelText: 'city',
                      ),
                      validationMessages: (errors) => {
                        ValidationMessage.required: 'city must not be empty',
                        ValidationMessage.minLength: 'enter valid city name',
                      },
                    ),
                    ReactiveDropdownField<String>(
                      formControlName: 'country',
                      decoration: const InputDecoration(
                        labelText: 'select country',
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'pakistan', child: Text('Pakistan')),
                        DropdownMenuItem(value: 'india', child: Text('India')),
                        DropdownMenuItem(
                            value: 'banglades', child: Text('Bangladesh')),
                        DropdownMenuItem(
                            value: 'srilanka', child: Text('Sri Lanka')),
                      ],
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'age',
                      decoration: const InputDecoration(
                        labelText: 'age',
                      ),
                      validationMessages: (errors) => {
                        ValidationMessage.required: 'age must not be empty',
                        ValidationMessage.minLength: 'enter valid age ',
                      },
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'cnic',
                      decoration: const InputDecoration(
                        labelText: 'cnic',
                      ),
                      validationMessages: (errors) => {
                        ValidationMessage.required: 'cnic must not be empty',
                        ValidationMessage.minLength: 'enter valid cnic name',
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ReactiveFormConsumer(
                      builder: (context, form, child) => ElevatedButton(
                        onPressed: form.valid
                            ? () {
                                Map<String, dynamic> formData = {};
                                int createdDate =
                                    (DateTime.now().millisecondsSinceEpoch);
                                int updatedDate =
                                    (DateTime.now().millisecondsSinceEpoch);
                                formData.addAll(form.value);
                                formData['createdDate'] = createdDate;
                                formData['updatedDate'] = updatedDate;
                                formData['id'] = 1;
                                userTable.addUser(User.fromJson(formData));

                                // showAlertDialog(context);
                                form.reset();
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const UserProfileListing(),
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Submit'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => form.resetState({
                        'email': ControlState<String>(
                            value: 'johnDoe', disabled: true),
                        'progress': ControlState<double>(value: 50.0),
                        'rememberMe': ControlState<bool>(value: false),
                      }, removeFocus: true),
                      child: const Text('Reset all'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            UserTable('users').batchInsert(context, 10000);
                          },
                          child: const Text('10K Users'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            UserTable('users').batchInsert(context, 100000);
                          },
                          child: const Text('100K Users'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            UserTable('users').batchInsert(context, 500000);
                          },
                          child: const Text('500K Users'),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     UserTable('users').batchInsert(context, 1000000);
                        //   },
                        //   child: const Text('1M Users'),
                        // ),
                      ],
                    ),
                  ],
                );
              }),
        )),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("User"),
      content: const Text("New User Added Successfully!"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
