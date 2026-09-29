import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';

import 'bd_helper.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}
class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbHelper = DBHelper();

  List<String> productName = ['Mango', 'Orange', 'Grapes', 'Banana','Chery', 'Grapes', 'Mixed Fruit Basket',];
  List<String> productUnit = ['KG','Dozen', 'KG', 'KG', 'KG', 'KG', 'Basket',];
  List<int> productPrice = [10, 20,30, 40, 50, 60, 70,];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/b/bb/Cherry_Stella444.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/2/2f/Culinary_fruits_front_view.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text('Product List',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge( badgeContent:
               Consumer<CartProvider>(
                 builder: (context, value, child){
                 return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
                 },
               ),
                child: Icon(Icons.shopping_bag_outlined),
                badgeAnimation: const badges.BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 300)),
             ),
            ),
          ),
          SizedBox(width: 20.0,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
                itemBuilder: (context,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(productImage[index].toString()),
                            ),
                              SizedBox(width: 17,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Text(productName[index].toString(),
                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                      Text(productUnit[index].toString() +" "+r"$"+productPrice[index].toString(),
                                       style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                     SizedBox(height: 5,),
                                     Align(
                                       alignment: Alignment.centerRight,
                                       child: InkWell(
                                         onTap: (){
                                         dbHelper!.insert(
                                           Cart(id: index,
                                               productId: index.toString(),
                                               productName: productName[index].toString(),
                                               initialPrice: productPrice[index],
                                               productPrice: productPrice[index],
                                               quantity: 1,
                                               unitTag: productUnit[index].toString(),
                                               image: productImage[index].toString())
                                             ).then((value){
                                               print('product is added to cart');
                                              cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cart.addCounter();
                                         }).onError((error,stackTrace){
                                           print(error.toString());
                                         });
                                         },
                                         child: Container(
                                           height: 35,
                                           width: 100,
                                           decoration: BoxDecoration(
                                             color: Colors.green,
                                           ),
                                           child: Center(child: Text('Add to Cart',style: TextStyle(color: Colors.white,
                                           fontWeight: FontWeight.bold),)),
                                         ),
                                       ),
                                     )
                                  ],
                                ),
                              )


                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}


