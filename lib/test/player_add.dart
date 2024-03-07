// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:teammember/models/player_modal.dart';
// import 'package:teammember/providers/player_provider.dart';

// class Player {
//   String fullName;
//   String phoneNumber;
//   bool isSelected;

//   Player({
//     required this.fullName,
//     required this.phoneNumber,
//     this.isSelected = false,
//   });
// }

// class PlayerList extends ChangeNotifier {
//   List<Player> players = [];

//   void addPlayer(Player player) {
//     players.add(player);
//     notifyListeners();
//   }

//   void toggleSelection(int index) {
//     players[index].isSelected = !players[index].isSelected;
//     notifyListeners();
//   }

//   List<int> getSelectedPlayerIndices() {
//     List<int> selectedIndices = [];
//     for (int i = 0; i < players.length; i++) {
//       if (players[i].isSelected) {
//         selectedIndices.add(i);
//       }
//     }
//     return selectedIndices;
//   }
// }

// class AddPlayer extends StatelessWidget {
//   const AddPlayer({super.key});

//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => PlayerList(),
//       child: MaterialApp(
//         title: 'Selectable Player List',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: PlayerListScreen(),
//       ),
//     );
//   }
// }

// class PlayerListScreen extends StatelessWidget {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _mobileNumberController = TextEditingController();


//   void _addPlayer(BuildContext context) {
//     final String fullName = _fullNameController.text;
//     final String phoneNumber = _mobileNumberController.text;

//     if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
//       final Player player = Player(
//         fullName: fullName,
//         phoneNumber: phoneNumber,
//       );
//       final PlayerList playerList =
//           Provider.of<PlayerList>(context, listen: false);
//       playerList.addPlayer(player);

//       _fullNameController.clear();
//       _mobileNumberController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PlayerList playerList = Provider.of<PlayerList>(context);
//     final List<int> selectedPlayerIndices =
//         playerList.getSelectedPlayerIndices();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Selectable Player List'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () => _addPlayer(context),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _fullNameController,
//                     decoration: InputDecoration(labelText: 'Full Name'),
//                   ),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _mobileNumberController,
//                     decoration: InputDecoration(labelText: 'Phone Number'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => PlayerListView()),
//             ),
//             child: Text('View Player List'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PlayerListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final PlayerList playerList = Provider.of<PlayerList>(context);
//     final List<Player> players = playerList.players;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Player List'),
//         actions: [
//            IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text('Add Player'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextField(
//                           controller: _fullNameController,
//                           decoration: InputDecoration(
//                             labelText: 'Full Name',
//                           ),
//                         ),
//                         TextField(
//                           controller: _mobileNumberController,
//                           decoration: InputDecoration(
//                             labelText: 'Mobile Number',
//                           ),
//                           keyboardType: TextInputType.phone,
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         child: Text('Cancel'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       TextButton(
//                         child: Text('Add'),
//                         onPressed: () {
//                           final String fullName = _fullNameController.text;
//                           final String mobileNumber = _mobileNumberController.text;
//                           final PlayerModal newPlayer = PlayerModal(fullName, mobileNumber, '', false);
//                           Provider.of<PlayerProvider>(context, listen: false).addPlayer(newPlayer);
//                           Navigator.of(context).pop();
//                           _fullNameController.clear();
//                           _mobileNumberController.clear();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: players.length,
//         itemBuilder: (context, index) {
//           final Player player = players[index];

//           return ListTile(
//             title: Text(player.fullName),
//             subtitle: Text(player.phoneNumber),
//             onTap: () => playerList.toggleSelection(index),
//             leading: Checkbox(
//               value: player.isSelected,
//               onChanged: (_) => playerList.toggleSelection(index),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
