import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:honchos_driver_app/constants.dart';
import 'package:honchos_driver_app/model/order_model.dart';
import 'package:honchos_driver_app/view/auth/login/login_screen.dart';
import 'package:honchos_driver_app/view/home/orderDetail/order_detail_screen.dart';
import 'package:honchos_driver_app/view/splash/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DriverHomeScreen extends StatefulWidget {

  const DriverHomeScreen({Key? key, }) : super(key: key);

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  String? renterEmail = '', renterName = '', renterUid = '',  readyToCollect = '', collect = '',delivered = '';
  List<DriverOrdersModel> ordersList = [];
  bool isLoading = false;
  String isListEmpty = '';


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isListEmpty = '';
      isLoading = true;
      renterName = '';
      renterEmail = '';
      renterUid = '';
      readyToCollect = '';
      collect = '';
      delivered = '';
    });
    getOrders();
    super.initState();
  }


  getOrders() async {
    // var headers = {
    //   'Cookie': 'restaurant_session=NUZ9J67CmsrRkWPqW765evDXDBCttdgnKtygvzSR'
    // };
    // var request = http.Request('GET', Uri.parse('http://restaurant.wettlanoneinc.com/api/driver/orders'));

    var headers = {

    'Cookie': 'restaurant_session=$cookie'
    };
    var request = http.Request('GET', Uri.parse('http://restaurant.wettlanoneinc.com/api/driver/orders'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {

      setState(() {
        ordersList = List<DriverOrdersModel>.from(json.decode(responseData).map((x) => DriverOrdersModel.fromJson(x)));
      });


      for(int i=0 ; i<ordersList.length; i++) {

        if(ordersList[i].order!.status.toString() == 'Ready for collection') {
         setState(() {
           readyToCollect = 'yes';
         });
        } else if (ordersList[i].order!.status.toString() == 'Collected') {

          setState(() {

            collect = 'yes';
          });

        } else if(ordersList[i].order!.status.toString() == 'Delivered') {

          setState(() {

            delivered = 'yes';
          });

        }

      }

      if(ordersList.isEmpty) {
        setState(() {
          isListEmpty = 'yes';
          isLoading = false;
        });
      } else {
        setState(() {
          isListEmpty = 'no';
          isLoading = false;
        });
      }

    }
    // else if (response.statusCode == 420) {
    //   SharedPreferences preferences = await SharedPreferences.getInstance();
    //   var snackBar = SnackBar(content: Text('Session expires login to continue'
    //     ,style: TextStyle(color: Colors.white),),
    //     backgroundColor: Colors.red,
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   await preferences.clear().then((value){
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginScreen()),
    //     );
    //   });
    // }
    else {
      print(response.reasonPhrase);
      setState(() {
        isListEmpty = 'yes';
        isLoading = false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return

      DefaultTabController(
        length: 3,
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
                // git remote add origin https://github.com/junaid4jd/honchos_driver_app.git
                // git push -f origin main
                backgroundColor: lightRedColor,
                bottom: TabBar(
                  unselectedLabelStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  onTap: (index) {
                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    Tab(text: 'Deliveries',),
                    Tab(text: 'Collected',),
                    Tab(text: 'Completed',),
                  ],
                ),
                centerTitle: true,
                title: Text('Driver'),
              ),
              body: TabBarView(
                children: [
                  // Container(
                  //   child: Column(children: [
                  //     SizedBox(
                  //       height: size.height*0.01,
                  //     ),
                  //
                  //
                  //     SizedBox(
                  //       height: size.height*0.03,
                  //     ),
                  //   ],),
                  // ),


                  isLoading && isListEmpty == '' ? Center(child: CircularProgressIndicator(
                    color: darkRedColor,
                    strokeWidth: 1,
                  )) :


                  (ordersList.isEmpty && isListEmpty == 'yes') || readyToCollect == ''   ? Center(
                    child: Container(
                      child: Text('No New Orders Found'),

                    ),
                  ) :
                  SizedBox(
                    // height: size.height*0.25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ordersList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context,index
                          ) {

                        // for(int i=0; i<ordersList[index].ordersItems!.length ; i++) {
                        //   totalAmount = totalAmount +
                        // }

                        return
                          ordersList[index].order!.status.toString() == "Ready for collection" ?

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrderDetailScreen(orderModel: ordersList[index],)),
                              ).then((value) {
                                getOrders();
                              });
                            },
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8,),
                                child: Container(
                                  width: size.width*0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: lightButtonGreyColor,
                                          spreadRadius: 2,
                                          blurRadius: 3
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [

                                        SizedBox(
                                          height: size.height*0.08,
                                          width: size.width*0.25,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset('assets/images/order.png', fit: BoxFit.scaleDown,
                                              height: size.height*0.08,
                                              width: size.width*0.25,
                                              // height: 80,
                                              // width: 80,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: size.width*0.6,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Order No : ${ordersList[index].order!.orderNo.toString()}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 13,fontWeight: FontWeight.w600),),
                                                  ],),
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Items : ${ordersList[index].ordersItems!.length}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 12,fontWeight: FontWeight.w400),),
                                                  ],),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMMd().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()
                                                          + ' '  +DateFormat.jm().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()

                                                      ,
                                                      style: TextStyle(color: Color(0xFF585858),
                                                          fontSize: 12,fontWeight: FontWeight.w500),),


                                                    // Text('\$30.99',
                                                    //   style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w600),),

                                                  ],),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(ordersList[index].order!.status.toString(),
                                                          style: TextStyle(color: Colors.white,
                                                              fontSize: 12,fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),




                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],),
                          ) : Container();
                      },

                    ),
                  ),


                  isLoading && isListEmpty == '' ? Center(child: CircularProgressIndicator(
                    color: darkRedColor,
                    strokeWidth: 1,
                  )) :


                  (ordersList.isEmpty && isListEmpty == 'yes') || collect == ''  ? Center(
                    child: Container(
                      child: Text('No Collected Orders Found'),

                    ),
                  ) :
                  SizedBox(
                    // height: size.height*0.25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ordersList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context,index
                          ) {

                        // for(int i=0; i<ordersList[index].ordersItems!.length ; i++) {
                        //   totalAmount = totalAmount +
                        // }

                        return
                          ordersList[index].order!.status.toString() == "Collected" ?

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrderDetailScreen(orderModel: ordersList[index],)),
                              ).then((value) {
                                getOrders();
                              });
                            },
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8,),
                                child: Container(
                                  width: size.width*0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: lightButtonGreyColor,
                                          spreadRadius: 2,
                                          blurRadius: 3
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [

                                        SizedBox(
                                          height: size.height*0.08,
                                          width: size.width*0.25,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset('assets/images/order.png', fit: BoxFit.scaleDown,
                                              height: size.height*0.08,
                                              width: size.width*0.25,
                                              // height: 80,
                                              // width: 80,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: size.width*0.6,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Order No : ${ordersList[index].order!.orderNo.toString()}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 13,fontWeight: FontWeight.w600),),
                                                  ],),
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Items : ${ordersList[index].ordersItems!.length}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 12,fontWeight: FontWeight.w400),),
                                                  ],),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMMd().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()
                                                          + ' '  +DateFormat.jm().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()

                                                      ,
                                                      style: TextStyle(color: Color(0xFF585858),
                                                          fontSize: 12,fontWeight: FontWeight.w500),),


                                                    // Text('\$30.99',
                                                    //   style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w600),),

                                                  ],),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(ordersList[index].order!.status.toString(),
                                                          style: TextStyle(color: Colors.white,
                                                              fontSize: 12,fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),




                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],),
                          ) : Container();
                      },

                    ),
                  ),

                  // Container(
                  //   child: Column(children: [
                  //     SizedBox(
                  //       height: size.height*0.01,
                  //     ),
                  //
                  //
                  //     SizedBox(
                  //       height: size.height*0.03,
                  //     ),
                  //   ],),
                  // ),
                  isLoading && isListEmpty == '' ? Center(child: CircularProgressIndicator(
                    color: darkRedColor,
                    strokeWidth: 1,
                  )) :


                  (ordersList.isEmpty && isListEmpty == 'yes') || delivered == '' ? Center(
                    child: Container(
                      child: Text('No Delivered Orders Found'),

                    ),
                  ) :
                  SizedBox(
                    // height: size.height*0.25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ordersList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context,index
                          ) {

                        // for(int i=0; i<ordersList[index].ordersItems!.length ; i++) {
                        //   totalAmount = totalAmount +
                        // }

                        return
                          ordersList[index].order!.status.toString() == "Delivered" ?

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrderDetailScreen(orderModel: ordersList[index],)),
                              ).then((value) {
                                getOrders();
                              });
                            },
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8,),
                                child: Container(
                                  width: size.width*0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: lightButtonGreyColor,
                                          spreadRadius: 2,
                                          blurRadius: 3
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [

                                        SizedBox(
                                          height: size.height*0.08,
                                          width: size.width*0.25,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset('assets/images/order.png', fit: BoxFit.scaleDown,
                                              height: size.height*0.08,
                                              width: size.width*0.25,
                                              // height: 80,
                                              // width: 80,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: size.width*0.6,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Order No : ${ordersList[index].order!.orderNo.toString()}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 13,fontWeight: FontWeight.w600),),
                                                  ],),
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Items : ${ordersList[index].ordersItems!.length}',
                                                      style: TextStyle(color: Colors.black,
                                                          fontSize: 12,fontWeight: FontWeight.w400),),
                                                  ],),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMMd().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()
                                                          + ' '  +DateFormat.jm().format(DateTime.parse(ordersList[index].createdAt.toString())).toString()

                                                      ,
                                                      style: TextStyle(color: Color(0xFF585858),
                                                          fontSize: 12,fontWeight: FontWeight.w500),),


                                                    // Text('\$30.99',
                                                    //   style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w600),),

                                                  ],),
                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(ordersList[index].order!.status.toString(),
                                                          style: TextStyle(color: Colors.white,
                                                              fontSize: 12,fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: size.height*0.01,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),




                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],),
                          ) :
                          Container();
                      },

                    ),
                  ),

                  // Container(
                  //   child: Column(children: [
                  //     SizedBox(
                  //       height: size.height*0.01,
                  //     ),
                  //
                  //
                  //     SizedBox(
                  //       height: size.height*0.03,
                  //     ),
                  //   ],),
                  // ),

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
