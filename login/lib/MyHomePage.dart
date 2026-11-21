import 'package:flutter/material.dart';

// 1. Model dữ liệu sản phẩm mẫu
class Product {
  final String name;
  final String category;
  final String price;
  final String imageUrl;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Danh sách sản phẩm mẫu
  final List<Product> _allProducts = [
    Product(
      name: 'iPhone 15 Pro Max',
      category: 'Điện thoại',
      price: '29.990k',
      imageUrl: 'https://picsum.photos/id/1/300/300',
    ),
    Product(
      name: 'MacBook Air M2',
      category: 'Laptop',
      price: '24.500k',
      imageUrl: 'https://picsum.photos/id/2/300/300',
    ),
    Product(
      name: 'Samsung Galaxy S24',
      category: 'Điện thoại',
      price: '21.990k',
      imageUrl: 'https://picsum.photos/id/3/300/300',
    ),
    Product(
      name: 'Dell XPS 13',
      category: 'Laptop',
      price: '28.000k',
      imageUrl: 'https://picsum.photos/id/4/300/300',
    ),
    Product(
      name: 'Tai nghe Sony WH-1000XM5',
      category: 'Phụ kiện',
      price: '6.490k',
      imageUrl: 'https://picsum.photos/id/5/300/300',
    ),
    Product(
      name: 'Chuột Logitech MX Master 3S',
      category: 'Phụ kiện',
      price: '2.190k',
      imageUrl: 'https://picsum.photos/id/6/300/300',
    ),
  ];

  // Các biến quản lý trạng thái
  final List<String> _categories = ['Tất cả', 'Điện thoại', 'Laptop', 'Phụ kiện'];
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  int _cartCount = 2; // Số lượng trên Badge giỏ hàng
  int _selectedNavIndex = 0; // Tab hiện tại của NavigationBar

  // Hàm lọc sản phẩm đồng thời theo Danh mục & Từ khóa tìm kiếm
  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' || product.category == _selectedCategory;
      final matchesSearch =
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredProducts;

    return Scaffold(
      // Yêu cầu 1: Thanh tiêu đề có nút tìm kiếm và giỏ hàng kèm Badge số lượng
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B7A), // Màu xanh đậm giống mẫu
        foregroundColor: Colors.white,
        title: const Text(
          'ShopEasy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Có thể xử lý focus vào ô tìm kiếm tại đây
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Badge(
                label: Text('$_cartCount'),
                isLabelVisible: _cartCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // Yêu cầu 2: Ô tìm kiếm bo tròn, gõ tới đâu lọc danh sách tới đó
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Yêu cầu 3: Hàng chip danh mục cuộn ngang, chip đang chọn đổi màu nền
          SizedBox(
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1565C0),
                      backgroundColor: Colors.grey.shade100,
                      showCheckmark: false,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Yêu cầu 4: Lưới sản phẩm 2 cột dùng GridView.builder, tái dùng ProductCard
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Không tìm thấy sản phẩm nào'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cột
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      // Tỷ lệ chiều rộng/cao giúp thẻ không bị tràn khi xoay ngang màn hình
                      childAspectRatio: 0.72,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filteredList[index],
                        onAddToCart: () {
                          setState(() {
                            _cartCount++;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Yêu cầu 5: Thanh điều hướng dưới với 3 mục
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET ProductCard (Tái sử dụng từ bài GD 5)
// Nếu trong dự án của bạn đã có sẵn file product_card.dart thì bạn có thể
// import file đó vào và xóa class ProductCard bên dưới đi.
// =========================================================================
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm chiếm phần lớn diện tích thẻ (Expanded chống tràn layout)
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Thông tin tên & giá
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: onAddToCart,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}