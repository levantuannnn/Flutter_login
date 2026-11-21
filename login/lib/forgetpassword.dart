import 'package:flutter/material.dart';
import 'login.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // GlobalKey để quản lý và kiểm tra tính hợp lệ của ô nhập
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // NẾU HỢP LỆ: Gửi yêu cầu đặt lại mật khẩu về Email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Link đặt lại mật khẩu đã được gửi đến ${_emailController.text}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // NẾU CÓ LỖI: Hiện thông báo màu đỏ nhắc nhở
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Vui lòng nhập đúng định dạng Email!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Thanh tiêu đề có nút quay lại tự động ẩn nếu vào trang này đầu tiên
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null, // Tự động ẩn nút nếu không có trang nào trước đó để quay về
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        // Chống tràn màn hình khi bật bàn phím
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Icon ổ khóa minh họa trực quan
                const Center(
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 24),

                // Đoạn văn bản hướng dẫn người dùng
                const Text(
                  'Nhập email của bạn vào bên dưới. Chúng tôi sẽ gửi một liên kết để bạn đặt lại mật khẩu mới.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 32),

                // Ô nhập Email cần khôi phục
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email khôi phục',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // Đồng bộ bo góc 8
                    ),
                  ),
                  // Kiểm tra dữ liệu đầu vào
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Email không đúng định dạng';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Nút Gửi yêu cầu chiếm hết chiều ngang, bo góc 8
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Gửi liên kết',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Dòng chữ chuyển hướng về trang Đăng nhập bằng pushReplacement chống kẹt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Quay lại trang ', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        // Thay thế hoàn toàn trang hiện tại bằng trang Đăng nhập
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
