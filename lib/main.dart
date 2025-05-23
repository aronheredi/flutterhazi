import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework_24_2/ui/bloc/list/list_bloc.dart';
import 'package:flutter_homework_24_2/ui/bloc/list/list_page.dart';
import 'package:flutter_homework_24_2/ui/bloc/login/login_bloc.dart';
import 'package:flutter_homework_24_2/ui/bloc/login/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/data_source_interceptor.dart';

//DO NOT MODIFY
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFixDependencies();
  await configureCustomDependencies();
  runApp(const MyApp());
}

//DO NOT MODIFY
Future configureFixDependencies() async {
  var dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(DataSourceInterceptor());
  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerSingleton(<NavigatorObserver>[]);
}

//Add custom dependencies if necessary
Future configureCustomDependencies() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<ListBloc>(create: (context) => ListBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {
          '/login': (context) => const LoginPageBloc(),
          '/list': (context) {
            final token = ModalRoute.of(context)!.settings.arguments as String;
            return BlocProvider<ListBloc>(
              create: (context) => ListBloc(token: token),
              child: const ListPageBloc(),
            );
          },
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPageBloc(),
        //DO NOT MODIFY
        navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
        //DO NOT MODIFY
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
