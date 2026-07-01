import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qarto/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart'; // Import the new Cubit
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/bloc/product_event.dart';
import 'features/products/presentation/screens/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  // Register ThemeCubit in your GetIt container (add this line to your injection_container.dart if you prefer)
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  runApp(const QartoApp());
}

class QartoApp extends StatelessWidget {
  const QartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
        // Provide the ThemeCubit globally
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      ],
      // Listen to the ThemeCubit to update MaterialApp's themeMode
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Qarto E-Commerce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // This now changes dynamically!
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}
