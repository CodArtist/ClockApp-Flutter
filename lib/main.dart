
import 'dart:convert';

import 'package:flutter/material.dart';
import 'Widgets/AlarmListItem.dart';
import 'AddAlarmPanel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import'Widgets/Global variables/globals.dart';
import'package:path_provider/path_provider.dart';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();



void main() async{

  WidgetsFlutterBinding.ensureInitialized();
 

  var  initializationSettigsAndroid=AndroidInitializationSettings('splashclock');
 final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
  var initializationSettings=InitializationSettings(android:initializationSettigsAndroid);
 
   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload)async{
        if(payload!=null)
        debugPrint("payload");
      });
   runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: new ThemeData(
        primarySwatch: Colors.teal,
        canvasColor: Colors.transparent,
      ),
    home: MyHomePage(),
  );
}


class MyHomePage extends StatefulWidget{
  
  
  
  
  @override
  _MyHomePage createState()=> _MyHomePage();
}


class _MyHomePage extends State<MyHomePage> {


 
  
  static const String _message = 'This is the modal bottom sheet. Click anywhere to dismiss.';
  LocalStorage storage;

  List<String>alarmList=[];

  //  _MyHomePage()
  // {
  
  //     alarmList=globals.alarmList;
  //     print("hello world");
    
  // }
Future initializestorage()async{
storage=LocalStorage('Alarms');
    // print("jhbbjkljl");
     var info =jsonEncode({"0":"jkjj"});
    
    storage.setItem('alarminfo',info);
    await storage.ready;
    Map<String,dynamic>storedinfo=jsonDecode(storage.getItem("alarminfo"));
    print(storedinfo);
    return storedinfo;
}
  @override
  void initState()
  {super.initState();
    initializestorage().then((storedinfo){
      
       int i =1;
    if(!storedinfo.isEmpty)
    {while(storedinfo[i.toString()]!=null)
    {
      globals.alarmList.add(storedinfo[i.toString()]);
      i++;
    }
    }
      
       setState(() {
    alarmList=globals.alarmList;
  });
      } );

  }


  void scheduleAlarm(int channelId)async{
     
    
       
       Time time= Time(int.parse(alarmList[channelId].split(':')[0]),int.parse(alarmList[channelId].split(':')[1]),0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      visibility: NotificationVisibility.private,
      icon: 'splashclock',
      sound: RawResourceAndroidNotificationSound('hell'),
      largeIcon: DrawableResourceAndroidBitmap('splashclock'),

    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        // sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(channelId,"Alarm", "Alarm Set for"+alarmList[channelId].split(':')[0]+":"+alarmList[channelId].split(':')[1],time,platformChannelSpecifics);
      
  }

void deleteAlarm(int key)
{


  //**********remove from localstorage******************* */
  Map<String,dynamic>storedinfo=jsonDecode(storage.getItem("alarminfo"));
  Map<String,dynamic>temp=jsonDecode(jsonEncode({"0":"dfs"}));
  for(int i=0;i<alarmList.length;i++)
  {
    temp[(i+1).toString()]=alarmList[i];
  }

  var info =jsonEncode(temp);
  storage.setItem("alarminfo", info);

  flutterLocalNotificationsPlugin.cancelAll().then((value){
    print("deletedhjbhbh");
for(int i =0; i<alarmList.length;i++)
{
  scheduleAlarm(i);
}
  });
  
}

  void _showModalBottomSheet(BuildContext context) => 
  showModalBottomSheet<void>(
    context: context, 
    
    builder: (BuildContext context) =>AddAlarmPanel(),
).whenComplete((){
  print(globals.alarmList);
  setState(() {
    alarmList=globals.alarmList;
  });
});

  @override
  Widget build(BuildContext context) =>
  Scaffold(
        body:Container(
          // height:700,
          color: Colors.white,
          child:Row(
            children:<Widget>[

            //***********************ClockMenu**************************
             Container(
               color:Color(0XFF2361FF),

               width:80,
               child:Column(
                children:<Widget> [
                 Padding(
                   padding: EdgeInsets.only(top:30,left:7),
                   child: Container(
                     decoration: BoxDecoration(
                        borderRadius:BorderRadius.only(topLeft:Radius.circular(30),
                        bottomLeft:Radius.circular(30),
                        bottomRight:Radius.circular(15),
                        topRight:Radius.circular(15)),

                        color: Colors.white,
            
                     ),
                   
                    height:90,
                    width:250,
                    child: SvgPicture.asset("FlareAnimations/AlarmSelected.svg"),
                  ),
                 ),
                
                Padding(
                  padding: EdgeInsets.only(top:5,left:7),
                  child:Text("Alarm",
                  style:TextStyle(fontSize: 15,
                  color:Colors.white,
                  fontWeight:FontWeight.bold))
                ),
              


                 //************StopWatch**************************************** */
                  Padding(
                   padding: EdgeInsets.only(top:30,left:5),
                   child: Container(
                     decoration: BoxDecoration(
                        borderRadius:BorderRadius.only(topLeft:Radius.circular(30),
                        bottomLeft:Radius.circular(30),
                        bottomRight:Radius.circular(15),
                        topRight:Radius.circular(15)),
                       color:Color(0XFF2361FF),
                        // color:Colors.white,
            
                     ),
                   
                    height:90,
                    width:250,
                    child: Padding(
                      padding: EdgeInsets.only(bottom:10),
                      child:SvgPicture.asset("FlareAnimations/StopWatch.svg"),
                  ),
                 ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top:5,left:2),
                  child:Text("Stop \nWatch",textAlign: TextAlign.center,
                  style:TextStyle(fontSize: 15,
                  color:Colors.white,
                  fontWeight:FontWeight.bold,
                  
                  ))
                ),

              
              
              
              
              ],)
             ),//Menu
             

            //***************AlarmMenu************************************
           Expanded(
            child:Container(
              child:Column(
                children:<Widget> [

                //************AlarmHeading***********************************
              Container(
                  width:500,
                  height:80,
                  
                  child:Padding(
                    padding: EdgeInsets.only(top:30,left:30),
                    child:Text("Alarms",
                  style:TextStyle(fontSize: 40)),
                  ),
                  ),//AlarmHeading
               

              //**************AlarmList***************************************
              Container(
                height:450,
               child: ListView.builder(
                 itemCount:alarmList.isEmpty?0:alarmList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    // if(!globals.alarmList.isEmpty)
                    return Dismissible(
                      key:UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      child:AlarmListItem(alarmList[index]),
                      onDismissed: (direction){
                        setState(() {
                        alarmList.removeAt(index);  
                        });
                        deleteAlarm(index+1);
                        print(index);
                      
                      },
                      background: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // color:Colors.red
                        ),
                        ),
               );
                    // else
                    // return AlarmListItem("5:00");
                  },
  
),



              ),//AlarmList
              
               

             
              //**************AddAlarm***************************************
           Expanded(
            child: Container(
              child: Center(
                child:Container(

              height:75,
              width:75,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(37.5),
              color: Colors.white,
              boxShadow:[new BoxShadow(
            color: Colors.grey,
            blurRadius:10.0,
            offset: Offset(10,10),

          ),]),
          child: Center(
            child:FlatButton(
              onPressed:(){ 
              // scheduleAlarm();
              // storage.clear();
            
              _showModalBottomSheet(context);
            },
              child:Text("+",
            style: TextStyle(fontSize: 50),),
          ),
          )
              )//AddAlarm
              )
            ),
           ), 
              
              
              ],
              ),
              ),//AlarmMenu
           ),






          ],),
        ),
      );

}

