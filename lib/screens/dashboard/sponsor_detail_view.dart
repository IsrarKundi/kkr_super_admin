import 'package:flutter/material.dart';
import 'deal_detail_screen.dart';

class SponsorDetailView extends StatefulWidget {
  final Map<String, dynamic> sponsor;
  final VoidCallback onBack;
  const SponsorDetailView({Key? key, required this.sponsor, required this.onBack}) : super(key: key);

  @override
  State<SponsorDetailView> createState() => _SponsorDetailViewState();
}

class _SponsorDetailViewState extends State<SponsorDetailView> {
  bool _showingDealDetail = false;
  Map<String, dynamic>? _selectedDeal;

  void _showDealDetail(Map<String, dynamic> deal) {
    setState(() {
      _selectedDeal = deal;
      _showingDealDetail = true;
    });
  }

  void _hideDealDetail() {
    setState(() {
      _showingDealDetail = false;
      _selectedDeal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show deal detail if active
    if (_showingDealDetail && _selectedDeal != null) {
      return DealDetailScreen(
        deal: _selectedDeal!,
        onBack: _hideDealDetail,
      );
    }

    // Menu data with the same images from restaurant detail view
    final menuSections = [
      {
        'title': 'High-Tea',
        'items': [
          {'image': 'assets/img1.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img2.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img3.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Deals',
        'items': [
          {'image': 'assets/img1.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img2.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img3.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Offers',
        'items': [
          {'image': 'assets/img1.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img2.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img3.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'High Tea', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
    ];

    return Container(
      color: const Color(0xFF323b40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button and notification
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: widget.onBack,
                  ),
                  Expanded(
                    child: Text(
                      widget.sponsor['name'] ?? 'Sponsor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
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
              const SizedBox(height: 8),
              Container(
                height: 3,
                color: Colors.white.withOpacity(0.4),
                margin: const EdgeInsets.only(right: 0),
              ),
              const SizedBox(height: 24),
              
              // Menu sections (High-Tea, Deals, Offers)
              ...menuSections.map((section) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${section['title']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate((section['items'] as List?)?.length ?? 0, (i) {
                        final items = section['items'] as List;
                        final item = items[i];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to deal detail screen
                            _showDealDetail(item);
                          },
                          child: Container(
                            width: 180,
                            margin: EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                                  child: Image.asset(
                                    item['image'],
                                    width: 180,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['category'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            item['price'],
                                            style: const TextStyle(
                                              color: Color(0xFFc89849),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                     // const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
} 