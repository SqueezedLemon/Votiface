import 'package:flutter/material.dart';
import 'package:votiface/components/show_success.dart';
import 'package:votiface/services/authentication/firebase_auth.dart';
import '../../../components/show_dialog.dart';
import '../components/register_widget.dart';
import '../../../constants.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final idController = TextEditingController();

  final passController = TextEditingController();
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 22),
                // ignore: unnecessary_const
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: kTextPColor),
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(22, 10, 40, 10),
                child: Container(
                  child: TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      // ignore: unnecessary_const
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(22, 10, 40, 10),
                child: Container(
                  child: TextFormField(
                    controller: passController,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text(
              //       'Forget Password?  ',
              //       style: TextStyle(
              //           fontSize: 20,
              //           color: kTextPColor,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async { 
                    setState(() {
                      isLoading = true;
                    });
                    var signInSuccess = await signIn(
                      email: idController.text, password: passController.text);
                     if(signInSuccess !=null ) showErrorDialog('Login Unsuccessful. Please check credentials.', context);
setState(() {
                      isLoading = false;
                    });
                      
                      
                      },
                  style: ElevatedButton.styleFrom(
                    primary: kBtnColor,
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                  ),
                  child: isLoading?CircularProgressIndicator(): Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
  SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 20, color: kTextPColor),
              ),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left:20),
                child:
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()));
                },
                child: const Text(
                  "SignUp",
                  style: TextStyle(
                      color: kColor1,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
