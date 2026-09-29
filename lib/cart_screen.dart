import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/bd_helper.dart';
import 'package:shopping_cart/cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}
class _CartScreenState extends State<CartScreen> {

  DBHelper db = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text('Product List',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          Center(
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
          SizedBox(width: 20.0,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context , AsyncSnapshot<List<Cart>>Snapshot){
                  if(Snapshot.hasData){

                    if(Snapshot.data!.isEmpty){
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image(image: AssetImage('image/empty_cart.jpg')),
                         SizedBox(height: 20,),
                         Text('Explore Product',style: Theme.of(context).textTheme.headlineMedium,),
                       ]
                     );
                    }else{
                      return Expanded(
                        child: ListView.builder(
                            itemCount: Snapshot.data!.length,
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
                                            image: NetworkImage(Snapshot.data![index].image.toString()),
                                          ),
                                          SizedBox(width: 17,),
                                          Expanded(
                                            child: Column(

                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 12),
                                                      child: Text(Snapshot.data![index].productName.toString(),
                                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          cart.db.delete(Snapshot.data![index].id!);
                                                          cart.removerCounter();
                                                          cart.removerTotalPrice(double.parse(Snapshot.data![index].productPrice.toString()));
                                                        },
                                                        child: Icon(Icons.delete)),
                                                  ],
                                                ),

                                                SizedBox(height: 5,),
                                                Text(Snapshot.data![index].unitTag.toString() +" "+r"$"+Snapshot.data![index].productPrice.toString(),
                                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                                SizedBox(height: 5,),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: (){
                                                    },
                                                    child: Container(
                                                        height: 35,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: (){
                                                                  int quantity = Snapshot.data![index].quantity!;
                                                                  int price = Snapshot.data![index].productPrice!;
                                                                  quantity--;
                                                                  int? newPrice = price * quantity;

                                                                  if(quantity > 0){

                                                                    cart.db.updataQuantity(
                                                                      Cart(
                                                                          id: Snapshot.data![index].id!,
                                                                          productId: Snapshot.data![index].id!.toString(),
                                                                          productName: Snapshot.data![index].productName!,
                                                                          initialPrice: Snapshot.data![index].initialPrice!,
                                                                          productPrice: newPrice,
                                                                          quantity: quantity,
                                                                          unitTag: Snapshot.data![index].unitTag.toString(),
                                                                          image: Snapshot.data![index].image.toString()),
                                                                    ).then((value){
                                                                      newPrice = 0;
                                                                      quantity = 0;
                                                                      cart.removerTotalPrice(double.parse(Snapshot.data![index].initialPrice!.toString()));
                                                                    }).onError((error , strackTrace){
                                                                      print(error.toString());
                                                                    });
                                                                  }
                                                                },
                                                                child: Icon(Icons.remove,color: Colors.white,)),
                                                            Text(Snapshot.data![index].quantity.toString(),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                            InkWell(
                                                                onTap: (){
                                                                  int quantity = Snapshot.data![index].quantity!;
                                                                  int price = Snapshot.data![index].productPrice!;
                                                                  quantity++;
                                                                  int? newPrice = price * quantity;

                                                                  cart.db.updataQuantity(
                                                                    Cart(
                                                                        id: Snapshot.data![index].id!,
                                                                        productId: Snapshot.data![index].id!.toString(),
                                                                        productName: Snapshot.data![index].productName!,
                                                                        initialPrice: Snapshot.data![index].initialPrice!,
                                                                        productPrice: newPrice,
                                                                        quantity: quantity,
                                                                        unitTag: Snapshot.data![index].unitTag.toString(),
                                                                        image: Snapshot.data![index].image.toString()),
                                                                  ).then((value){
                                                                    newPrice = 0;
                                                                    quantity = 0;
                                                                    cart.addTotalPrice(double.parse(Snapshot.data![index].initialPrice!.toString()));
                                                                  }).onError((error , strackTrace){
                                                                    print(error.toString());
                                                                  });

                                                                },
                                                                child: Icon(Icons.add,color: Colors.white)),
                                                          ],
                                                        )
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
                      );
                    }

                  }
                  return Text('No Data Found');
            }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice() > 0,

                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ReusableWidge(title: 'Sub Tolal',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2),),
                      ReusableWidge(title: 'Discount 5%', value: r'$' + '20'),
                      ReusableWidge(title: 'Total',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          ],
        ),
      )
    );
  }
}




class ReusableWidge extends StatelessWidget {
  String title, value;
  ReusableWidge({super.key,required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall,),
          Text(value, style: Theme.of(context).textTheme.titleSmall,)
        ],
      ),
    );
  }
}
