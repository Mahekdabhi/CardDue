import 'package:go_router/go_router.dart';
import '../features/dashboard/presentation/views/dashboard_view.dart';
import '../features/cards/presentation/views/add_edit_card_view.dart';
import '../features/analytics/presentation/views/analytics_view.dart';
import '../features/settings/presentation/views/settings_view.dart';

class AppRouter {
  AppRouter._();

  static const String dashboardPath = '/';
  static const String addCardPath = '/add-card';
  static const String editCardPath = '/edit-card/:cardId';
  static const String analyticsPath = '/analytics';
  static const String settingsPath = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: dashboardPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: dashboardPath,
        name: 'dashboard',
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: addCardPath,
        name: 'add-card',
        builder: (context, state) => const AddEditCardView(),
      ),
      GoRoute(
        path: editCardPath,
        name: 'edit-card',
        builder: (context, state) {
          final cardId = state.pathParameters['cardId'];
          return AddEditCardView(cardId: cardId);
        },
      ),
      GoRoute(
        path: analyticsPath,
        name: 'analytics',
        builder: (context, state) => const AnalyticsView(),
      ),
      GoRoute(
        path: settingsPath,
        name: 'settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
