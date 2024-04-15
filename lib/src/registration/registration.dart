import 'package:email_validator/email_validator.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  static const routeName = '/registration';

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final FancyPasswordController _passwordController = FancyPasswordController();

  @override
  Widget build(BuildContext context) {
    //Examples for fancy password:
    // https://github.com/rodrigobastosv/fancy_password_field/tree/main

    return Scaffold(
      appBar: AppBar(title: Text('first lvl pets')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText:
                      'Name', // Click inside text field and label is placed on border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                _formKey.currentState!.validate();
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText:
                      'Email', // Click inside text field and label is placed on border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
              onChanged: (value) {
                _formKey.currentState!.validate();
              },
            ),
            const SizedBox(height: 20),
            FancyPasswordField(
              // onSaved: (newValue) {
              //   print('on saved: ' + newValue!);
              // },
              onChanged: (value) {
                print('on changed: ' + value);
              },
              passwordController: _passwordController,
              decoration: const InputDecoration(
                  labelText:
                      'Password', // Click inside text field and label is placed on border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              validationRules: {
                DigitValidationRule(),
                UppercaseValidationRule(),
                LowercaseValidationRule(),
                SpecialCharacterValidationRule(),
                MinCharactersValidationRule(6),
                MaxCharactersValidationRule(12),
              },
            ),
            const SizedBox(height: 20),
            FancyPasswordField(
              decoration: const InputDecoration(
                  labelText:
                      'Repeat Password', // Click inside text field and label is placed on border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _onSubmit(), child: Text('Submit'))
          ]),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please enter valid text')),
      // );
    }
    if (!_passwordController.areAllRulesValidated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter a password that matches all requirements.')),
      );
    }

    // Anonymous Login: https://github.com/supabase/supabase-flutter/issues/874
    //final response = await _supabase.auth.signInAnonymously();

    // final response = await _supabase.auth.signUp(
    //     email: 'fantasy@abc.de', password: _passwordController.toString());
    await _supabase.auth.signOut();
    final r1 = await _supabase.auth.signInWithPassword(
        email: 'fantasy@abc.de', password: _passwordController.toString());
  }
}
