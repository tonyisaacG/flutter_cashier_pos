import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/global_menu_overlay.dart';
import '../../core/widgets/header_menu_button.dart';
import '../../core/database/database_helper.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _isReady = false;
  bool _showGlobalMenu = false;
  int _currentIndex = 0;

  final Map<String, int> _routeToIndex = {
    '/': 0,
    '/products': 1,
    '/sales': 2,
    '/purchases': 3,
    '/reports': 4,
  };

  final Map<int, String> _indexToRoute = {
    0: '/',
    1: '/products',
    2: '/sales',
    3: '/purchases',
    4: '/reports',
  };

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _currentIndex = _routeToIndex[widget.currentRoute] ?? 0;
  }

  @override
  void didUpdateWidget(AppLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      setState(() {
        _currentIndex = _routeToIndex[widget.currentRoute] ?? 0;
      });
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize database
      await DatabaseHelper.instance.database;
      setState(() {
        _isReady = true;
      });

      // Hide status bar (immersive mode)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      debugPrint('Error initializing app: $e');
    }
  }

  void _onBottomNavTap(int index) {
    final route = _indexToRoute[index];
    if (route != null && route != widget.currentRoute) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  void _toggleGlobalMenu() {
    setState(() {
      _showGlobalMenu = !_showGlobalMenu;
    });
  }

  void _closeGlobalMenu() {
    setState(() {
      _showGlobalMenu = false;
    });
  }

  void _navigateToRoute(String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'جار التحميل...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // App bar with dynamic header
              _buildAppBar(),
              // Main content area
              Expanded(
                child: widget.child,
              ),
            ],
          ),
          // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onBottomNavTap,
            ),
          ),
          // Global menu overlay
          GlobalMenuOverlay(
            isVisible: _showGlobalMenu,
            onClose: _closeGlobalMenu,
            currentRoute: widget.currentRoute,
            onNavigate: _navigateToRoute,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    String title;
    List<Widget> actions = [];

    // Configure app bar based on current route
    switch (widget.currentRoute) {
      case '/':
        title = 'الرئيسية';
        break;
      case '/products':
        title = 'المنتجات';
        break;
      case '/sales':
        title = 'المبيعات';
        actions.add(HeaderMenuButton(onPressed: _toggleGlobalMenu));
        break;
      case '/purchases':
        title = 'المشتريات';
        actions.add(HeaderMenuButton(onPressed: _toggleGlobalMenu));
        break;
      case '/inventory':
        title = 'المخزون';
        break;
      case '/reports':
        title = 'التقارير';
        break;
      case '/purchase-list':
        title = 'قائمة فواتير الشراء';
        break;
      case '/purchase-return-list':
        title = 'قائمة فواتير المرتجعات';
        break;
      case '/purchase-detail':
        title = 'تفاصيل فاتورة الشراء';
        break;
      case '/sale-list':
        title = 'قائمة فواتير المبيعات';
        break;
      case '/sale-return-list':
        title = 'قائمة مرتجعات المبيعات';
        break;
      case '/sale-detail':
        title = 'تفاصيل فاتورة المبيعات';
        break;
      default:
        title = 'نقطة البيع';
    }

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: actions,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
