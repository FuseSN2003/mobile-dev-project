import 'package:flutter/material.dart';
import '../component/navbar.dart';
import '../component/createclassbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isClassed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Assignment",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontFamily: 'KaushanScript',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isClassed = !_isClassed;
                          });
                        },
                        child: Text(
                          "Classed",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                _isClassed
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.white54,
                            fontFamily: "Inder",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isClassed = !_isClassed;
                          });
                        },
                        child: Text(
                          "Created Classed",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                !_isClassed
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.white54,
                            fontFamily: "Inder",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CreateClassbar(),
        ],
      ),
    );
  }
}
