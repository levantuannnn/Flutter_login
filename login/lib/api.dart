import 'package:dio/dio.dart';

Future<List<Map<String, dynamic>>> layDanhSachSanPham({int limit = 5}) async {
  final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  final response = await dio.get(
    '/products',
    queryParameters: {'limit': limit},
  );

  if (response.statusCode != 200) {
    throw Exception('Không thể tải danh sách sản phẩm (${response.statusCode})');
  }

  final data = Map<String, dynamic>.from(response.data as Map);
  final products = data['products'];
  if (products is! List) {
    throw const FormatException('Dữ liệu danh sách sản phẩm không hợp lệ');
  }

  return products
      .map((product) => Map<String, dynamic>.from(product as Map))
      .toList();
}

Future<Map<String, dynamic>> layMotSanPham() async {
  final dio = Dio();
  final response = await dio.get("https://dummyjson.com/products/1");
  print(response.data['title']);
  if (response.statusCode != 200) {
    throw Exception('Không thể tải sản phẩm (${response.statusCode})');
  }

  return Map<String, dynamic>.from(response.data as Map);
}
