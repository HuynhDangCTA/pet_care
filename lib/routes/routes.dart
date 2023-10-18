import 'package:get/get.dart';
import 'package:pet_care/funtions/customer/customer_page.dart';
import 'package:pet_care/funtions/dashboard/dashboard_page.dart';
import 'package:pet_care/funtions/invoice/add_product/add_product_page.dart';
import 'package:pet_care/funtions/invoice/add_product/add_service_page.dart';
import 'package:pet_care/funtions/invoice/invoice_page.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_page.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_page.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_page.dart';
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
        page: () => const LoginPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.login,
        page: () => const LoginPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.register,
        page: () => const RegisterPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.home,
        page: () => const HomePage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.dashboard,
        page: () => const DashBoardPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.staffManager,
        page: () => const StaffPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.newStaff,
        page: () => const NewStaffPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.productManager,
        page: () => const ProductPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.newProduct,
        page: () => const NewProductPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.newService,
        page: () => const NewServicePage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.warehouse,
        page: () => const WarehousePage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.customer,
        page: () => const CustomerPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.invoice,
        page: () => const InvoicePage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.newInvoice,
        page: () => const NewInvoicePage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.addProduct,
        page: () => const AddProductPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConst.addService,
        page: () => const AddServicePage(),
        transition: Transition.rightToLeft)
  ];
}
