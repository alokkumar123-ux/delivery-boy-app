// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class DeliveryOrdersPage extends StatefulWidget {
//   @override
//   _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
// }
//
// class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
//   // Replace with your backend WebSocket URL later
//   final channel = WebSocketChannel.connect(
//     Uri.parse('ws://your-backend-url.com/orders'),
//   );
//
//   List<String> orders = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Listen to new messages from the server
//     channel.stream.listen((message) {
//       setState(() {
//         orders.add(message); // Assume backend sends order info as string
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     channel.sink.close(); // Close socket when leaving page
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Orders")),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) => ListTile(
//           title: Text("Order: ${orders[index]}"),
//         ),
//       ),
//     );
//   }
// }
