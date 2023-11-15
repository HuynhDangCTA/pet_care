import 'package:get/get.dart';
import 'package:pet_care/bindings/all_binding.dart';
import 'package:pet_care/funtions/cart/cart_page.dart';
import 'package:pet_care/funtions/customer/customer_page.dart';
import 'package:pet_care/funtions/dashboard/dashboard_page.dart';
import 'package:pet_care/funtions/discounts/discount_page.dart';
import 'package:pet_care/funtions/discounts/new_discount/new_discount_page.dart';
import 'package:pet_care/funtions/discounts/new_discount/select_product_page.dart';
import 'package:pet_care/funtions/discounts/new_voucher/new_voucher_page.dart';
import 'package:pet_care/funtions/invoice/add_product/add_product_page.dart';
import 'package:pet_care/funtions/invoice/add_product/add_service_page.dart';
import 'package:pet_care/funtions/invoice/invoice_page.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_page.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_page.dart';
import 'package:pet_care/funtions/product_manager/product_detail/product_detail_page.dart';
import 'package:pet_care/funtions/product_manager/warehouse/new_product_warehouse.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_page.dart';
import 'package:pet_care/funtions/room/new_room_cat/new_room_cat_page.dart';
import 'package:pet_care/funtions/room/new_room_cat/new_room_dog_page.dart';
import 'package:pet_care/funtions/room/room_page.dart';
import 'package:pet_care/funtions/splash/splash_screen.dart';
import 'package:pet_care/funtions/staff_manager/new_staff/new_staff_page.dart';
import 'package:pet_care/funtions/staff_manager/staff_page.dart';
import 'package:pet_care/routes/routes_const.dart';

import '../funtions/home/home_page.dart';
import '../funtions/login/login_page.dart';
import '../funtions/product_manager/new_service/new_service_page.dart';
import '../funtions/product_manager/product_page.dart';
import '../funtions/register/register_page.dart';

class Routes {
  static final routes = [
    GetPage(
        name: '/',
        page: () => const SplashPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.splash,
        page: () => const SplashPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.login,
        page: () => const LoginPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.register,
        page: () => const RegisterPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.home,
        page: () => const HomePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.dashboard,
        page: () => const DashBoardPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.staffManager,
        page: () => const StaffPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newStaff,
        page: () => const NewStaffPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.productManager,
        page: () => const ProductPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newProduct,
        page: () => const NewProductPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newService,
        page: () => const NewServicePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.warehouse,
        page: () => const WarehousePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.customer,
        page: () => const CustomerPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.invoice,
        page: () => const InvoicePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newInvoice,
        page: () => const NewInvoicePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.addProduct,
        page: () => const AddProductPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.addService,
        page: () => const AddServicePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.cart,
        page: () => const CartPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.productDetail,
        page: () => const ProductDetailPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.discount,
        page: () => const DiscountPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.productWarehouse,
        page: () => const NewProductWarehousePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.room,
        page: () => const RoomPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.roomCat,
        page: () => const NewRoomCatPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.roomDog,
        page: () => const NewRoomDogPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newDiscount,
        page: () => const NewDiscountPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.newVoucher,
        page: () => const NewVoucherPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.selectProduct,
        page: () => const SelectProductPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
  ];
}
