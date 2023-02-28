import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import '../../../../services/auth_service.dart';
import '../register/register.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final errorController = Get.put(ErrorController());
  final loadingController = Get.put(LoadingController());

  Future accountLogin() async {
    if (emailController.text == "" || passwordController.text == "") {
      errorController.setErrorMessage('Please fill all fields.');
    } else {
      errorController.setErrorMessage('');
      try {
        loadingController.setLoading(true);
        await AuthService().userLogin(
          email: emailController.text,
          password: passwordController.text,
        );
        loadingController.setLoading(false);
      } on FirebaseAuthException catch (e) {
        loadingController.setLoading(false);
        if (e.message
            .toString()
            .contains("There is no user record corresponding")) {
          errorController.setErrorMessage("There is no user with this email.");
        } else if (e.message.toString().contains("The password is invalid")) {
          errorController.setErrorMessage("This password is invalid");
        } else {
          errorController.setErrorMessage(e.message.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: WillPopScope(
        onWillPop: () async {
          errorController.setErrorMessage("");
          return true;
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addVerticalSpace(10),
                  customTextField(
                    controller: emailController,
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  addVerticalSpace(10),
                  passwordTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    textInputType: TextInputType.text,
                  ),
                  addVerticalSpace(10),
                  GetX<ErrorController>(
                    builder: (controller) => errorText(controller),
                  ),
                  GetX<LoadingController>(builder: (controller) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.loading.value == false) {
                            await accountLogin();
                          }
                        },
                        child: (controller.loading.value == false)
                            ? Text(
                                "Login",
                                style: TextStyle(fontSize: large),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    );
                  }),
                  addVerticalSpace(10),
                  TextButton(
                    onPressed: () {
                      errorController.setErrorMessage("");
                      Get.to(const Register());
                    },
                    child: Text(
                      "Do not have an account?",
                      style: TextStyle(
                        fontSize: small,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
