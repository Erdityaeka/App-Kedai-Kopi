// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:badges/badges.dart' as badge;
// import 'package:kedakopi/models/menu_model.dart';
// import 'package:http/http.dart' as myHttp;
// import 'package:kedakopi/providers/cart_provider.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController namaController = TextEditingController();
//   TextEditingController nomejaController = TextEditingController();

//   final String urlMenu =
//       "https://script.google.com/macros/s/AKfycbzoiWgUm3jyQC8o63w246_9X1tYi6a6SBN7HFHURkcFC0wmpVYlN8UhxYbsRUgBdyvMkQ/exec";

//   Future<List<MenuModel>> getAllData() async {
//     List<MenuModel> listMenu = [];
//     var response = await myHttp.get(Uri.parse(urlMenu));
//     List data = json.decode(response.body);

//     data.forEach((element) {
//       listMenu.add(MenuModel.fromJson(element));
//     });

//     return listMenu;
//   }

//   void openDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             height: 500,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Text("NAMA"),
//                   TextFormField(
//                     controller: namaController,
//                     decoration: InputDecoration(border: OutlineInputBorder()),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text("No Meja"),
//                   TextFormField(
//                     controller: nomejaController,
//                     decoration: InputDecoration(border: OutlineInputBorder()),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   Consumer<CartProvider>(
//                     builder: (context, value, _) {
//                       String strPesanan = "";
//                       value.cart.forEach((element) {
//                         strPesanan = strPesanan +
//                             "\n" +
//                             element.name +
//                             "(" +
//                             element.quantity.toString() +
//                             ")";
//                       });
//                       return ElevatedButton(
//                         onPressed: () async {
//                           String pesanan = "Nama: " +
//                               namaController.text +
//                               ", Nomor Meja: " +
//                               nomejaController.text +
//                               ", Pesanan: " +
//                               "\n" +
//                               strPesanan;
//                           print(pesanan);
//                         },
//                         child: Text("Pesan Sekarang"),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           openDialog(context);
//         },
//         child: badge.Badge(
//           badgeContent: Consumer<CartProvider>(
//             builder: (context, value, _) {
//               return Text(
//                 (value.total > 0) ? value.total.toString() : "",
//                 style: GoogleFonts.montserrat(color: Colors.white),
//               );
//             },
//           ),
//           child: Icon(Icons.shopping_bag),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder(
//               future: getAllData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   if (snapshot.hasData) {
//                     return Expanded(
//                       child: ListView.builder(
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (context, index) {
//                           MenuModel menu = snapshot.data![index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(16),
//                                   child: Container(
//                                     width: 90,
//                                     height: 90,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(menu.image),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         menu.name,
//                                         style: GoogleFonts.montserrat(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         menu.description,
//                                         textAlign: TextAlign.left,
//                                         style: GoogleFonts.montserrat(
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       SizedBox(height: 12),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Rp. " + menu.price.toString(),
//                                             style: GoogleFonts.montserrat(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Row(
//                                             children: [
//                                               IconButton(
//                                                 onPressed: () {
//                                                   Provider.of<CartProvider>(
//                                                     context,
//                                                     listen: false,
//                                                   ).addRemove(menu.name,
//                                                       menu.id, false);
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.remove_circle,
//                                                   color: Colors.red,
//                                                 ),
//                                               ),
//                                               SizedBox(width: 10),
//                                               Consumer<CartProvider>(
//                                                 builder: (context, value, _) {
//                                                   var id = value.cart
//                                                       .indexWhere((element) =>
//                                                           element.menuId ==
//                                                           snapshot
//                                                               .data![index].id);
//                                                   return Text(
//                                                     (id == -1)
//                                                         ? "0"
//                                                         : value
//                                                             .cart[id].quantity
//                                                             .toString(),
//                                                     textAlign: TextAlign.left,
//                                                     style:
//                                                         GoogleFonts.montserrat(
//                                                             fontSize: 15),
//                                                   );
//                                                 },
//                                               ),
//                                               SizedBox(width: 10),
//                                               IconButton(
//                                                 onPressed: () {
//                                                   Provider.of<CartProvider>(
//                                                     context,
//                                                     listen: false,
//                                                   ).addRemove(
//                                                       menu.name, menu.id, true);
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.add_circle,
//                                                   color: Colors.green,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     return Center(
//                       child: Text("Tidak ada data"),
//                     );
//                   }
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
