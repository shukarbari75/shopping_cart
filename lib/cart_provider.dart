import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/bd_helper.dart';
import 'cart_model.dart';


// SharedPreferences app mein chhota data, jaise login status, username ya settings, mobile mein save rakhne ke liye use hota hai.

class CartProvider  with ChangeNotifier{

 DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

   late Future<List<Cart>> _cart;
   Future<List<Cart>> get cart => _cart;

   Future<List<Cart>> getData ()async{
     _cart = db.getCartList();
     return _cart;
   }


  void setPrefItem ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  // prefs ab woh object hai jiske through hum data save/read karenge.

    prefs.setInt('cart_Item', _counter);
    // _counter ki value mobile mein save karo.

    prefs.setDouble('total_Price', _totalPrice);
    // _totalPrice ko mobile mein save karo.

    notifyListeners();
  //   "Data change ho gaya hai, ab jo widgets mujhe listen kar rahe hain unko dobara update/rebuild karo."

  }
  void getPrefItem ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_Item') ?? 0;
    _totalPrice = prefs.getDouble('total_Price') ?? 0.0;
  }

  void addCounter (){
    _counter++;
    setPrefItem();
    notifyListeners();

  }

  void removerCounter (){
    _counter--;
    setPrefItem();
    notifyListeners();

  }

   int  getCounter (){
    getPrefItem();
    return _counter ;

  }

  void addTotalPrice (double productPrice){
    _totalPrice = _totalPrice + productPrice;
    setPrefItem();
    notifyListeners();

  }

  void removerTotalPrice (double productPrice){
    _totalPrice = _totalPrice - productPrice;
    setPrefItem();
    notifyListeners();

  }

  double getTotalPrice (){
    return _totalPrice ;

  }

}