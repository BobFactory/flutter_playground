import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environement {
   static String BASE_URL = dotenv.env['BASE_URL'] ?? "";
   static String USER_NAME = dotenv.env['USER_NAME'] ?? "";
}