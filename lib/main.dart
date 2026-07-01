import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_event.dart';
import 'package:qarto/injection_container.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Service Locator (GetIt)
  await initDependencies();

  runApp(const QartoApp());
}

class QartoApp extends StatelessWidget {
  const QartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Inject ProductBloc and immediately trigger the LoadProducts event
        BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
      ],
      child: MaterialApp(
        title: 'Qarto E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
      ),
    );
  }
}
