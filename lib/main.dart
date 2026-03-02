import 'package:flutter/material.dart';
import 'package:sevenseers/core/network/api_client.dart';
import 'package:sevenseers/core/theme/app_theme.dart';
import 'package:sevenseers/features/meals/data/datasource/meal_remote_datasource.dart';
import 'package:sevenseers/features/meals/data/repository/meal_repository_impl.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:sevenseers/features/meals/presentation/screens/meal_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );
  runApp(const SevenSeersApp());
}

class SevenSeersApp extends StatelessWidget {
  const SevenSeersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final dataSource = MealRemoteDataSourceImpl(apiClient: apiClient);
    final repository = MealRepositoryImpl(remoteDataSource: dataSource);

    return BlocProvider(
      create: (_) => MealBloc(repository: repository),
      child: MaterialApp(
        title: '7Seers Recipes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MealListScreen(),
      ),
    );
  }
}
