import 'package:LDS/Models/StaticAccount.dart';
import 'package:LDS/ViewModel/CoursViewModel.dart';
import 'package:LDS/Views/CoursView/addCours.dart';
import 'package:LDS/Views/CoursView/roomEleve.dart';
import 'package:LDS/Views/CoursView/roomEnse.dart';
import 'package:LDS/Views/HomeView/navBar.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListCoursNow extends StatefulWidget {
  @override
  _ListCoursNowState createState() => _ListCoursNowState();
}

class _ListCoursNowState extends State<ListCoursNow> {
  CoursViewModel coursViewModel = CoursViewModel();
  TextEditingController descriptionController = TextEditingController(text: "");

  List<String> messages = [];

  late dynamic orderChangeSocket;
  int pageOrderToday = 1, pageOther = 1;

  //final OrderViewModel orderViewModel = OrderViewModel();
  late Future<List<dynamic>> _futureOrders;

  late TextEditingController _searchController;
  late List<dynamic> orders; // List to store drivers
  late List<dynamic> ordersToday; // List to store drivers

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureOrders = coursViewModel.getCoursInProgress();

    orders = []; // Initialize the list
    _fetchOrders(); // Fetch drivers when the widget initializes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to fetch drivers
  Future<void> _fetchOrders() async {
    try {
      final _orders = await _futureOrders;

      setState(() {
        orders = _orders; // Update the list of drivers
      });
    } catch (error) {
      print('Error fetching drivers: $error');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Text(
            "Course in progress",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: ColorTheme.homeTopColor,
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavBar()),
              );
            },
          ),
        ),
        actions: [
        ],
      ),
      body: Container(
        color: ColorTheme.backgroundNormalColor,
        child: _buildListView(),
      ),
      floatingActionButton: StaticAccount.staticAccount.role == "Teacher"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddCours()),
          );
        },
        backgroundColor: ColorTheme.secColor,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null, // The button is not displayed if the condition is false
    );
  }

  Widget _buildListView() {
    double height = MediaQuery.of(context).size.height;
    return Column(
        children: [
          SizedBox(height: 10), // Add space of height 10
          Visibility(
            child: Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(left: 0, right: 0, bottom: 5),
                    color: ColorTheme.colorBackgroundCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 0), // Add spacing between image and ListTile
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          size: 20,
                                          color: ColorTheme.smalTitleColor),
                                      SizedBox(width: 5),
                                      Text(
                                        orders[index]['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorTheme.smalTitleColor,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range,
                                          size: 15,
                                          color: ColorTheme.smalTitleColor),
                                      SizedBox(width: 5),
                                      Text(
                                        (orders[index]['date']
                                            ?.toString()
                                            ?.substring(0, 10) ??
                                            "No Date"),
                                        style: TextStyle(
                                          color: ColorTheme.smalTitleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.access_time, size: 15),
                                          SizedBox(width: 5),
                                          Text(
                                            (orders[index]['date']
                                                ?.toString()
                                                ?.substring(11, 16) ??
                                                ""),
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.chalkboardTeacher, size: 15 ,color: Colors.teal,),
                                          SizedBox(width: 10),
                                          Text(
                                            "Professor " +
                                                orders[index]['nameprofessor'],
                                            style: TextStyle(color: Colors.teal,fontSize: 15),
                                          ),
                                        ],
                                      ),


                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "In progress" + " ",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(Icons.share_arrival_time,
                                              color: Colors.green, size: 15),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorTheme.smalTitleColor,
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                if (StaticAccount.staticAccount.role == "Teacher") {
                                  if(orders[index]['nameprofessor']==StaticAccount.staticAccount.name)
                                    {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RoomEnse(orders[index])),
                                  );}
                                  else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RoomEleve(orders[index])),
                                    );
                                  }
                                } else if (StaticAccount.staticAccount.role == "Student") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RoomEleve(orders[index])),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Add space of height 10
          SizedBox(height: height / 12), // Add space of height 10
        ],
    );
  }
}
