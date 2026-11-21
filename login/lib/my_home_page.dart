import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("xin chao", style: TextStyle(color: Colors.red, fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          Text("Hoàng cung cổ kính tọa lạc trong quần thể rộng lớn có tường bao quanh của tử cấm thành.", style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          Image.network("https://lh3.googleusercontent.com/grass-cs/AABkmLfrgiMJhiE3DS05MBFxI4T1M_NiC941jQ_4x2QHkb8Id9LJrNfJElx5n1ZAllde1qveXtKbFuNgnsax5Amq_YNogGBXspryRLDgUwPC_WeTO8b4tdeus2Xl5ZFLOZ1GvY3_4uXB-fbAS9TP=w408-h272-k-no"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.favorite, size: 50,color: Colors.red,),
              Icon(Icons.heart_broken, size: 50,color: Colors.red,),
              Icon(Icons.favorite, size: 50,color: Colors.red,)],
          )
        ],
      ));
  }
}