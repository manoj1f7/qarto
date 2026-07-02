import 'package:get_it/get_it.dart';
import 'package:qarto/core/network/api_client.dart';
import 'package:qarto/core/theme/theme_cubit.dart'; // ADD THIS IMPORT
import 'package:qarto/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:qarto/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:qarto/features/cart/domain/repositories/cart_repository.dart';
import 'package:qarto/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qarto/features/products/data/datasources/product_remote_datasource.dart';
import 'package:qarto/features/products/data/repositories/product_repository_impl.dart';
import 'package:qarto/features/products/domain/repositories/product_repository.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---------- Core ----------
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit()); // ADD THIS LINE

  // ---------- Products feature ----------
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerFactory<ProductBloc>(() => ProductBloc(sl<ProductRepository>()));

  // ---------- Cart feature ----------
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl<CartLocalDataSource>()));
  sl.registerFactory<CartBloc>(() => CartBloc(sl<CartRepository>()));
}
