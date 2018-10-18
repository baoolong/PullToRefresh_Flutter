# pulltorefresh
[![pub package](https://img.shields.io/pub/v/pulltorefresh_flutter.svg)](https://pub.dartlang.org/packages/pulltorefresh_flutter)

上下拉控件，理论上适配所有可滑动View

A control that make the ScrollView to be pull to refresh and push  to load data.Theoretically compatible with all Scrollable Widgets

HomePage：[https://github.com/baoolong/PullToRefresh_Flutter](https://github.com/baoolong/PullToRefresh_Flutter)

MoreWidght：[https://github.com/OpenFlutter/PullToRefresh](https://github.com/OpenFlutter/PullToRefresh)

<img width="38%" height="38%" src="https://raw.githubusercontent.com/baoolong/PullToRefresh/master/demonstrationgif/20180813170926.gif"/>

## Usage
Add this to your package's pubspec.yaml file:

	dependencies:
	  pulltorefresh_flutter: "^0.1.1"
	  
If you want to use the default refresh image of this project (the rotated image), please download https://raw.githubusercontent.com/baoolong/PullToRefresh_Flutter/master/images/refresh.png to your images folder, and Pubspec.yaml is declared as follows.

If you want to use other images, put the image in the Images folder, declare it in the Pubspec.yaml file, and add the property refreshIconPath in the PullAndPush class.

     assets:
       - images/refresh.png
	
Add it to your dart file:

	import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';
## Example
    class PullAndPushTestState extends State<PullAndPushTest>{
	  	List<String> addStrs=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
	  	List<String> strs=["1","2","3","4","5","6","7","8","9","0"];
	  	ScrollController controller=new ScrollController();
	  	ScrollPhysics scrollPhysics=new AlwaysScrollableScrollPhysics();
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
	            itemCount: strs.length,//+2,
	            controller: controller,
	            physics: scrollPhysics,
	            itemBuilder: (BuildContext context,int index){
	              return new Container(
	                height: 35.0,
	                child: new Center(
	                  child: new Text(strs[index],style: new TextStyle(fontSize: 18.0),),
	                ),
	              );
	            }
	          ),
	          loadData: (isPullDown) async{
	            try {
	              var request = await httpClient.getUrl(Uri.parse(url));
	              var response = await request.close();
	              if (response.statusCode == HttpStatus.OK) {
	                _result = await response.transform(utf8.decoder).join();
	                setState(() {
	                  //拿到数据后，对数据进行梳理
	                  if(isPullDown){
	                    strs.clear();
	                    strs.addAll(addStrs);
	                  }else{
	                    strs.addAll(addStrs);
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
	            //必须写成这样  无需改动 只需Copy即可 Must be written like this, no need to change, just copy
	            setState(() {
	              scrollPhysics=physics;
	            });
	          },)
	      );
  	    }
	  }

## Notice
有时ListView的Item太少而不能铺满屏幕，导致ListView 不可Scroll，PullToRefresh也不可使用，所以ScrollPhysics必须是AlwaysScrollableScrollPhysics。

Sometimes the ListView has too few items to cover the screen, making the ListView not scrollable, and PullToRefresh is not available, so ScrollPhysics must be AlwaysScrollableScrollPhysics.

## LICENSE
    MIT License

	Copyright (c) 2018 baoolong
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
