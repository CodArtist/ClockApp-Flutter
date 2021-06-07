import 'package:flutter/material.dart';

// class AlarmListItem extends StatefulWidget {
//  @override
//   _AlarmListItem createState()=> _AlarmListItem();

// }


class AlarmListItem extends StatelessWidget {
  // This widget is the root of your application.
  List<Color> alarmcolor=[];
  String sunormoon;
  String time;
  String hours;
  String minutes;
  AlarmListItem(String providedTime)
 { time=providedTime;
//  if(int.parse(time.split(":")[0])<10)
// time="0"+time.split(":")[0]+":"+(int.parse(time.split(":")[1])<10?"0"+time.split(":")[1]:time.split(":")[1]);

hours=time.split(":")[0];
minutes=time.split(":")[1];
if(int.parse(hours)<10)
hours="0"+hours;
if(int.parse(minutes)<10)
minutes="0"+minutes;
time=hours+":"+minutes;

 if(int.parse(providedTime.split(':')[0])>=16||int.parse(providedTime.split(':')[0])<=4)
 {alarmcolor=[Color(0XFF796583),Color(0XFF5F5564),Color(0XFF635D66),Color(0XFF372E3A)];
 
sunormoon="FlareAnimations/Moon.png";
if(int.parse(hours)>=16)
time=time+" PM";
else
time=time+" AM";

 }
 else
{ alarmcolor=[Color(0XFF00B5FF),Color(0XFF18A5D1),Color(0XFF269FC7),Color(0XFF2F93B5)];
sunormoon="FlareAnimations/Sun.png";
time=time+" AM";
}
 }
  @override
  Widget build(BuildContext context) {
     return Padding(
       padding:EdgeInsets.only(top:10,bottom:10,left:20,right:20),
     child:Container(
       decoration: BoxDecoration(
         borderRadius:BorderRadius.circular(30),
               gradient: LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end:
              Alignment(1, 0.0),
          colors: alarmcolor,
          
        ),
              boxShadow:[new BoxShadow(
            color: Colors.grey,
            blurRadius:10.0,
            offset: Offset(0,10),

          ),]
),
       height: 100,
       child:Row(
         children:<Widget>[
           
           Column(
         children:<Widget> [
         Padding(
             padding: EdgeInsets.only(top:20,left:10),
             child:Text(time,
         style:TextStyle(fontSize: 30,color:Colors.white)),
           ),
         
        
        Padding(
       padding: EdgeInsets.only(left:20),
         child:Text("Added on "+DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString(),
         style:TextStyle(fontSize: 13,color:Colors.white))
        ),
      
      Padding(
       padding: EdgeInsets.only(left:20),
         child:Text("Repeated Alarm",
         style:TextStyle(fontSize: 11,color:Colors.white))
        ),
       ],),

       Padding(
         padding: sunormoon=="FlareAnimations/Moon.png"?EdgeInsets.only(left:12):EdgeInsets.only(left:3.5),
       child:Image.asset(sunormoon),
       ),



         ],),
     ),
     );

  }
}