import 'package:flutter/material.dart';
import 'package:querybuildertask/services/database/user_table.dart';
import 'package:querybuildertask/view/formui.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormGenerator {
  Map<String, Object?> formData = {};
  void initData(int? userid, BuildContext context) {
    if (userid != 0) {
      getSingleUserData(userid, context);
    } else {
      FormGroup fg = getForm();
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              FormUi(formGroup: fg, formData: formData),
        ),
      );
    }
  }

  getSingleUserData(int? id, BuildContext context) async {
    final formData = await UserTable('users').fetchSingleUser(id!);

    Map<String, Object?> data = formData.toJson();
    data.remove('createdDate');
    data.remove('updatedDate');
    data.remove('id');
    FormGroup fg = getForm();
    fg.patchValue(data);
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            FormUi(formGroup: fg, formData: formData.toJson()),
      ),
    );
  }

  FormGroup getForm() {
    return fb.group(<String, Object>{
      'name': FormControl<String>(
        validators: [Validators.required],
      ),
      'city': ['', Validators.required, Validators.minLength(3)],
      'address': ['', Validators.required],
      'country': ['', Validators.required],
      'age': ['', Validators.required],
      'cnic': ['', Validators.required],
    });
  }
}
