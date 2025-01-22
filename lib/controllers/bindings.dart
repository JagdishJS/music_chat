import './../library.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy loads the controller when it is first accessed.
    Get.lazyPut<CommonController>(CommonController.new, fenix: true);
  }
}
