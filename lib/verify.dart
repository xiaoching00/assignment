import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'email.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


void main(){
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blueGrey
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue
            )
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue
            )
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(10)
          )
      ),
      primarySwatch: Colors.blue,
    ),
    home: const verify(),
  )
  );
}

class verify extends StatefulWidget {
  const verify({Key? key}) : super(key: key);

  @override
  State<verify> createState() => _verifyState();
}

class _verifyState extends State<verify> {
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pin = TextEditingController();
  String verifyID = "";
  int countdown = 0;
  Timer? timer;
  bool isVisible = false;
  bool isEnable = false;
  final formKey = GlobalKey<FormState>();

  Future<void> sendOTP() async{
    timer?.cancel();
    if(phone.text == null){
      isEnable = isEnable;
    }else if(formKey.currentState!.validate()){
      isEnable = true;
      setState(() {
        isVisible = true;
        countdown = 60;
      });
      //Ex. give studentID our college will know who you are
      //give verificationId then the firebase will know is the pin you send correct or not
      await FirebaseAuth.instance.verifyPhoneNumber(
        //0123456789
        phoneNumber: "+6${phone.text}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            verifyID = verificationId;
          });
        },
      );


      //import at top of the file if don't have import 'dart:async';
      //interval
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  Future<void> setTimer() async{
    //primary condition run only when
    timer?.cancel();
    setState(() {
      countdown = 10;
    });

    //import at top of the file if don't have import 'dart:async';
    //interval
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(countdown > 0){
        setState(() {
          countdown--;
        });
      }else{
        timer.cancel();
      }
    });
  }

  Future<void> verifyOTP() async{
    try{
      //int parse("1")
      //Data type                      //                 //username & password     //temporary username, temporary password
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verifyID, smsCode: pin.text);
      UserCredential resp = await FirebaseAuth.instance.signInWithCredential(credential);
      if(formKey.currentState!.validate()){

        DatabaseReference ref = FirebaseDatabase.instance.ref("US1");
        ref.push().set(
          //json format
            {
              'phone' : phone.text,
            }
        ).then((value){
          print("Insert Successfully");
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => const email();
          )
          );
        }).catchError((error){
          print(error);
        });
      }
      //throw "haha";
    }catch(e){
      //e = haha
      // showDialog(
      //     context: context,
      //     builder: (ctx)=>const AlertDialog(
      //       title: Text("Error"),
      //       content: Text("Invalid Pin Code"),
      //     )
      // );
      EasyLoading.showError("Invalid Pin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS OTP"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Form(
            key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: phone,
                    readOnly: isEnable,
                    keyboardType: TextInputType.number,
                    validator: (val){
                      if(val == null || val == ""){
                        return  "Please fill in.";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: "Phone number",
                        hintText: "Enter your phone number"
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: countdown == 0 ? sendOTP: null,
                        child: Text(countdown == 0 ? "Get Pin":"Resend your otp after $countdown s"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),

                  Visibility(
                    visible: isVisible,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15,right: 15),
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.yellow[200]
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: pin,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            icon: Icon(
                              Icons.pin,
                              color: Colors.deepOrange,
                            ),
                            labelText: "Pin",
                            hintText: "Enter your pin",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                        ),
                        validator: (val1){
                          if( val1 == null || val1 == ""){
                            return "Please fill in your pin";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Visibility(
                    visible: isVisible,
                    child: TextButton(
                      onPressed: verifyOTP,
                      child: const Text("Next"),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(

                  ),
                ],
              ),
          ),

        ],
      ),
    );
  }
}
