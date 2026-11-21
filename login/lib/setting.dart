import 'package:flutter/material.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- STATE LƯU TRỮ CHO NHÓM 1 (SWITCHES) ---
  bool _notiEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = true;

  // --- STATE LƯU TRỮ CHO NHÓM 2 (LISTTILES) ---
  String _selectedLanguage = 'Tiếng Việt';
  String _selectedThemeColor = 'Xanh dương';

  // --- HÀM XỬ LÝ GẠT CÔNG TẮC CÓ HỘP THOẠI XÁC NHẬN ---
  // Trạng thái thay đổi NGAY LẬP TỨC. Nếu chọn HỦY -> hoàn tác lại trạng thái cũ.
  void _handleSwitchChange({
    required String title,
    required bool currentValue,
    required Function(bool) updateState,
  }) async {
    // 1. Thay đổi trạng thái ngay lập tức trên UI
    setState(() {
      updateState(!currentValue);
    });

    // 2. Hiển thị hộp thoại xác nhận hành động
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Bắt buộc chọn Xác nhận hoặc Hủy
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thay đổi'),
        content: Text('Bạn có chắc chắn muốn thay đổi trạng thái cài đặt "$title" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Trả về false khi chọn Hủy
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Trả về true khi chọn Xác nhận
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    // 3. Nếu người dùng chọn Hủy hoặc tắt hộp thoại -> Hoàn tác lại giá trị cũ
    if (confirm != true) {
      setState(() {
        updateState(currentValue);
      });
    }
  }

  // --- HÀM HIỂN THỊ BOTTOM SHEET CHỌN GIÁ TRỊ CHO NHÓM 2 ---
  void _showSelectionBottomSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 1),
              ...options.map((option) => ListTile(
                    title: Text(option),
                    trailing: option == currentValue
                        ? const Icon(Icons.check, color: Colors.blueAccent)
                        : null,
                    onTap: () {
                      setState(() {
                        onSelected(option);
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  // --- HÀM HIỂN THỊ HỘP THOẠI XÁC NHẬN ĐĂNG XUẤT ---
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất khỏi ứng dụng?'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất tài khoản hiện tại không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Thực hiện xử lý logic xóa token / chuyển trang tại đây
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- BUILD TỪNG NHÓM TIÊU ĐỀ IN HOA ---
  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(), // In hoa tiêu đề
        style: const TextStyle(
          color: Colors.grey, // Màu xám
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám nhạt hiện đại
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= NHÓM 1 =================
            _buildGroupTitle('Cấu hình thông báo & Hệ thống'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Nhận thông báo ứng dụng'),
                    value: _notiEnabled,
                    onChanged: (value) => _handleSwitchChange(
                      title: 'Nhận thông báo',
                      currentValue: _notiEnabled,
                      updateState: (newValue) => _notiEnabled = newValue,
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16), // Đường kẻ mảnh
                  SwitchListTile(
                    title: const Text('Chế độ tối (Dark Mode)'),
                    value: _darkModeEnabled,
                    onChanged: (value) => _handleSwitchChange(
                      title: 'Chế độ tối',
                      currentValue: _darkModeEnabled,
                      updateState: (newValue) => _darkModeEnabled = newValue,
                    
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16), // Đường kẻ mảnh
                  SwitchListTile(
                    title: const Text('Đăng nhập bằng vân tay / Khuôn mặt'),
                    value: _biometricEnabled,
                    onChanged: (value) => _handleSwitchChange(
                      title: 'Sinh trắc học',
                      currentValue: _biometricEnabled,
                      updateState: (newValue) => _biometricEnabled = newValue,
                    ),
                  ),
                  // MỤC CUỐI CÙNG KHÔNG CÓ ĐƯỜNG KẺ
                ],
              ),
            ),

            // ================= NHÓM 2 =================
            _buildGroupTitle('Giao diện & Ngôn ngữ'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Ngôn ngữ'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_selectedLanguage, style: const TextStyle(color: Colors.grey)),
                        const Icon(Icons.chevron_right, color: Colors.grey), // Mũi tên
                      ],
                    ),
                    onTap: () => _showSelectionBottomSheet(
                      title: 'Chọn ngôn ngữ',
                      options: ['Tiếng Việt', 'English', '日本語', '한국어'],
                      currentValue: _selectedLanguage,
                      onSelected: (val) => _selectedLanguage = val,
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16), // Đường kẻ mảnh
                  ListTile(
                    title: const Text('Màu sắc chủ đạo'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_selectedThemeColor, style: const TextStyle(color: Colors.grey)),
                        const Icon(Icons.chevron_right, color: Colors.grey), // Mũi tên
                      ],
                    ),
                    onTap: () => _showSelectionBottomSheet(
                      title: 'Chọn màu chủ đạo',
                      options: ['Xanh dương', 'Đỏ hồng', 'Xanh lá', 'Cam'],
                      currentValue: _selectedThemeColor,
                      onSelected: (val) => _selectedThemeColor = val,
                    ),
                  ),
                  // MỤC CUỐI CÙNG KHÔNG CÓ ĐƯỜNG KẺ
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ================= NÚT ĐĂNG XUẤT VIỀN ĐỎ O CUỐI =================
            Padding
            (
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox
              (
                height: 48,
                child: OutlinedButton.icon
                (
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom
                  (
                  side: const BorderSide(color: Colors.redAccent, width: 1.2), // Viền đỏ
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}