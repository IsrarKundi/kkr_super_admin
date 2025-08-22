import 'package:flutter/material.dart';

class RestaurantDetailView extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onBack;
  const RestaurantDetailView({Key? key, required this.restaurant, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example menu data with updated image paths
    final menuSections = [
      {
        'title': 'High-Tea',
        'items': [
          {'image': 'assets/img1.png', 'title': 'Super Delicious', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img2.png', 'title': 'Delicious Treat', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img3.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Deals',
        'items': [
          {'image': 'assets/img2.png', 'title': 'Super Delicious', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img3.png', 'title': 'Delicious Treat', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'Burger', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img1.png', 'title': 'Special Deal', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
      {
        'title': 'Offers',
        'items': [
          {'image': 'assets/img3.png', 'title': 'Offer 1', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img1.png', 'title': 'Offer 2', 'category': 'High Tea', 'price': 'Rs 1,999'},
          {'image': 'assets/img4.png', 'title': 'Special Offer', 'category': 'High Tea', 'price': 'Rs 1,999'},
        ],
      },
    ];

    final isWide = MediaQuery.of(context).size.width > 900;
    return Container(
      color: const Color(0xFF323b40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      restaurant['name'] ?? 'Restaurant',
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
              // Main content
              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant image
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD740),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/restaurant image.png',
                                    width: 560,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Info panel
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.only(top: 0),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoRow('Restaurant Name', restaurant['name'] ?? 'Cheezious'),
                                _InfoRow('Cuisine Type', restaurant['cuisine'] ?? 'Fast food'),
                                _InfoRow('Restaurant Address', restaurant['address'] ?? 'johar town Lahore'),
                                _InfoRow('Restaurant City', restaurant['city'] ?? 'Lahore'),
                                _InfoRow('Restaurant Phone Number', restaurant['phone'] ?? '090078601'),
                                _InfoRow('Description', restaurant['description'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'),
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
                              'assets/restaurant image.png',
                              width: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow('Restaurant Name', restaurant['name'] ?? 'Cheezious'),
                              _InfoRow('Cuisine Type', restaurant['cuisine'] ?? 'Fast food'),
                              _InfoRow('Restaurant Address', restaurant['address'] ?? 'johar town Lahore'),
                              _InfoRow('Restaurant City', restaurant['city'] ?? 'Lahore'),
                              _InfoRow('Restaurant Phone Number', restaurant['phone'] ?? '090078601'),
                              _InfoRow('Description', restaurant['description'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              // Menu sections
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
                        return Container(
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
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                child: Image.asset(
                                  item['image'],
                                  width: 180,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   item['title'],
                                    //   style: const TextStyle(
                                    //     color: Colors.black,
                                    //     fontWeight: FontWeight.w700,
                                    //     fontSize: 16,
                                    //   ),
                                    // ),
                                  //  const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        //   decoration: BoxDecoration(
                                        //     color: const Color(0xFF323b40),
                                        //     borderRadius: BorderRadius.circular(8),
                                        //   ),
                                        //   child: 
                                          Text(
                                            item['category'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                       // ),
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
                                    const SizedBox(height: 4),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFc89849),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
} 