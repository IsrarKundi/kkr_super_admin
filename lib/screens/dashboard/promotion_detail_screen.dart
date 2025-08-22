import 'package:flutter/material.dart';

class PromotionDetailScreen extends StatefulWidget {
  final Map<String, String> promotion;
  const PromotionDetailScreen({Key? key, required this.promotion}) : super(key: key);

  @override
  State<PromotionDetailScreen> createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {
  bool showRejectionModal = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xFF323b40),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(left: 8, right: 24),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: widget.promotion['name'] ?? '',
                                hintStyle: const TextStyle(color: Colors.black54),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFc89849)),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          child: Row(
                            children: const [
                              Icon(Icons.notifications, color: Color(0xFFc89849)),
                              SizedBox(width: 8),
                              Text('Notification', style: TextStyle(color: Color(0xFFc89849), fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Promotion image
                    Center(
                      child: Container(
                        width: isWide ? 600 : double.infinity,
                        height: isWide ? 260 : 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA726),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/promo_banner.png',
                            fit: BoxFit.contain,
                            width: isWide ? 400 : 260,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Status buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showRejectionModal = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Rejected',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFc89849),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Approved',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Rejection Modal
            if (showRejectionModal)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => showRejectionModal = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            if (showRejectionModal)
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rejection Reason',
                              style: TextStyle(
                                color: Color(0xFFc89849),
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red, size: 28),
                              onPressed: () => setState(() => showRejectionModal = false),
                              splashRadius: 24,
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('Add Comment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFc89849)),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Handle send
                            setState(() => showRejectionModal = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFc89849),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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