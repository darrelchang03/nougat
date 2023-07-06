import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'dart:async';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var username = "";
  final _formKey = GlobalKey<FormState>();

  submit() {
    final form = _formKey.currentState;
    if(form!.validate()) {
      form?.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $username!"),));
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context,username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key:_scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25),
                child: Center(
                  child: Text("Create a username",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: (val) {
                        if(val!.trim().length < 3 || val.isEmpty) {
                          return "Username too short";
                        } else if (val.trim().length > 12) {
                          return "Username too long";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (val) => username = val.toString(),
                      decoration: const InputDecoration(
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(color: Colors.black54),
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                          ),
                      ),
                    ),
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                       "Submit",
                      style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),
                ),
              )
            ],)
          )
        ],
      ),
    );
  }
}