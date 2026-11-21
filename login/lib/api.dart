import 'package:dio/dio.dart';

Future<Map<String, dynamic>> layMotSanPham() async {
  final dio = Dio();
  final response = await dio.get("https://dummyjson.com/products/1");
  print(response.data['title']);
  if (response.statusCode != 200) {
    throw Exception('Không thể tải sản phẩm (${response.statusCode})');
  }

  return Map<String, dynamic>.from(response.data as Map);
}
