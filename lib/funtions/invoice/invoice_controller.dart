import 'package:get/get.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';

import '../../model/invoice.dart';

class InvoiceController extends GetxController {
  RxList<Invoice> invoices = <Invoice>[].obs;
  RxInt totalInvoice = 0.obs;
  RxInt totalMoney = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getAllInvoices();
  }

  void goNewInvoice() {
    Get.lazyPut(() => NewInvoiceController());
    Get.toNamed(RoutesConst.newInvoice);
  }

  Future getAllInvoices() async {
    invoices.clear();
    await FirebaseHelper.getAllInvoice().then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          Invoice invoice = Invoice.fromDocument(
              doc.data() as Map<String, dynamic>);
          invoice.id = doc.id;
          invoices.add(invoice);
        }
      }
    });
    calculationInvoice();
  }

  void calculationInvoice() {
    DateTime today = DateTime.now();
    int totalI = 0;
    int totalM = 0;
    if (invoices.isNotEmpty) {
      for (var invoice in invoices) {
        if (invoice.createdAt.day == today.day &&
            invoice.createdAt.year == today.year &&
            invoice.createdAt.month == today.month) {
            totalI ++;
            totalM += invoice.totalMoney;
        }
      }
    }
    totalInvoice.value = totalI;
    totalMoney.value = totalM;
  }

  void editInvoice(Invoice invoice) {
    Get.lazyPut(() => NewInvoiceController());
    Get.toNamed(RoutesConst.newInvoice, arguments: invoice);
  }
}
