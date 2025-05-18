import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';

class SellerOrders extends StatelessWidget {
  const SellerOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Orders".text.color(darkFontGrey).fontFamily(bold).make(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('seller_id', isEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: "${index + 1}".text.color(darkFontGrey).xl.make(),
                  title: data[index]['order_code'].toString().text.make(),
                  subtitle: data[index]['total_amount'].toString().text.make(),
                  trailing: IconButton(
                    onPressed: () {
                      // Order details functionality
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

