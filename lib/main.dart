import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/database/db_helper.dart';
import 'package:project1/pages/navpages/schedule_page.dart';
import 'package:project1/pages/welcome/bloc/welcome_bloc.dart';
import 'package:project1/services/theme_services.dart';
import 'package:project1/ui/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeBloc(),
      child: ScreenUtilInit(
          builder: (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeService().theme,
            home: const HomePage(),
            // routes: {
            //   "signIn":(context) => const SignIn()
            // },
          )
      ),
    );
  }
}
