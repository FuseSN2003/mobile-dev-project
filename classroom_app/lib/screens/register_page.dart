import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool visiblePassword = true;
  bool isCheck = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
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
                    _buildTextField(context, 'Username', usernameController),
                    _buildTextField(context, 'Email', emailController),
                    _buildTextField(context, 'Password', passwordController),
                    _buildTextField(
                      context,
                      'Confirm-Password',
                      confirmpasswordController,
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
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black, fontSize: 16),
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
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
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
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Icon(icon, color: Colors.white),
          // backgroundImage: AssetImage("assets/icon/facebook.png"),
        ),
      ),
    );
  }
}
