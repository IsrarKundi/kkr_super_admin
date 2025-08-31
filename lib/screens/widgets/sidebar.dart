import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/utils/colors.dart';
import '../../controller/getx_controllers/auth_controller.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isWide;
  final int? selectedSubTab;
  final ValueChanged<int>? onSubTabSelect;
  
  const Sidebar({
    Key? key, 
    required this.selectedIndex, 
    required this.onSelect, 
    this.isWide = true,
    this.selectedSubTab,
    this.onSubTabSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navItems = [
      'Dashboard',
      'User Management',
      'Store',
      'Kitchen',
      'Menu',
      'Sales',
      'Finance',
      'Employee',
      'Settings'
    ];
    
    // final promotionSubTabs = [
    //   'Banner ad',
    //   'Pop up ad', 
    //   'Sponsor',
    // ];
    
    return Container(
      width: isWide ? 260 : 64,
      color: blackColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isWide ? 0 : 16),
          // Logo
          SizedBox(
            width: isWide ? 150 : 40,
            child: Image.asset('assets/pngs/kkr_logo.png'),
          ),
       //   SizedBox(height: isWide ? 0 : 16),
          // User avatar and name
          SizedBox(
            height:  14,
            // width: 64,
            
          ),
         Divider(
            color: Colors.white.withOpacity(0.20),
            height: 1,
            thickness: 2,
          ),
          SizedBox(height: 20,),
          // if (isWide) ...[
          //   const SizedBox(height: 12),
          //   const Text(
          //     'Mohsin Zulfiqar',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.w700,
          //       fontSize: 20,
          //     ),
          //   ),
          //   const SizedBox(height: 32),
          // ],
          // Navigation
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: navItems.length,
                itemBuilder: (context, i) {
                  final selected = i == selectedIndex;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => onSelect(i),
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // AnimatedContainer(
                              //   duration: const Duration(milliseconds: 200),
                              //   width: 4,
                              //   height: 44,
                              //   margin: EdgeInsets.only(left: isWide ? 24 : 8, right: 12),
                              //   decoration: BoxDecoration(
                              //     color: selected ? const Color(0xFFc89849) : Colors.transparent,
                              //     borderRadius: BorderRadius.circular(4),
                              //   ),
                              // ),
                              if (isWide)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                                  child: selected
                                      ? Container(
                                        width: 210,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [goldenColor2, goldenColor1],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            navItems[i],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Text(
                                          navItems[i],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              if (!isWide)
                                Icon(
                                  _sidebarIcon(i),
                                  color: selected ? const Color(0xFFc89849) : Colors.white,
                                  size: 28,
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Show sub-tabs for promotion when selected and wide
                      
                    ],
                  );
                },
              ),
            ),
          ),
          // Logout
          Container(margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10), height: 2,color: Colors.white.withOpacity(0.50),),
          Padding(
            padding: EdgeInsets.only(bottom: isWide ? 32.0 : 12.0),
            child: _LogoutButton(isWide: isWide),
          ),
        ],
      ),
    );
  
  }

  IconData _sidebarIcon(int i) {
    switch (i) {
      case 0:
        return Icons.dashboard_outlined;
      case 1:
        return Icons.people_outline;
      case 2:
        return Icons.storefront_outlined;
      case 3:
        return Icons.local_offer_outlined;
      case 4:
        return Icons.computer_outlined;
      case 5:
        return Icons.description_outlined;
      case 6:
        return Icons.privacy_tip_outlined;
      default:
        return Icons.circle;
    }
  }
}

class _LogoutButton extends StatefulWidget {
  final bool isWide;
  
  const _LogoutButton({Key? key, required this.isWide}) : super(key: key);

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _isHovered = false;
  final AuthController _authController = Get.find<AuthController>();

  void _handleLogout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _authController.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleLogout,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout, 
                color: _isHovered ? const Color(0xFFc89849) : Colors.white, 
                size: widget.isWide ? 28 : 22
              ),
              if (widget.isWide) ...[
                const SizedBox(width: 12),
                Text(
                  'Log out',
                  style: TextStyle(
                    color: _isHovered ? const Color(0xFFc89849) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 