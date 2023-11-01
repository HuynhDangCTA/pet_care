import 'package:get/get.dart';
import 'package:pet_care/funtions/cart/cart_controller.dart';
import 'package:pet_care/funtions/customer/customer_controller.dart';
import 'package:pet_care/funtions/dashboard/dashboard_controller.dart';
import 'package:pet_care/funtions/discounts/discount_controller.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/invoice/invoice_controller.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/funtions/order_customer/order_controller.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_controllter.dart';
import 'package:pet_care/funtions/product_manager/new_service/new_service_controller.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/funtions/product_manager/product_detail/product_detail_controller.dart';
import 'package:pet_care/funtions/product_manager/product_for_customer/product_detail_customer/product_detail_customer_controller.dart';
import 'package:pet_care/funtions/product_manager/product_for_customer/product_for_customer_controller.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/funtions/register/register_controller.dart';
import 'package:pet_care/funtions/room/room_controller.dart';
import 'package:pet_care/funtions/splash/splash_controller.dart';
import 'package:pet_care/funtions/staff_manager/new_staff/new_staff_controller.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import '../funtions/login/login_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashBoardController());
    Get.lazyPut(() => StaffController());
    Get.lazyPut(() => NewStaffController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => NewProductController());
    Get.lazyPut(() => NewServiceController());
    Get.lazyPut(() => WarehouseController());
    Get.lazyPut(() => CustomerController());
    Get.lazyPut(() => InvoiceController());
    Get.lazyPut(() => NewInvoiceController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => ProductForCustomerController());
    Get.lazyPut(() => ProductDetailCustomerController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => ProductDetailController());
    Get.lazyPut(() => DiscountController());
    Get.lazyPut(() => RoomController());
  }
}
