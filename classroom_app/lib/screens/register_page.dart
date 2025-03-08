import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/component/login_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/textinput.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isCheck = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _confirmPasswordVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          Navigator.pop(context); // Back button functionality
                        },
                      ),
                      SizedBox(width: 40),
                      Center(
                        child: Text(
                          'Your Classes',
                          style: TextStyle(
                            fontSize: 40, // Adjust the font size as needed
                            fontWeight: FontWeight.bold,
                            fontFamily: 'KaushanScript',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Username',
                        controller: _usernameController,
                      ),
                      CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                      ),
                      CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        visibilityNotifier: _passwordVisible,
                      ),
                      CustomTextField(
                        label: 'Confirm-Password',
                        controller: _confirmpasswordController,
                        visibilityNotifier: _confirmPasswordVisible,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isCheck,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isCheck = newValue!;
                              });
                            },
                            side: BorderSide(
                              color: Colors.white, // White border
                              width: 2, // Border width
                            ),
                          ),
                          Text(
                            "Agree with the Terms & Conditions",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isCheck) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please agree with the Terms & Conditions",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              Register(
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                confirmPassword:
                                    _confirmpasswordController.text.trim(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      CustomRichText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
