import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../UI/restaurantDetaiL.dart';
import '../modele/utilisateur.dart';
import '../UI/404.dart';
import '../UI/Accueil.dart';
import '../UI/testImage.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
        onPressed: () {
          User.saveUser(User(userName: "admin", isAdmin: true));
          context.go(context.namedLocation('home'));
        },
        child: const Text("Login as 'admin'"),
        ),
      )
    );
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;
  ScaffoldWithNavBar({required this.child,super.key,});

  @override
  State<ScaffoldWithNavBar> createState() =>
      ScaffoldWithNavBarState();
}

class ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>{
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.child,
        bottomNavigationBar:
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Accueil'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favoris'),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Parametres'),
              BottomNavigationBarItem(icon: Icon(Icons.logout),label: 'Deconnexion')
            ],
            currentIndex: _selectedIndex,
            onTap: (int idx) => _onItemTapped(idx, context),
      )
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    _selectedIndex = index;
    switch (index) {
      case 0:
        GoRouter.of(context).go(context.namedLocation('home'));
      case 1:
        GoRouter.of(context).go(context.namedLocation('favorites'));
      case 2:
        GoRouter.of(context).go(context.namedLocation('settings'));
      case 3:
        User.clearUser();
        GoRouter.of(context).go(context.namedLocation('login'));
    }
  }
}

final router = GoRouter(
  initialLocation: '/',
  onException: (_, GoRouterState state, GoRouter router) {router.go('/404', extra: state.uri.toString()); },
  redirect: (BuildContext context, GoRouterState state) async{
    if (! await User.isAuthentificated()) {
      return '/login';
    } else {
      return null;
    }
  },
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            name: "home",
            builder: (context, state) => Accueil(),
          ),
          GoRoute(
            path: '/detail/:id',
            name: "detail",
            builder: (context, state) => RestaurantDetailPage(idRestaurant: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/favorites',
            name: "favorites",
            // builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/11627058270"),
            builder: (context, state) =>Accueil(),
          ),
          GoRoute(
            path: '/settings',
            name: "settings",
            builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/1494206007"),
          )
        ]),
    GoRoute(
      path: '/login',
      name: "login",
      builder: (context, state) => Test(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: Test(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/signin',
      name: "signin",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: Test(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/404/:errorMessage',
      name: "404message",
      builder: (context, state) => Page404(errorMessage:state.pathParameters['errorMessage']),
    ),
    GoRoute(
      path: '/404',
      name: "404",
      builder: (context, state) => Page404(),
    )
  ],
);
