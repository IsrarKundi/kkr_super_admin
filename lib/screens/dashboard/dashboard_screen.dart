import 'package:flutter/material.dart';
import 'package:khaabd_web/screens/employee_and_assets/employee_assets_managemennt_screen.dart';
import 'package:khaabd_web/screens/kitchen/kitchen_screen.dart';
import 'package:khaabd_web/screens/sales/sales_management.dart';
import 'package:khaabd_web/utils/colors.dart';
import '../widgets/sidebar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/earning_chart.dart';
import '../widgets/top_user_list.dart';
import '../widgets/new_restaurant_table.dart';
import '../user_management/users_management_screen.dart';
import '../store/store_screen.dart';
import '../menu/menu_screen.dart';
import '../finance/finance_management_screen.dart';
import 'restaurant_detail_view.dart';
import 'promotion_detail_view.dart';
import 'sponsor_detail_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _selectedSubTab = 0;
  
  // Detail view state
  bool _showingRestaurantDetail = false;
  bool _showingPromotionDetail = false;
  bool _showingSponsorDetail = false;
  Map<String, dynamic>? _selectedRestaurantData;
  Map<String, String>? _selectedPromotionData;
  Map<String, dynamic>? _selectedSponsorData;

  static const String _termsText = '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''';
  static const String _privacyText = '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''';

  void _onNavSelect(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedSubTab = 0; // Reset sub-tab when changing main tab
      // Reset detail views when changing tabs
      _showingRestaurantDetail = false;
      _showingPromotionDetail = false;
      _showingSponsorDetail = false;
    });
  }

  void _onSubTabSelect(int subTabIndex) {
    setState(() {
      _selectedSubTab = subTabIndex;
    });
  }

  void _showRestaurantDetail(Map<String, dynamic> restaurantData) {
    setState(() {
      _selectedRestaurantData = restaurantData;
      _showingRestaurantDetail = true;
    });
  }

  void _showPromotionDetail(Map<String, String> promotionData) {
    setState(() {
      _selectedPromotionData = promotionData;
      _showingPromotionDetail = true;
    });
  }

  void _showSponsorDetail(Map<String, dynamic> sponsorData) {
    setState(() {
      _selectedSponsorData = sponsorData;
      _showingSponsorDetail = true;
    });
  }

  void _hideRestaurantDetail() {
    setState(() {
      _showingRestaurantDetail = false;
      _selectedRestaurantData = null;
    });
  }

  void _hidePromotionDetail() {
    setState(() {
      _showingPromotionDetail = false;
      _selectedPromotionData = null;
    });
  }

  void _hideSponsorDetail() {
    setState(() {
      _showingSponsorDetail = false;
      _selectedSponsorData = null;
    });
  }

  Widget _getCurrentContent(bool isWide) {
    // Show restaurant detail if active
    if (_showingRestaurantDetail && _selectedRestaurantData != null) {
      return RestaurantDetailView(
        restaurant: _selectedRestaurantData!,
        onBack: _hideRestaurantDetail,
      );
    }
    
    // Show promotion detail if active
    if (_showingPromotionDetail && _selectedPromotionData != null) {
      return PromotionDetailView(
        promotion: _selectedPromotionData!,
        onBack: _hidePromotionDetail,
      );
    }

    // Show sponsor detail if active
    if (_showingSponsorDetail && _selectedSponsorData != null) {
      return SponsorDetailView(
        sponsor: _selectedSponsorData!,
        onBack: _hideSponsorDetail,
      );
    }

    // Show normal content based on selected index
    switch (_selectedIndex) {
      case 0:
        return _DashboardMainContent(isWide: isWide);
      case 1:
        return const UserManagementScreen();
      case 2:
        return StoreScreen(onShowDetail: _showRestaurantDetail);
      case 3:
        return KitchenScreen();
      case 4:
        return const MenuScreen();
      case 5:
        return SalesManagementScreen();
      case 6:
        return FinanceManagementScreen();
        case 7:
        return EmployeeAssetsManagementScreen();
      default:
        return _DashboardMainContent(isWide: isWide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1100;
          return Row(
            children: [
              Sidebar(
                selectedIndex: _selectedIndex,
                onSelect: _onNavSelect,
                isWide: isWide,
                selectedSubTab: _selectedIndex == 3 ? _selectedSubTab : null,
                onSubTabSelect: _selectedIndex == 3 ? _onSubTabSelect : null,
              ),
              Container(
                width: 3,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0.4),
                margin: const EdgeInsets.only(right: 0),
              ),
              Expanded(
                child: _getCurrentContent(isWide),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardMainContent extends StatelessWidget {
  final bool isWide;
  const _DashboardMainContent({Key? key, required this.isWide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: greyScaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 0 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            const SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatCard2(
                    icon: "assets/svgs/total_revenue.svg",
                    iconBgColor: greenColor.withOpacity(0.2),
                    title: 'Total Revenue',
                    value: 'RS 75042',
                    // date: 'May 2022',
                    trend: '+',
                    trendColor: const Color(0xFFc89849),
                    trendText: '+55% last month',
                    cardBgColor: Colors.white,
                  ),
                   StatCard2(
                    icon: "assets/svgs/gross_profit.svg",
                    iconBgColor: greenColor.withOpacity(0.2),
                    title: 'Gross Profit',
                    value: 'RS 75042',
                    // date: 'May 2022',
                    trend: '+',
                    trendColor: const Color(0xFFc89849),
                    trendText: '+55% last month',
                    cardBgColor: Colors.white,
                  ),
                   StatCard2(
                    icon: "assets/svgs/net_profit.svg",
                    iconBgColor: greenColor.withOpacity(0.2),
                    title: 'Net Profit',
                    value: 'RS 75042',
                    // date: 'May 2022',
                    trend: '+',
                    trendColor: const Color(0xFFc89849),
                    trendText: '+55% last month',
                    cardBgColor: Colors.white,
                  ),
                  
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  StatCard(
                      icon: "assets/svgs/inventory_value.svg",
                      iconBgColor: Colors.deepPurpleAccent,
                      title: 'Inventory Value',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    StatCard(
                      icon: "assets/svgs/active_employee.svg",
                      iconBgColor: Colors.blue,
                      title: 'Active Employees',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    StatCard(
                      icon: "assets/svgs/asset_value.svg",
                      iconBgColor: goldenColor1,
                      title: 'Asset Value',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    
                ],
              ),
            ),
           SizedBox(height: 24),
           Padding(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  StatCard(
                      icon: "assets/svgs/kitchen_expense.svg",
                      iconBgColor: goldenColor1,
                      title: 'Kitchen Expense',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    StatCard(
                      icon: "assets/svgs/purchase_inventory.svg",
                      iconBgColor: Colors.red,
                      title: 'Purchase Inventory',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    StatCard(
                      icon: "assets/svgs/salaries_paid.svg",
                      iconBgColor: Colors.blue,
                      title: 'Salaries Paid',
                      value: '2540',
                      date: 'May 2022',
                      trend: '-',
                      trendColor: Colors.red,
                      trendText: '+12% last month',
                      cardBgColor: Colors.white,
                    ),
                    
                ],
              ),
            ),
           
           
            RecentSalesTable(),
          ],
        ),
      ),
    );
  }
}

