import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visiblePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Your Classes',
                  style: GoogleFonts.kaushanScript(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildTextField(context, 'Username'),
                  _buildTextField(context, 'Password'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/Register");
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
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
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {},
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
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/Main");
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Center(
                    child: Text(
                      'Wrong User or Password',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white70)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or sign In with',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white70)),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(FontAwesomeIcons.google),
                      SizedBox(width: 20),
                      _buildSocialButton(FontAwesomeIcons.instagram),
                      SizedBox(width: 20),
                      _buildSocialButton(FontAwesomeIcons.facebook),
                    ],
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Enjoy your ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextSpan(
                            text: 'classes',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ), // Change color for "classes"
                          ),
                          TextSpan(
                            text: ' and make every ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextSpan(
                            text: 'lesson',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ), // Change color for "lesson"
                          ),
                          TextSpan(
                            text: ' count!',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "$label :",
              style: GoogleFonts.inder(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ),
          TextField(
            obscureText: label == "Password" ? visiblePassword : false,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: GoogleFonts.inder(color: Colors.white54, fontSize: 12),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon:
                  label == "Password"
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            visiblePassword = !visiblePassword;
                          });
                        },
                        icon: Icon(
                          visiblePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                      : null,
            ),
            // visiblePassword
            //     ? Icon(Icons.visibility_off, color: Colors.white70)
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white54, width: 1),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          // backgroundImage: AssetImage("assets/icon/facebook.png"),
        ),
      ),
    );
  }
}
