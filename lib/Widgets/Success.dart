import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class Success extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/2-150,left:50,right:50,bottom:50),
     
     child:Container(
      height:400,
       
       decoration: BoxDecoration(
         borderRadius:BorderRadius.circular(30),
             color: Colors.white,
            
),

       child:Column(

         children:<Widget> [

        
          Container(
            height:300,
            width:300,
            
            // color: Colors.green[400],
            

         child:FlareActor("FlareAnimations/Success Check.flr",
          alignment:Alignment.center, 
          fit:BoxFit.contain, 
          animation:"Untitled",
          callback:(string){
            Navigator.pop(context);
          })
          ),
       
       Text("Alarm Added",
       style:TextStyle(fontSize: 30,
       color:Colors.black))
       
       
       
       
       ],)

     
     ),

     );
     
  }
}