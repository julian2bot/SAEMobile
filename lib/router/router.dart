import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:sae_mobile/main.dart';
import '../UI/restaurantDetaiL.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
        onPressed: () => context.go('/detail/node_3422189698'),
        child: const Text('Go back to Cha + (DEBUG)'),
        ),
      )
    );
  }
}

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      name: "home",
      builder: (context, state) => Test(),
    ),
    GoRoute(
      path: '/detail/:id',
      name: "detail",
      builder: (context, state) => RestaurantDetailPage(idRestaurant: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/login',
      name: "login",
      builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/3422189698"),
    ),
    GoRoute(
      path: '/signin',
      name: "signin",
      builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/3422189698"),
    ),
    GoRoute(
      path: '/favorites',
      name: "favorites",
      builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/3422189698"),
    ),
    GoRoute(
      path: '/settings',
      name: "settings",
      builder: (context, state) => RestaurantDetailPage(idRestaurant: "node/3422189698"),
    )
  ],
);
