import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:honchos_driver_app/constants.dart';
import 'package:honchos_driver_app/model/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as dp;
import 'package:geolocator/geolocator.dart';
import 'package:honchos_driver_app/model/order_model.dart';
import 'package:honchos_driver_app/view/auth/login/login_screen.dart';
import 'package:honchos_driver_app/view/home/home_screen.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/restaurant_model.dart';


class OrderDetailScreen extends StatefulWidget {
  final DriverOrdersModel orderModel;
  const OrderDetailScreen({Key? key, required this.orderModel}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int total = 0;
  List<RestaurantModel> restaurantList = [];
  String distance = '', address = '';
  double distanceInKm = 0.0;
  bool isLoading = false;


  totalAmount() async {

    for(int i=0; i<widget.orderModel.ordersItems!.length; i++) {

      setState(() {
        total = total + (int.parse(widget.orderModel.ordersItems![i].payment.toString()) * int.parse(widget.orderModel.ordersItems![i].quantity.toString()));
      });

    }

  }


  updateStatus(String status) async {

    var headers = {
      'Cookie': 'restaurant_session=NUZ9J67CmsrRkWPqW765evDXDBCttdgnKtygvzSR'
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://restaurant.wettlanoneinc.com/api/driver/order_update_status/${widget.orderModel.order!.id}'));
    request.fields.addAll({
      'status': status
    });


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverHomeScreen()),
      ).then((value) {

        var snackBar = SnackBar(content: Text('Status successfully updated to $status',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      });



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
        isLoading = false;
      });

      var snackBar = SnackBar(content: Text('Something went wrong',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }


  }





  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      distance = '';
    });

    totalAmount();



    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(widget.orderModel.order!.id.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
            'Order Detail',
          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => DashBoardScreen(index:1)));
              // Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                'assets/images/arrow_back.png',
                height: 20,
                width: 20,
                fit: BoxFit.scaleDown,
              ),
            )),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: size.width*0.8,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status ',
                          style: TextStyle(color: Colors.black,
                              fontSize: 14,fontWeight: FontWeight.w600),),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.orderModel.order!.status.toString(),
                          style: TextStyle(color: Colors.blue,
                              fontSize: 14,fontWeight: FontWeight.bold),),

                      ],),

                    SizedBox(
                      height: size.height*0.01,
                    ),


                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => OrderDetailScreen(order: ordersList[index])),
                // );
              },
              child: Center(
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

                            Container(
                              width: size.width*0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height*0.01,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Order Number : ${widget.orderModel.order!.orderNo.toString()}',
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w500),),

                                      ],),

                                    SizedBox(
                                      height: size.height*0.01,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat.yMMMMd().format(DateTime.parse(widget.orderModel.createdAt.toString())).toString()
                                              + ' '  +DateFormat.jm().format(DateTime.parse(widget.orderModel.createdAt.toString())).toString()

                                          ,
                                          style: TextStyle(color: Color(0xFF585858),
                                              fontSize: 13,fontWeight: FontWeight.w500),),


                                        // Text('\$30.99',
                                        //   style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w600),),

                                      ],),

                                    SizedBox(
                                      height: size.height*0.01,
                                    ),

                                    // git init
                                    // git add README.md
                                    // git commit -m "first commit"
                                    // git branch -M main
                                    // git remote add origin https://github.com/junaid4jd/honchos_restaurant_app.git
                                    // git push -f origin main



                                  ],
                                ),
                              ),
                            ),




                          ],
                        ),
                      ),
                    ),
                  ),

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

                            Container(
                              width: size.width*0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height*0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Delivered To ',
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w600),),

                                        // SizedBox(
                                        //   height: 20,
                                        //   width: 20,
                                        //   child: Image.asset('assets/images/cross.png', fit: BoxFit.scaleDown,
                                        //
                                        //     // height: 80,
                                        //     // width: 80,
                                        //   ),
                                        //),
                                      ],),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${widget.orderModel.order!.user!.name.toString()}\n${widget.orderModel.order!.user!.email.toString()}\n${widget.orderModel.order!.user!.phoneNo.toString()} ',
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w500),),

                                      ],),

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

                  widget.orderModel.order!.address == null ? SizedBox() :
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

                            Container(
                              width: size.width*0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height*0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Delivery Address ',
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w600),),

                                        // SizedBox(
                                        //   height: 20,
                                        //   width: 20,
                                        //   child: Image.asset('assets/images/cross.png', fit: BoxFit.scaleDown,
                                        //
                                        //     // height: 80,
                                        //     // width: 80,
                                        //   ),
                                        //),
                                      ],),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.orderModel.order!.address.toString(),
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w500),),

                                      ],),

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

                  widget.orderModel.ordersItems!.isEmpty  ? Container(
                    child: Text('No order item found',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),),
                  ) :
                  SizedBox(
                    // height: size.height*0.25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.orderModel.ordersItems!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context,index
                          ) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16,),
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
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  children: [

                                    Container(
                                      decoration: BoxDecoration(
                                        color: lightButtonGreyColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: size.height*0.07,
                                          width: size.width*0.2,
                                          fit: BoxFit.cover,
                                          imageUrl: imageConstUrlProduct+widget.orderModel.ordersItems![index].product!.image.toString(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: size.height*0.07,
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(widget.orderModel.ordersItems![index].product!.name.toString(),
                                                  style: TextStyle(color: Color(0xFF585858),
                                                      fontSize: 14,fontWeight: FontWeight.w500),),

                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height*0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Quantity : ' + widget.orderModel.ordersItems![index].quantity.toString(),
                                                  //quantity.toString(),
                                                  style: TextStyle(color: Color(0xFF585858), fontSize: 14,fontWeight: FontWeight.w600),),
                                               // widget.order.ordersItems![index].product!.price.toString()
                                                Text('ZAR '+ '${
                                                int.parse(widget.orderModel.ordersItems![index].product!.price.toString())*int.parse(widget.orderModel.ordersItems![index].quantity.toString())
                                                }',
                                                  style: TextStyle(color: Color(0xFF585858), fontSize: 12,fontWeight: FontWeight.w600),),
                                              ],
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

                        ],);
                      },

                    ),
                  ),

                  SizedBox(
                    height: size.height*0.03,
                  ),

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

                            Container(
                              width: size.width*0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height*0.01,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Order Total : ',
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14,fontWeight: FontWeight.w500),),
                                        Text('ZAR '+total.toString(),
                                          style: TextStyle(color: Colors.red,
                                              fontSize: 12,fontWeight: FontWeight.w600),),
                                        // SizedBox(
                                        //   height: 20,
                                        //   width: 20,
                                        //   child: Image.asset('assets/images/cross.png', fit: BoxFit.scaleDown,
                                        //
                                        //     // height: 80,
                                        //     // width: 80,
                                        //   ),
                                        //),
                                      ],),

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
              ),
            ),



            SizedBox(
              height: size.height*0.05,
            ),

            widget.orderModel.order!.status.toString() == 'Delivered' ? Container() :

            isLoading ? Center(child: CircularProgressIndicator(
              color: darkRedColor,
              strokeWidth: 1,
            )) :
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Container(

                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      darkRedColor,
                      lightRedColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(Size(size.width, 50)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {


                      if( widget.orderModel.order!.status.toString() == 'Ready for collection') {
                        setState(() {
                          isLoading = true;
                        });
                        updateStatus('Collected');
                      } else if(widget.orderModel.order!.status.toString() == 'Collected') {
                        setState(() {
                          isLoading = true;
                        });
                        updateStatus('Delivered');
                      }





                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => EnableLocationScreen()));

                    }, child: Text(
                    widget.orderModel.order!.status.toString() == 'Ready for collection' ? 'Collect' : 'Deliver'
                    , style: buttonStyle)),
              ),
            ),

            SizedBox(
              height: size.height*0.05,
            ),

        ],),
      ),

    );
  }
}
