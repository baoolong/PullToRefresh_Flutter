import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';

class PullAndPushTest extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new PullAndPushTestState();
  }
}


class PullAndPushTestState extends State<PullAndPushTest>{
  List<String> addStrings=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  List<String> initialStrings=["1","2","3","4","5","6","7","8","9","0"];
  ScrollController controller=new ScrollController();
  //For compatibility with ios ,must use RefreshAlwaysScrollPhysics ;为了兼容ios 必须使用RefreshAlwaysScrollPhysics
  ScrollPhysics scrollPhysics=new RefreshAlwaysScrollPhysics();
  //使用系统的请求
  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result="";


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("上下拉刷新"),
      ),
      body: new PullAndPush(
        listView: new ListView.builder(
          //ListView的Item
          itemCount: initialStrings.length,//+2,
          controller: controller,
          physics: scrollPhysics,
          itemBuilder: (BuildContext context,int index){
            return new Container(
              height: 35.0,
              child: new Center(
                child: new Text(initialStrings[index],style: new TextStyle(fontSize: 18.0),),
              ),
            );
          }
        ),
        loadData: (isPullDown) async{
          try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();
            if (response.statusCode == HttpStatus.ok) {
              _result = await response.transform(utf8.decoder).join();
              setState(() {
                //拿到数据后，对数据进行梳理
                if(isPullDown){
                  initialStrings.clear();
                  initialStrings.addAll(addStrings);
                }else{
                  initialStrings.addAll(addStrings);
                }
              });
            } else {
              _result = 'error code : ${response.statusCode}';
            }
          } catch (exception) {
            _result = '网络异常';
          }
          print(_result);
        },
        scrollPhysicsChanged: (ScrollPhysics physics) {
          //必须写成这样  无需改动 只需Copy即可
          setState(() {
            scrollPhysics=physics;
          });
        },)
    );
  }
}






