import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiClient = ApiClient();
    final authRemoteDataSource = AuthRemoteDataSource(apiClient);
    final AuthRepository authRepository = AuthRepositoryImpl(authRemoteDataSource);
    final loginUseCase = LoginUser(authRepository);
    final registerUseCase = RegisterUser(authRepository);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AuthProvider(
                loginUseCase: loginUseCase,
                registerUseCase: registerUseCase,
                authRepository: authRepository,
              ),
            ),
          ],
          child: MaterialApp.router(
            title: 'SafeRide',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
