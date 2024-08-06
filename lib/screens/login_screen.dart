import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/signup_screen.dart';

import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/uitil.dart';
import 'package:instagram_clone/widgets/kbutton.dart';
import 'package:instagram_clone/widgets/ktext_field.dart';

import '../responsive/mobile_responsive.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods()
        .signIn(email: _emailController.text, password: _passController.text);

    if (res == "success") {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const ResponsiveLayout(
              mobileScreenLayout: MobileResponsive(),
              webScreenLayout: WebResponsive());
        },
      ));
    } else {
      showSnackbar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SignUpScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //logo
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,
                color: primaryColor,
              ),
              const SizedBox(
                height: 30,
              ),

              //textField
              KtextField(
                  hintText: "Enter Email",
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress),

              SizedBox(
                height: 15,
              ),
              //textField
              KtextField(
                hintText: "Enter Password",
                textEditingController: _passController,
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),

              SizedBox(
                height: 15,
              ),
              //button
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : Kbutton(onTap: signIn, text: "Sign in"),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text("Don't have an account? "),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
