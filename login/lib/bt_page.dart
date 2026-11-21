import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class BtHomePage extends StatelessWidget {
  const BtHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Text("xin chao", style: TextStyle(color: Colors.red, fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [Text("Welcome to Amargedon", style: TextStyle(color: Colors.green, fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),],),
              Column(
                children: [
                  Icon(Icons.star),
                  Text("41")
                ]
              ),
              FilledButton(
                onPressed: () async 
                {
                  final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
                  final response = await dio.get('/products', queryParameters: {'limit': 5});
                  final List danhSach = response.data['products'];
                  for (final sp in danhSach) 
                  {
                    print('${sp['title']}: ${sp['price']} USD');
                  }
                },
                child: const Text('Gọi API'),
              )
              

            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.call, size: 50,color: Colors.red,),
                  Text("Call")
                ],
              ),
              Column(
                children: [
                  Icon(Icons.map, size: 50,color: Colors.red,),
                  Text("Route")
                ],
              ),
               Column(
                children: [
                  Icon(Icons.share, size: 50,color: Colors.red,),
                  Text("Share")
                ],
              ),
          ]
          )]
          ,
      ));
  }
}