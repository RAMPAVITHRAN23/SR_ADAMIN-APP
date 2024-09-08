import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medx_admin/Authentication/signup.dart';
import 'package:medx_admin/Service/authService.dart';

class SignIn extends StatefulWidget {


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var divHeight,divWidth;
  String? email,password;
  bool _obscureText=false;

  @override
  Widget build(BuildContext context) {
    divHeight=MediaQuery.of(context).size.height;
    divWidth=MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Login',style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,

        ),
        body:

        SingleChildScrollView(child:Padding(
            padding: EdgeInsets.all(15),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Image.asset("assets/signin.png",height: divHeight*0.40,),
                  SizedBox(height: divHeight*0.02,),
                  TextField(
                    onChanged: (val){
                      email=val;
                    },
                    decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),
                  SizedBox(height: divHeight*0.02,),
                  TextField(
                    onChanged: (val){
                      password=val;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: _obscureText ? IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                              _obscureText=!_obscureText;
                            });

                          },
                        ) : IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: (){
                            setState(() {
                              _obscureText=!_obscureText;
                            });

                          },
                        ),

                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),
                  SizedBox(height: divHeight*0.04,),
                  InkWell(
                    onTap: ()async {
                      EasyLoading.show(status: "Loading");
                      await AuthService().Login(email: email.toString(), password: password.toString());


                    },
                    child:Container(
                      height: divHeight*0.08,

                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(25),

                      ),
                      child: Center(
                        child: Text("Login",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                      ),
                    ),),
                  SizedBox(height: divHeight*0.02,),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[ Text("Don't have an account?",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0),),
                        TextButton(
                          onPressed: (){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                          },
                          child:Text('Sign Up',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,

                            ),
                          ),
                        ),
                      ]),
                ]
            )
        )
        )

    );
  }
}