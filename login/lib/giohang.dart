import 'package:flutter/material.dart';

// Model dữ liệu sản phẩm trong giỏ hàng
class CartItem {
  final String id;
  final String name;
  final int price; // Lưu số nguyên (VNĐ) để tính toán chính xác
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Danh sách sản phẩm mẫu ban đầu trong giỏ
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _cartItems = [
      CartItem(
        id: 'sp1',
        name: 'Điện thoại Flagship Pro Max 256GB - Chính hãng VN/A',
        price: 21990000,
        imageUrl: 'https://picsum.photos/id/1/200/200',
        quantity: 1,
      ),
      CartItem(
        id: 'sp2',
        name: 'Tai nghe chống ồn chủ động Bluetooth Không Dây',
        price: 350000,
        imageUrl: 'https://picsum.photos/id/5/200/200',
        quantity: 1,
      ),
      CartItem(
        id: 'sp3',
        name: 'Cáp sạc nhanh Type-C bọc dù siêu bền 2m',
        price: 120000,
        imageUrl: 'https://picsum.photos/id/6/200/200',
        quantity: 1,
      ),
    ];
  }

  // Hàm định dạng tiền tệ VNĐ (VD: 21990000 -> 21.990.000 đ)
  String _formatCurrency(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} đ';
  }

  // Tính tổng số lượng sản phẩm hiển thị trên AppBar
  int get _totalItemsCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tính tạm tính
  int get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Yêu cầu 4: Đơn từ 500.000 đ thì miễn phí vận chuyển (dưới 500k phí 30.000 đ)
  int get _shippingFee {
    if (_subtotal == 0 || _subtotal >= 500000) return 0;
    return 30000;
  }

  // Tổng cộng thanh toán
  int get _totalAmount => _subtotal + _shippingFee;

  // Hàm xóa sản phẩm kèm SnackBar hoàn tác
  void _removeItemWithUndo(int index) {
    final removedItem = _cartItems[index];

    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${removedItem.name}"'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Hoàn tác',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              // Khôi phục lại món hàng (nếu bị giảm về 0 thì đặt lại số lượng = 1)
              if (removedItem.quantity <= 0) {
                removedItem.quantity = 1;
              }
              _cartItems.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B7A),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Giỏ hàng ($_totalItemsCount)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // Yêu cầu 5: Giỏ rỗng thì hiện màn hình trống có nút "Tiếp tục mua sắm"
      body: _cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Giỏ hàng của bạn đang trống',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy chọn thêm sản phẩm để tiếp tục mua sắm nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _loadSampleData(); // Tải lại danh sách mẫu để tiếp tục test
                        });
                      },
                      child: const Text(
                        'Tiếp tục mua sắm',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Yêu cầu 1, 2, 3: Danh sách sản phẩm dùng ListView.builder & Dismissible
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: _cartItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];

                      // Vuốt sang trái để xóa nhanh, kèm nền đỏ và icon thùng rác
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _removeItemWithUndo(index);
                        },
                        background: Container(
                          color: Colors.red.shade600,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24.0),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Ảnh nhỏ sản phẩm
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Cột thông tin: Tên sản phẩm 2 dòng, đơn giá & bộ chọn số lượng
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        // Đơn giá
                                        Text(
                                          _formatCurrency(item.price),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0D3B7A),
                                          ),
                                        ),
                                        const Spacer(),

                                        // Bộ chọn số lượng tăng/giảm
                                        Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                                icon: const Icon(Icons.remove,
                                                    size: 16),
                                                onPressed: () {
                                                  if (item.quantity > 1) {
                                                    setState(() {
                                                      item.quantity--;
                                                    });
                                                  } else {
                                                    // Về 0 thì xóa sản phẩm khỏi giỏ (kèm hoàn tác)
                                                    item.quantity = 0;
                                                    _removeItemWithUndo(index);
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                                icon: const Icon(Icons.add,
                                                    size: 16),
                                                onPressed: () {
                                                  setState(() {
                                                    item.quantity++;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Yêu cầu 4: Bảng tính tiền tự cập nhật & nút Thanh toán dưới đáy
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Khung chi tiết hóa đơn bo góc
                        Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Tạm tính',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatCurrency(_subtotal),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Phí vận chuyển',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _shippingFee == 0
                                        ? 'Miễn phí'
                                        : _formatCurrency(_shippingFee),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _shippingFee == 0
                                          ? Colors.green.shade700
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                children: [
                                  const Text(
                                    'Tổng cộng',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatCurrency(_totalAmount),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0D3B7A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Nút Thanh toán
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Thanh toán đơn hàng ${_formatCurrency(_totalAmount)} thành công!'),
                                ),
                              );
                            },
                            child: const Text(
                              'Thanh toán',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}