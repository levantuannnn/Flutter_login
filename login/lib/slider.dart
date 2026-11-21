import 'package:flutter/material.dart';

class AutoSlider extends StatefulWidget {
  const AutoSlider({super.key});

  @override
  State<AutoSlider> createState() => _AutoSliderState();
}

class _AutoSliderState extends State<AutoSlider>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;

  final List<String> images = [
    'https://images.pexels.com/photos/35617550/pexels-photo-35617550.jpeg',
    'https://images.pexels.com/photos/37968512/pexels-photo-37968512.jpeg',
    'https://images.pexels.com/photos/17335658/pexels-photo-17335658.jpeg',
    'https://images.pexels.com/photos/14991355/pexels-photo-14991355.jpeg',
    'https://images.pexels.com/photos/38198517/pexels-photo-38198517.jpeg',
    'https://images.pexels.com/photos/39551339/pexels-photo-39551339.jpeg',
    'https://images.pexels.com/photos/40358317/pexels-photo-40358317.jpeg'
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );

    // Chờ cho đến khi giao diện dựng xong hoàn toàn mới tính toán vị trí cuộn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _animationController.addListener(() {
        // Kiểm tra xem ScrollController đã gắn vào ListView và có độ dài cuộn chưa
        if (_scrollController.hasClients &&
            _scrollController.position.hasContentDimensions) {
          double maxScroll = _scrollController.position.maxScrollExtent;
          if (maxScroll > 0) {
            _scrollController.jumpTo(_animationController.value * maxScroll);
          }
        }
      });

      // Bắt đầu chạy lặp lại
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    final sliderHeight = (screenSize.height * 0.25).clamp(180.0, 300.0);
    final itemWidth = (screenWidth * 0.75).clamp(250.0, 600.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive 2D Scroll Web'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Bộ sưu tập nổi bật',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Dải ảnh cuộn ngang
              SizedBox(
                height: sliderHeight,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  // Đặt itemCount lớn để Flutter render trước khoảng cuộn rộng cho ScrollController
                  itemCount: images.length * 100,
                  itemBuilder: (context, index) {
                    final imageUrl = images[index % images.length];

                    return Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Nội dung bổ sung',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ...List.generate(
                6,
                (index) => Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Khối nội dung ${index + 1}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}