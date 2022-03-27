import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payLoad;

  const NotificationScreen({Key? key, required this.payLoad}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payLoad = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payLoad = widget.payLoad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white :primaryClr
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Align(
            alignment: Alignment.center,
            child: Text(
              _payLoad.toString().split('|')[0],
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white :primaryClr),
              textAlign: TextAlign.center,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
           const SizedBox(
              height: 20,
            ),
           const Text(
              'Hello,Mohamed',
              style: TextStyle(
                color:  Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
           const SizedBox(
              height: 10,
            ),
             Text(
              ' you have new reminder',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const  SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              padding:const EdgeInsets.symmetric(horizontal:30,vertical:10),
              margin: const EdgeInsets.symmetric(horizontal:30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryClr,
              ),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    children: const[
                      Icon(
                        Icons.text_format,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                   Text(
                    _payLoad.toString().split('|')[0],
                    style: const TextStyle(
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children:const[
                      Icon(
                        Icons.description,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                  Text(
                    _payLoad.toString().split('|')[1],
                    style:const TextStyle(
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                 const SizedBox(height: 20,),
                  Row(
                    children:const[
                      Icon(
                        Icons.date_range,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Text(
                    _payLoad.toString().split('|')[2],
                    style: const TextStyle(
                        color:  Colors.white ),
                  ),
                  const SizedBox(height: 20,),

                ],
              ),
            )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
