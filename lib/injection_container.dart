import 'package:get_it/get_it.dart';
import 'package:qarto/core/network/api_client.dart';
import 'package:qarto/features/products/data/datasources/product_remote_datasource.dart';
import 'package:qarto/features/products/data/repositories/product_repository_impl.dart';
import 'package:qarto/features/products/domain/repositories/product_repository.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';

final GetIt sl = GetIt.instance; // "sl" = Service Locator, common shorthand

Future<void> initDependencies() async {
  // ---------- Core ----------
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ---------- Products feature ----------
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Bloc
  sl.registerFactory<ProductBloc>(() => ProductBloc(sl<ProductRepository>()));
}
