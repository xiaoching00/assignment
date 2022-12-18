import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController staffID = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hideText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xff3a3e40),
      body: Center(
        child: Container(
          height: 500,
          margin: const EdgeInsets.only(left:20,right:20),
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    //const Padding(padding: EdgeInsets.all(50)),
                    // Image.asset(
                    //   "assets/login.png",
                    //   height: 200,
                    //   scale: 0.5,
                    // ),
                    TextFormField(
                      controller: staffID,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.black87),
                          labelText: "ID",
                          hintText: "Type your id"
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    TextFormField(
                      obscureText: hideText,
                      controller: password,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.black87,),
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  hideText = !hideText;
                                });
                              },
                              icon: Icon(hideText ? Icons.visibility_off : Icons.visibility)
                          ),
                          labelText: "Password",
                          hintText: "Type your password"
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Container(
                      width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black87,
                      ),
                      child: TextButton(
                        onPressed: (){},
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
