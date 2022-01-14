import 'package:authenticator/application.dart';
import 'package:authenticator/src/widgets/form_fields.dart';
import 'package:flutter/material.dart';

class NewMFAAppManually extends StatefulWidget {
  const NewMFAAppManually({Key? key}) : super(key: key);

  @override
  State<NewMFAAppManually> createState() => _NewMFAAppManuallyState();
}

class _NewMFAAppManuallyState extends State<NewMFAAppManually> {
  final _formKey = GlobalKey<FormState>();

  final userId = TextEditingController();
  final secret = TextEditingController();
  final issuer = TextEditingController();
  final counter = TextEditingController();
  String? type, algorithm, period, digits;

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    var data = MFA_Apps(
      type: type ?? MFA_Apps.dType,
      user: userId.text,
      secret: secret.text,
      issuer: issuer.text,
      algorithm: algorithm ?? MFA_Apps.dAlgorithm,
      digits: digits ?? MFA_Apps.dDigits,
      counter: type == null || counter.text == '' ? MFA_Apps.dCounter : counter.text,
      period: period ?? MFA_Apps.dPeriod,
    );

    var copy = await sqlDatabase.getOne(data);
    if (copy.isEmpty) {
      sqlDatabase.add(data);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Application already added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Application'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextFormField(
                  controller: userId,
                  hintText: 'UserId',
                  validator: requiredFormField,
                ),
                MyDropDownFormField<String>(
                  value: type,
                  hintText: 'Type',
                  onChanged: (v) => type = v,
                  items: const ['TOTP (Default)', 'HOTP'],
                  itemValues: const ['totp', 'hotp'],
                  validator: noValidator,
                ),
                MyTextFormField(
                  controller: issuer,
                  hintText: 'Issuer',
                  validator: requiredFormField,
                ),
                MyTextFormField(
                  controller: secret,
                  hintText: 'Secret',
                  validator: requiredFormField,
                ),
                MyDropDownFormField<String>(
                  value: algorithm,
                  hintText: 'Algorithm',
                  onChanged: (v) => algorithm = v,
                  items: const ['SHA1 (Default)', 'SHA256', 'SHA512'],
                  itemValues: const ['sha1', 'sha256', 'sha512'],
                  validator: noValidator,
                ),
                MyDropDownFormField<String>(
                  value: digits,
                  hintText: 'Digits',
                  onChanged: (v) => digits = v,
                  items: const ['6 (Default)', '4', '8'],
                  itemValues: const ['6', '4', '8'],
                  validator: noValidator,
                ),
                MyDropDownFormField<String>(
                  value: period,
                  hintText: 'Period',
                  onChanged: (v) => period = v,
                  items: const ['30 seconds (Default)', '60 seconds'],
                  itemValues: const ['30', '60'],
                  validator: noValidator,
                ),
                MyTextFormField(
                  controller: counter,
                  hintText: 'Counter (In Case of HOTP)',
                  validator: (value) {
                    if (type == 'hotp' && (counter.text == '' || counter.text.compareTo('0') <= 0)) {
                      return 'Invalid Counter Value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  child: const Text('\t\t\tSave\t\t\t'),
                  onPressed: save,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
