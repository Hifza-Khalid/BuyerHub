import 'package:get/get.dart';
import '../../consts/consts.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Move controllers to class level variables
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController retypePasswordController;
  bool isChecked = false; // Added for checkbox state
  var controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    retypePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  // Add email validation function
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      title: name,
                      hint: nameHint,
                      controller: nameController,
                      isPass: false,
                    ),
                    customTextField(
                      title: email,
                      hint: emailHint,
                      controller: emailController,
                      isPass: false,
                    ),
                    customTextField(
                      title: password,
                      hint: passwordHint,
                      controller: passwordController,
                      isPass: true,
                    ),
                    customTextField(
                      title: retypepassword,
                      hint: passwordHint,
                      controller: retypePasswordController,
                      isPass: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetpassword.text.make(),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            checkColor: redColor,
                            value: isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                isChecked = newValue ?? false;
                              });
                            }),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "I agree to the",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )),
                              TextSpan(
                                  text: termsAndConditions,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )),
                              TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )),
                              TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )),
                            ],
                          )),
                        )
                      ],
                    ),
                    5.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: isChecked == true ? redColor : lightGrey,
                            title: signup,
                            textColor: whiteColor,
                            onPress: () async {
                              if (!isChecked) {
                                VxToast.show(context,
                                    msg: "Please agree to terms & conditions");
                                return;
                              }

                              // Validate email format
                              if (!isValidEmail(emailController.text.trim())) {
                                VxToast.show(context,
                                    msg: "Please enter a valid email address");
                                return;
                              }

                              // Validate password
                              if (passwordController.text.trim().length < 6) {
                                VxToast.show(context,
                                    msg: "Password must be at least 6 characters");
                                return;
                              }

                              // Validate password match
                              if (passwordController.text.trim() !=
                                  retypePasswordController.text.trim()) {
                                VxToast.show(context,
                                    msg: "Passwords don't match");
                                return;
                              }

                              // Validate name
                              if (nameController.text.trim().isEmpty) {
                                VxToast.show(context,
                                    msg: "Please enter your name");
                                return;
                              }

                              try {
                                controller.isloading(true);
                                // Create user account
                                await controller.signupMethod(
                                  context: context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ).then((value) async {
                                  if (value != null) {
                                    // Store user data
                                    await controller.userStoreData(
                                      name: nameController.text.trim(),
                                      password: passwordController.text.trim(),
                                      email: emailController.text.trim(),
                                    );
                                    VxToast.show(context,
                                        msg: "Account created successfully");
                                    Get.offAll(() => const Home());
                                  }
                                });
                              } catch (e) {
                                auth.signOut();
                                VxToast.show(context, msg: e.toString());
                              } finally {
                                controller.isloading(false);
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: alreadyHaveAnAccount,
                              style: TextStyle(
                                fontFamily: bold,
                                color: fontGrey,
                              )),
                          TextSpan(
                              text: login,
                              style: TextStyle(
                                fontFamily: bold,
                                color: redColor,
                              )),
                        ],
                      ),
                    ).onTap(() {
                      Get.back();
                    }),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth * 0.7)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

