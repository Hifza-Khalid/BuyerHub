// ...existing imports...

import 'package:emart_app/views/auth_screen/signup_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../consts/consts.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
                15.heightBox,
                Column(
                  children: [
                    customTextField(
                      title: "Email",
                      hint: "email",
                      isPass: false,
                      controller: emailController,
                    ),
                    customTextField(
                      title: "Password",
                      hint: "password",
                      isPass: true,
                      controller: passwordController,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: "Forgot Password?".text.make(),
                      ),
                    ),
                    5.heightBox,
                    // Login Button
                    GetBuilder<AuthController>(
                      builder: (controller) => SizedBox(
                        width: context.screenWidth - 50,
                        child: ourButton(
                          color: redColor,
                          title: controller.isloading.value ? "Loading..." : "Log in",
                          textColor: whiteColor,
                          onPress: () async {
                            if (emailController.text.isNotEmpty && 
                                passwordController.text.isNotEmpty) {
                              controller.isloading(true);
                              await controller.loginMethod(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                              ).then((value) {
                                if (value != null) {
                                  VxToast.show(context, msg: "Logged in successfully");
                                  Get.offAll(() => const Home());
                                }
                                controller.isloading(false);
                              });
                            } else {
                              VxToast.show(context, msg: "Please fill all fields");
                            }
                          },
                        ),
                      ),
                    ),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    // Signup Button
                    SizedBox(
                      width: context.screenWidth - 50,
                      child: ourButton(
                        color: lightGolden,
                        title: "Sign up",
                        textColor: redColor,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        },
                      ),
                    ),
                    10.heightBox,
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
