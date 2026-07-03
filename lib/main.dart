import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qarto/core/utils/global_messenger.dart';
import 'package:qarto/features/cart/data/models/cart_item_model.dart';
import 'package:qarto/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qarto/features/cart/presentation/bloc/cart_event.dart';
import 'package:qarto/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/bloc/product_event.dart';
import 'features/products/presentation/screens/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>('cartBox');

  await initDependencies();

  runApp(const QartoApp());
}

class QartoApp extends StatelessWidget {
  const QartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()..add(const LoadCart())),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            title: 'Qarto E-Commerce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}
