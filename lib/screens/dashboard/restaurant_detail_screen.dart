import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  const RestaurantDetailScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example menu data
    final menuSections = [
      {
        'title': 'High-Tea',
        'items': [
          {'image': 'assets/hightea1.png', 'title': 'Super Delicious', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/hightea2.png', 'title': 'Delicious Treat', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/hightea3.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/hightea4.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Deals',
        'items': [
          {'image': 'assets/deal1.png', 'title': 'Super Delicious', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/deal2.png', 'title': 'Delicious Treat', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/deal3.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Offers',
        'items': [
          {'image': 'assets/offer1.png', 'title': 'Offer 1', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/offer2.png', 'title': 'Offer 2', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
    ];

    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xFF323b40),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant['name'] ?? 'Restaurant',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 320,
                    //   height: 40,
                    //   margin: const EdgeInsets.only(right: 24),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       hintText: 'Cheezious',
                    //       hintStyle: const TextStyle(color: Colors.black54),
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //         borderSide: BorderSide.none,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                 
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
                // Main content
                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant image
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 360,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD740),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      restaurant['logo'] ?? 'assets/logo.png',
                                      width: 330,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          // Info panel
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow('Restaurant Name', restaurant['name'] ?? 'Cheezious'),
                                  _InfoRow('Cuisine Type', restaurant['cuisine'] ?? 'Fast food'),
                                  _InfoRow('Restaurant Address', restaurant['address'] ?? 'johar town Lahore'),
                                  _InfoRow('Restaurant City', restaurant['city'] ?? 'Lahore'),
                                  _InfoRow('Restaurant Phone Number', restaurant['phone'] ?? '090078601'),
                                  _InfoRow('Description', restaurant['description'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD740),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Image.asset(
                                restaurant['logo'] ?? 'assets/logo.png',
                                width: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _InfoRow('Restaurant Name', restaurant['name'] ?? 'Cheezious'),
                          _InfoRow('Cuisine Type', restaurant['cuisine'] ?? 'Fast food'),
                          _InfoRow('Restaurant Address', restaurant['address'] ?? 'johar town Lahore'),
                          _InfoRow('Restaurant City', restaurant['city'] ?? 'Lahore'),
                          _InfoRow('Restaurant Phone Number', restaurant['phone'] ?? '090078601'),
                          _InfoRow('Description', restaurant['description'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                        ],
                      ),
                const SizedBox(height: 32),
                // Menu sections
                ...menuSections.map((section) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     "${ section['title']}",
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
                          return Container(
                            width: 180,
                            margin: const EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    item['image'],
                                    width: 180,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF323b40),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item['category'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
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
                                    ],
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFc89849),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 