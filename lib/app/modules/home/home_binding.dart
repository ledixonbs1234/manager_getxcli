import 'package:get/get.dart';

import 'package:manager_getxcli/app/modules/home/home_controller.dart';
import 'package:manager_getxcli/app/repository/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
          () => HomeController(repository: HomeRepository()),
    );
  }
}
