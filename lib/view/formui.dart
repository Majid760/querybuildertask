import 'package:flutter/material.dart';
import 'package:querybuildertask/models/user_model.dart';
import 'package:querybuildertask/services/database/user_table.dart';
import 'package:querybuildertask/view/pages/user_list.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormUi extends StatefulWidget {
  const FormUi({Key? key, this.formGroup, this.formData}) : super(key: key);
  final FormGroup? formGroup;
  final Map<String, Object?>? formData;

  @override
  _FormUiState createState() => _FormUiState();
}

class _FormUiState extends State<FormUi> {
  FormGroup get getForm => widget.formGroup!;
  UserTable userTable = UserTable('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("SQFLITE"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ReactiveFormBuilder(
              form: () => getForm,
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
                    widget.formData!.isEmpty
                        ? ReactiveFormConsumer(
                            builder: (context, form, child) => ElevatedButton(
                              onPressed: form.valid
                                  ? () {
                                      Map<String, dynamic> data = {};
                                      data.addAll(form.value);
                                      data['createdDate'] = (DateTime.now()
                                          .millisecondsSinceEpoch);
                                      data['updatedDate'] = (DateTime.now()
                                          .millisecondsSinceEpoch);
                                      // userTable.addUser(User.fromJson(data));
                                      // showAlertDialog(context);
                                      form.reset();

                                      Navigator.pushReplacement(
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
                          )
                        : ReactiveFormConsumer(
                            builder: (context, form, child) => ElevatedButton(
                                onPressed: () {
                                  Map<String, dynamic> data = {};
                                  data['id'] = widget.formData!['id'];
                                  data.addAll(form.value);
                                  data['updatedDate'] =
                                      (DateTime.now().millisecondsSinceEpoch);
                                  data['createdDate'] =
                                      widget.formData!['createdDate'];
                                  userTable
                                      .updateUserRecord(User.fromJson(data));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const UserProfileListing(),
                                    ),
                                  );
                                },
                                child: const Text('Update'))),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => form.reset(),
                      child: const Text('Reset all'),
                    )
                  ],
                );
              }),
        )),
      ),
    );
  }
}
