import 'package:manager_getxcli/app/modules/home/home_view.dart';
import 'package:manager_getxcli/app/modules/home/home_binding.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}