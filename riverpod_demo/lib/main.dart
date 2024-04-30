import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_demo/environment.dart';
import 'package:riverpod_demo/network/api_client.dart';
import 'package:riverpod_demo/network/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  const flavour = String.fromEnvironment('flavour', defaultValue: "dev");

  if (flavour == "dev") {
    await dotenv.load(fileName: ".env.development");
  } else {
    await dotenv.load(fileName: ".env.production");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  Future<void> getData(context) async {
    try {
      var body = <String, dynamic>{
        "type": "phone",
        "value": "9172919",
        "countryCode": 1
      };

      var r =
          await dio.post("https://api-stage.platablenow.com/auth", data: body);
    } catch (e) {
      handleError(e, context);
    }
  }

  getAuthData(context) async {
    await (await SharedPreferences.getInstance()).clear();
    const url = "https://api-stage.platablenow.com/account/me";
    try {
      var r = await dio.get(url);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(r.data["success"].toString()),
          actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              )
            ],
        ),
      );
    } catch (e) {
      handleError(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      getAuthData(context);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Environment Variables"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("BASE_URL: ${Environement.BASE_URL}"),
            Text("USER_NAME: ${Environement.USER_NAME}"),
          ],
        ),
      ),
    );
  }
}
