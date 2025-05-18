import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/profile_screen/components/details_card.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screen/login_screen.dart';
import 'package:emart_app/views/profile_screen/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    final profileButtonList = [
      "Edit Profile",
      "Change Password",
      "Order History",
      "Logout",
    ];

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Edit Icon
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: const Icon(
                            Icons.edit,
                            color: whiteColor,
                          ).onTap(() {
                            controller.nameController.text = data['name'];
                            Get.to(() => EditProfileScreen(data: data));
                          }),
                        ),
                      ),

                      // Profile section
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            data['imageUrl'] == null || data['imageUrl'] == ''
                                ? Image.asset(
                              imgProfile2,
                              width: 50,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(
                              data['imageUrl'],
                              width: 50,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),

                            10.widthBox,

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  "${data['name']}"
                                      .text
                                      .fontFamily(bold)
                                      .color(darkFontGrey)
                                      .make(),
                                  3.heightBox,
                                  "${data['email']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 32,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: whiteColor),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async {
                                  await Get.put(AuthController())
                                      .signoutMethod(context);
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontFamily: semibold,
                                    color: whiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      20.heightBox,

                      // Details Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: detailsCard(
                                count: data['cart_count'].toString(),
                                titleText: "In Cart",
                                width: context.screenWidth / 3.5,
                              ),
                            ),
                            10.widthBox,
                            Expanded(
                              child: detailsCard(
                                count: data['wishlist_count'].toString(),
                                titleText: "Wishlist",
                                width: context.screenWidth / 3.5,
                              ),
                            ),
                            10.widthBox,
                            Expanded(
                              child: detailsCard(
                                count: data['order_count'].toString(),
                                titleText: "Orders",
                                width: context.screenWidth / 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      20.heightBox,

                      // List section
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Divider(color: lightGrey);
                            },
                            itemCount: profileButtonList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Image.asset(
                                  'assets/images/b5.jpeg',
                                  width: 22,
                                ),
                                title: profileButtonList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                onTap: () {
                                  if (index == 3) { // Logout
                                    Get.put(AuthController())
                                        .signoutMethod(context);
                                    Get.offAll(() => const LoginScreen());
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
