import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:honchos_driver_app/constants.dart';
import 'package:honchos_driver_app/view/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHomeScreen extends StatefulWidget {

  const DriverHomeScreen({Key? key, }) : super(key: key);

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  String? renterEmail = '', renterName = '', renterUid = '';



  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      renterName = '';
      renterEmail = '';
      renterUid = '';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return

      DefaultTabController(
        length: 2,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WillPopScope(
            onWillPop:  showExitPopup,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // iconTheme: IconThemeData(color: Colors.white),

                actions: [
                  IconButton(onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if(prefs.getString('userPhone') != null && prefs.getString('userEmail') != null) {

                      prefs.remove('userPhone');
                      prefs.remove('userEmail');

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()));

                    }


                  },icon: Icon(Icons.logout,color: Colors.white,),),
                ],
                backgroundColor: lightRedColor,
                bottom: TabBar(
                  onTap: (index) {
                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    Tab(text: 'Deliveries',),
                    Tab(text: 'Completed deliveries',),
                  ],
                ),
                centerTitle: true,
                title: Text('Driver'),
              ),
              body: TabBarView(
                children: [
                  Container(),
                  Container(),

                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<bool> showExitPopup() async {


      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the App?'),
          actions:[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },



              //return true when click on "Yes"
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              child:Text('Yes'),
            ),

          ],
        ),
      )??false;

    //if showDialouge had returned null, then return false
  }

}
