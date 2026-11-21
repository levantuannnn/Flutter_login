import 'package:flutter/material.dart';
import 'package:login/api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _productImages = [];
  String _title = '';
  String _description = '';
  double _price = 0;
  double _discountPercentage = 0;
  double _rating = 0;
  int _stock = 0;
  String _brand = '';
  String _category = '';
  bool _isLoading = true;
  String? _errorMessage;

  int _currentImageIndex = 0;
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final product = await layMotSanPham();
      print(product['title']);
      print(product['price']);
      if (!mounted) return;

      setState(() {
        _title = product['title']?.toString() ?? '';
        _description = product['description']?.toString() ?? '';
        _price = (product['price'] as num?)?.toDouble() ?? 0;
        _discountPercentage =
            (product['discountPercentage'] as num?)?.toDouble() ?? 0;
        _rating = (product['rating'] as num?)?.toDouble() ?? 0;
        _stock = (product['stock'] as num?)?.toInt() ?? 0;
        _brand = product['brand']?.toString() ?? '';
        _category = product['category']?.toString() ?? '';
        _productImages
          ..clear()
          ..addAll(
            ((product['images'] as List?) ?? const [])
                .map((image) => image.toString())
                .where((image) => image.isNotEmpty),
          );
        _currentImageIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Không thể tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    final value = price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
    return '$value đ';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadProduct,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // Yêu cầu 3: Dùng CustomScrollView + SliverAppBar để ảnh co lại thành thanh tiêu đề khi cuộn xuống
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340.0,
            pinned: true,
            backgroundColor: const Color(0xFF0D3B7A),
            foregroundColor: Colors.white,
            title: const Text(
              'Chi tiết sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            // Yêu cầu 2: Nút quay lại nổi trên ảnh, nền tròn trắng mờ
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            // Yêu cầu 2: Nút yêu thích nổi trên ảnh, nền tròn trắng mờ
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: _isFavorite ? Colors.red : Colors.black87,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
            // Yêu cầu 1: Ảnh sản phẩm vuốt ngang bằng PageView và dấu chấm chỉ vị trí dùng Stack
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: _productImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        _productImages[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: Color(0xFFECECEC)),
                      );
                    },
                  ),
                  // Hàng dấu chấm chỉ vị trí ảnh đang xem
                  Positioned(
                    bottom: 16.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          _productImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentImageIndex == index ? 16.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? const Color(0xFF1565C0)
                                  : Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Phần nội dung chi tiết sản phẩm bên dưới ảnh
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Đánh giá sao
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_rating.toStringAsFixed(1)} • còn $_stock sản phẩm',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Giá bán & Badge giảm giá
                  Row(
                    children: [
                      Text(
                        _formatPrice(_price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D3B7A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${_discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Yêu cầu 4: Phần mô tả dài có nút "Xem thêm" để mở rộng
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _description,
                    maxLines: _isDescriptionExpanded ? null : 3,
                    overflow: _isDescriptionExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: const Color(0xFF1565C0),
                      ),
                      onPressed: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      icon: Icon(
                        _isDescriptionExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      label: Text(
                        _isDescriptionExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  const Text(
                    'Thông số kỹ thuật nổi bật',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    ('Thương hiệu', _brand.isEmpty ? 'Đang cập nhật' : _brand),
                    (
                      'Danh mục',
                      _category.isEmpty ? 'Đang cập nhật' : _category,
                    ),
                    ('Tồn kho', '$_stock sản phẩm'),
                    ('Giảm giá', '${_discountPercentage.toStringAsFixed(1)}%'),
                    ('Đánh giá', '${_rating.toStringAsFixed(1)} / 5'),
                  ].map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.$1,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Text(
                            item.$2,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Yêu cầu 5: Thanh hành động cố định ở đáy, bọc SafeArea để không bị thanh cử chỉ che
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF1565C0)),
                      foregroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                      );
                    },
                    child: const Text(
                      'Thêm vào giỏ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chuyển sang thanh toán...'),
                        ),
                      );
                    },
                    child: const Text(
                      'Mua ngay',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
