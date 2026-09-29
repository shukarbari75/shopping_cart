import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:shopping_cart/cart_model.dart';
import 'package:path/path.dart';

class DBHelper {

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate,);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute(
        'CREATE TABLE cart( id INTEGER PRIMARY KEY,productId VARCHAR UNIQUE,productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT , image TEXT  )');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClint = await db;
    await dbClint!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClint = await db;
    final List<Map<String , Object?>> queryResult = await dbClint!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }
  Future<int> delete(int id)async{
    var dbClint = await db;
    return await dbClint!.delete(
        'cart',
       where: 'id = ?',
      whereArgs: [id],
    );
  }

   Future<int> updataQuantity(Cart cart)async {
     var dbClint = await db;
     return await dbClint!.update(
       'cart',
       cart.toMap(),
       where: 'id = ?',
       whereArgs: [cart.id],
     );
   }

}








//  explan full Example

//import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io' as io;
// import 'package:shopping_cart/cart_model.dart';
// import 'package:path/path.dart';
//
// // (ImP Line)Sqflite Flutter app mein data ko mobile ke andar local database mein save karne ke liye use hota hai.
//
// class DBHelper {
//
//   static Database? _db;
//   // (Database?)Ye variable Database bhi ho sakta hai aur null bhi ho sakta hai.
//
//   Future<Database?> get db async{
//    //  Ye getter hai.
//
//    if(_db != null){
//      // Kya database pehle se bana hua hai? (✅ Haan)(_db = DatabaseObject;)
//      // Agr nhi bana tu (❌ Nahi) (_db = null;)
//      return _db!;
//    //   Agar database pehle se bana hua hai.
//      // To dobara mat banao.
//      // Jo bana hua hai wohi de do.
//    }
//   _db = await initDatabase();
//   //  (initDatabase())Ye function database banayega.
//     return _db;
//   }
//
//   initDatabase() async {
//     // Ab database banane ka kaam shuru.
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     // Ye phone ke andar app ka folder nikalta hai.
//     String path = join(documentDirectory.path , 'cart.db');
//     // Ye database ka naam aur address bana raha hai.
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate,);
//     //  Ye line kehti hai: pehle se hai. to usko open karo.Agar nahi hai, to nayi bana do.
//     return db;
//
//   }
//   _onCreate(Database db, int version)async {
//     // Ab database ban gaya. Ab is ke andar table banani hai.
//     await db
//         .execute('CREATE TABLE cart( id INTEGER PRIMARY KEY,productId VARCHAR UNIQUE,productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT , image TEXT  )');
//   }
//   Future<Cart> insert(Cart cart)async{
//   //   Is ka matlab hai. "Mujhe ek Cart do, main usay database mein save kar dunga."
//   var dbClint = await db ;
//   // "Pehle database kholo: Jaise ghar mein almari kholte ho pehle, phir kapde rakhte ho.
//
//   await dbClint!.insert('cart', cart.toMap());
//   //await dbClient.insert: Ye kehti hai: "Database mein data save karo."
//
//   // cart.toMap():Database sirf is format ko samajhta hai
//
//   // Cart = poora object (insaan ki tarah)
//   // toMap() = us object ki information (form ki tarah)
//   // Database = us information ko save karta hai.
//   return cart;
//   // "Jo cart function ko mila tha, usi ko wapas bhej do."
//   }
