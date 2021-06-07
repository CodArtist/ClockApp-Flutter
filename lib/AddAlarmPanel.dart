import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'Widgets/Success.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import'Widgets/Global variables/globals.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


class AddAlarmPanel extends StatefulWidget{
  
 
  
  
  
  @override
  _AddAlarmPanel createState()=> _AddAlarmPanel();
}






class _AddAlarmPanel extends State<AddAlarmPanel> {
  // This widget is the root of your application.

   
   
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

FixedExtentScrollController _hoursScrollController;
FixedExtentScrollController _minutesScrollController;
LocalStorage storage;

int channelId=1;
String SelectedHours="00";
List<int>Hours=[];
 var hoursScrollValue;

 String SelectedMinutes="00";
List<int>Minutes=[];
 var minutesScrollValue;




  void scheduleAlarm(int channelId)async{
     
    //  var scheduledNotificationDateTime=DateTime.parse("2021-02-07 "+SelectedHours.toString()+":"+SelectedMinutes.toString()+":00");
    //  DateTime.now().add(Duration(seconds:10));
    //  DateTime.now().subtract(Duration(hours: DateTime.now().hour,))
      // DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
       Time time= Time(hoursScrollValue,minutesScrollValue,0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      fullScreenIntent:true,
      icon: 'splashclock',
     
      sound: RawResourceAndroidNotificationSound('hell'),
     
      additionalFlags:Int32List(4),
      largeIcon: DrawableResourceAndroidBitmap('splashclock'),

    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        // sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(channelId,"Alarm", "Alarm Set for"+SelectedHours+":"+SelectedMinutes,time,platformChannelSpecifics);
      
  }

@override
void initState()
{
  super.initState();
  _hoursScrollController=FixedExtentScrollController();
  _hoursScrollController.addListener(hoursOffsetProvider);

  _minutesScrollController=FixedExtentScrollController();
  _minutesScrollController.addListener(minutesOffsetProvider);

  storage=LocalStorage('Alarms');
// storage.clear();
if(storage.getItem("alarminfo")==null)
{
  var info =jsonEncode({"0":"jkjj"});
storage.setItem("alarminfo",info);
}
Map<String,dynamic>storedinfo=jsonDecode(storage.getItem("alarminfo"));
// var info =jsonEncode({"0":"jkjj"});
// storage.setItem("alarminfo",info);
print(storage.getItem("alarminfo"));
globals.alarmList.clear();
  int i =1;
while(storedinfo[i.toString()]!=null)
{
 globals.alarmList.add(storedinfo[i.toString()]);
 i++;
}
// // if(alarmList.isEmpty)
print("Alarm list is");
print(globals.alarmList);
  

  setState(() {
    for(var i=0;i<=23;i++)
    {
    Hours.add(i);
    }
    for(var i=0;i<=59;i++)
    Minutes.add(i);  

  });



}



void addAlarm(Time time,int id)
{

  Map<String,dynamic> storedinfo=jsonDecode(storage.getItem("alarminfo"));
//*********adding to storage************* */
  if(!globals.alarmList.isEmpty)
 { storedinfo[(globals.alarmList.length+1).toString()]=time.hour.toString()+":"+time.minute.toString();
 scheduleAlarm(globals.alarmList.length+1);
 
 }
  else
    {storedinfo["1"]=time.hour.toString()+":"+time.minute.toString();
    scheduleAlarm(1);
    }

//***********adding to alarmList*********** */
  globals.alarmList.add(time.hour.toString()+":"+time.minute.toString());

  var info=jsonEncode(storedinfo);

  storage.setItem("alarminfo",info);
  
}


void deleteAlarm(int key)
{
  //************remove from alarm List******************* */
  globals.alarmList.removeAt(key-1);

  //**********remove from localstorage******************* */
  print("deleted globals.alarmList");
  print(globals.alarmList);
  Map<String,dynamic>storedinfo=jsonDecode(storage.getItem("alarminfo"));
  Map<String,dynamic>temp=jsonDecode(jsonEncode({"0":"dfs"}));
  for(int i=0;i<globals.alarmList.length;i++)
  {
    temp[(i+1).toString()]=globals.alarmList[i];
  }

  var info =jsonEncode(temp);
  storage.setItem("alarminfo", info);

  // storedinfo.remove(key.toString());
  // storedinfo.updateAll((keys, value){
  //   if(int.parse(keys)>key)
  //   keys=(int.parse(keys)-1).toString();
  //   else
  //   value=value;

  // });
  // print(storedinfo);
  // var info =jsonEncode(storedinfo);
  // storage.setItem("alarminfo", info);


  
}



Widget timeItem(FixedExtentScrollController _scrollController,var items)
{
  return  Padding(
    padding: EdgeInsets.only(top:50),
    child:Container(
          height: 150,
          width: 70,
          // color:Colors.blue,
        child:ListWheelScrollView(
              // controller: _controller,
             controller: _scrollController,
             itemExtent: 80,
             diameterRatio: 1.5,
             useMagnifier: true,
             magnification: 1.1,
             
             physics: FixedExtentScrollPhysics(),
             overAndUnderCenterOpacity: 0.5,
          children:<Widget> [

         for ( var i in items )
          Padding(
             padding: EdgeInsets.only(top:0),
             child: Text(i<10?"0"+i.toString():i.toString(),
            style: TextStyle(fontSize: 40,
            color:Colors.black),),
           )

        ],
        )
        ),
  );

}



hoursOffsetProvider()
{
  hoursScrollValue= _hoursScrollController.offset.round();
  hoursScrollValue=(hoursScrollValue/76).round();
  //after 9 -1
  if(hoursScrollValue>9)
  hoursScrollValue--;
  // setState(() {
  //   SelectedHours=hoursScrollValue;
  // });
  if(hoursScrollValue<10)
    SelectedHours="0"+hoursScrollValue.toString();
    else
     SelectedHours=hoursScrollValue.toString();


  
    // print(SelectedHours);


}

minutesOffsetProvider()
{
  minutesScrollValue= _minutesScrollController.offset.round();
  minutesScrollValue=(minutesScrollValue/78).round();
  if(minutesScrollValue>=19)
  minutesScrollValue--;
  if(minutesScrollValue==60)
  minutesScrollValue--;
  // print(minutesScrollValue);
if(minutesScrollValue<10)
    SelectedMinutes="0"+minutesScrollValue.toString();
    else
     SelectedMinutes=minutesScrollValue.toString();}



   static void successPanel(BuildContext context) => 
  showModalBottomSheet<void>(
    context: context, 
    enableDrag: false,
    builder: (BuildContext context) =>Success(),
    isScrollControlled: true,
);
  @override
  Widget build(BuildContext context) {



     return Scaffold(
       body: Padding(
       padding:EdgeInsets.only(top:10,bottom:10,left:20,right:20),
     child:Container(
       decoration: BoxDecoration(
         borderRadius:BorderRadius.circular(30),
              color: Colors.white,
            
),
       height: 500,
       child:Column(
         children:<Widget> [

        Text("Add Alarm"),

        Row(
          children:<Widget> [
          //*************hours***************** */
          Padding(
            padding: EdgeInsets.only(left:55),
          child:timeItem(_hoursScrollController, Hours),
          ),
          
          Padding(
            padding:EdgeInsets.only(top:50),
            child:Container(
                height: 150,
               width: 70,
          // color:Colors.blue,
              child:Padding(
                padding: EdgeInsets.only(left: 30,top: 30),
                child:Text(":",
              style:TextStyle(fontSize:40,
              color:Colors.black)),
            ),
            ),
          ),
          
          //************minutes*************** */
          Padding(
            padding: EdgeInsets.only(left: 0),
          child:timeItem(_minutesScrollController, Minutes),
          ),
        
        
        ],
        ),
       
        
          Container(
            height:100,
            width:100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20)
            ),
            
            child:FlatButton(
              onPressed: (){
                Navigator.pop(context);
                //  scheduleAlarm(channelId);
                // storage.clear();
              //  alarmList.clear();
            // var time= DateTime.parse("2021-02-07 "+SelectedHours.toString()+":"+SelectedMinutes.toString()+":00");
             Time time= Time(hoursScrollValue,minutesScrollValue,0); 
            //  print(time.hour);
              // deleteAlarm(3);
              addAlarm(time,channelId);

               successPanel(context);
               
              //  print(DateTime.now().hour-time.hour);

              },
              child: Text("Save"),
              ),
          ),
       ],)

     ),
     ),
     );

  }
}






// class HoursItem extends StatelessWidget{
//   // This widget is the root of your application.


 
//   @override
//   Widget build(BuildContext context) {
  
//   return   Container(
//           height: 150,
//           width: 70,
//           color:Colors.blue,
//         child:ListWheelScrollView(
//               // controller: _controller,
//              controller: _scrollController,
//              itemExtent: 80,
//              diameterRatio: 1.5,
//              useMagnifier: true,
//              magnification: 1.1,
             
//              physics: FixedExtentScrollPhysics(),
//              overAndUnderCenterOpacity: 0.5,
//           children:<Widget> [

//          for ( var i in Hours )
//           Padding(
//              padding: EdgeInsets.only(top:0),
//              child: Text(i.toString(),
//             style: TextStyle(fontSize: 40,
//             color:Colors.black),),
//            )

        
//         ],
//         )
//         );

//   }

// }