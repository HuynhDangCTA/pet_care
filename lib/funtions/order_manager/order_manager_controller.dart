import 'dart:async';

import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/order_manager/order_status.dart';
import 'package:pet_care/model/order_model.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/voucher.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/services/send_notify.dart';
import 'package:pet_care/util/dialog_util.dart';

class OrderManagerController extends GetxController {
  RxInt currentStep = 0.obs;
  UserResponse? user = HomeController.instants.userCurrent;

  RxList<OrderModel> unFinishOrders = <OrderModel>[].obs;
  RxList<OrderModel> finishOrders = <OrderModel>[].obs;
  RxList<OrderModel> waitOrders = <OrderModel>[].obs;
  late StreamSubscription unFinishOrderListener;
  late StreamSubscription unWaitOrderListener;
  late StreamSubscription finishOrderListener;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listenWaitOrder();
    listenUnFinishOrder();
    listenFinishOrder();
  }

  void changePage(value) {
    currentStep.value = value;
  }

  void listenUnFinishOrder() {
    unFinishOrderListener = FirebaseHelper.listenUnFinishOrder(
      user!.id!,
      onAdded: (order) async {
        await FirebaseHelper.getProductFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            List<Product> result = [];
            for (var doc in value.docs) {
              Product product =
                  Product.fromDocument(doc.data() as Map<String, dynamic>);
              product.id = doc.id;
              result.add(product);
            }
            order.product = result;
          }
        });
        await FirebaseHelper.getVoucherFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            Voucher voucher = Voucher.fromMap(
                value.docs.first.data() as Map<String, dynamic>);
            voucher.id = value.docs.first.id;
            order.voucher = voucher;
          }
        });
        await FirebaseHelper.getCustomerFromOrder(order.id!).then((value) {
          UserResponse customer = UserResponse.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          customer.id = value.docs[0].id;
          order.orderBy = customer;
        });

        await FirebaseHelper.getStaffFromOrder(order.id!).then((value) {
          UserResponse customer = UserResponse.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          customer.id = value.docs[0].id;
          order.staff = customer;
        });
        unFinishOrders.add(order);
      },
      onModified: (order) {
        if (unFinishOrders.contains(order)) {
          unFinishOrders[unFinishOrders.indexOf(order)].status = order.status;
          unFinishOrders.refresh();
        }
      },
      onRemoved: (order) {
        unFinishOrders.remove(order);
      },
    );
  }

  void listenFinishOrder() {
    finishOrderListener = FirebaseHelper.listenFinishOrder(
      user!.id!,
      onAdded: (order) async {
        await FirebaseHelper.getProductFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            List<Product> result = [];
            for (var doc in value.docs) {
              Product product =
                  Product.fromDocument(doc.data() as Map<String, dynamic>);
              product.id = doc.id;
              result.add(product);
            }
            order.product = result;
          }
        });
        await FirebaseHelper.getVoucherFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            Voucher voucher = Voucher.fromMap(
                value.docs.first.data() as Map<String, dynamic>);
            voucher.id = value.docs.first.id;
            order.voucher = voucher;
          }
        });
        await FirebaseHelper.getCustomerFromOrder(order.id!).then((value) {
          UserResponse customer = UserResponse.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          customer.id = value.docs[0].id;
          order.orderBy = customer;
        });
        await FirebaseHelper.getStaffFromOrder(order.id!).then((value) {
          UserResponse customer = UserResponse.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          customer.id = value.docs[0].id;
          order.staff = customer;
        });
        finishOrders.add(order);
        // if (user!.type! == Constants.typeAdmin) {
        //   finishOrders.add(order);
        // } else if (user!.id! == order.staff!.id!) {
        //
        // }
      },
      onModified: (order) {
        if (finishOrders.contains(order)) {
          finishOrders[finishOrders.indexOf(order)].status = order.status;
          finishOrders.refresh();
        }
      },
      onRemoved: (order) {
        finishOrders.remove(order);
      },
    );
  }

  void listenWaitOrder() {
    unWaitOrderListener = FirebaseHelper.listenWaitOrder(
      user!.id!,
      onAdded: (order) async {
        await FirebaseHelper.getProductFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            List<Product> result = [];
            for (var doc in value.docs) {
              Product product =
                  Product.fromDocument(doc.data() as Map<String, dynamic>);
              product.id = doc.id;
              result.add(product);
            }
            order.product = result;
          }
        });
        await FirebaseHelper.getVoucherFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            Voucher voucher = Voucher.fromMap(
                value.docs.first.data() as Map<String, dynamic>);
            voucher.id = value.docs.first.id;
            order.voucher = voucher;
          }
        });

        await FirebaseHelper.getCustomerFromOrder(order.id!).then((value) {
          UserResponse customer = UserResponse.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          customer.id = value.docs[0].id;
          order.orderBy = customer;
        });
        waitOrders.add(order);
      },
      onModified: (order) {
        if (waitOrders.contains(order)) {
          if (order.status != OrderStatusConst.choXacNhan) {
            waitOrders.remove(order);
          } else {
            waitOrders[waitOrders.indexOf(order)].status = order.status;
            waitOrders.refresh();
          }
        }
      },
      onRemoved: (order) {
        waitOrders.remove(order);
      },
    );
  }

  Future acceptOrder(OrderModel order) async {
    DialogUtil.showLoading();
    await FirebaseHelper.updateStatusOrder(
            order.id!, OrderStatusConst.dangChuanBiHang)
        .then((value) async {
      await FirebaseHelper.setStaffForOrder(user!, order.id!).then((value) {});
      await FirebaseHelper.updateOrder(
          order.id!, {Constants.staffId: user!.id});
      waitOrders.remove(order);
      DialogUtil.hideLoading();
      SendNotify.sendNotify(
          token: order.orderBy!.token ?? '',
          title: 'Đơn hàng của bạn đã được xác nhận',
          body:
              'Cửa hàng đang chuẩn bị hàng cho bạn. Đơn hàng sẽ sớm giao đến bạn!');
    });
  }

  Future cancelOrder(OrderModel order) async {
    await FirebaseHelper.updateStatusOrder(order.id!, OrderStatusConst.huyDon)
        .then((value) async {
      for (var product in order.product!) {
        await FirebaseHelper.getProductFromID(product.id!).then((value) async {
          int amount = value.get(Constants.amount);
          amount += product.sold;
          await FirebaseHelper.updateAmountProduct(product.id!, amount);
        });
      }
      waitOrders.remove(order);
      DialogUtil.showSnackBar('Hủy đơn thành công');
    });
  }

  Future shipOrder(OrderModel order) async {
    DialogUtil.showLoading();
    await FirebaseHelper.updateStatusOrder(
            order.id!, OrderStatusConst.dangGiaoHang)
        .then((value) async {
      await FirebaseHelper.updateOrder(
          order.id!, {Constants.staffId: user!.id});
      DialogUtil.hideLoading();
      SendNotify.sendNotify(
          token: order.orderBy!.token ?? '',
          title: 'Đơn hàng đang giao đến bạn',
          body: 'Đơn hàng đã chuẩn bị xong. Đơn hàng sẽ sớm giao đến bạn!');
    });
  }

  Future doneOrder(OrderModel order) async {
    DialogUtil.showLoading();
    await FirebaseHelper.updateStatusOrder(
            order.id!, OrderStatusConst.giaoHangThanhCong)
        .then((value) async {
      await FirebaseHelper.updateOrder(
          order.id!, {Constants.staffId: user!.id});
      unFinishOrders.remove(order);
      DialogUtil.hideLoading();
      SendNotify.sendNotify(
          token: order.orderBy!.token ?? '',
          title: 'Đơn hàng đã hoàn thành',
          body: 'Đơn hàng đã giao đến bạn. Cảm ơn bạn vì đã ủng hộ shop!');
    });
  }

  Future failureOrder(OrderModel order) async {
    DialogUtil.showLoading();
    await FirebaseHelper.updateStatusOrder(
            order.id!, OrderStatusConst.giaoHangThatBai)
        .then((value) async {
      for (var product in order.product!) {
        await FirebaseHelper.getProductFromID(product.id!).then((value) async {
          int amount = value.get(Constants.amount);
          amount += product.sold;
          await FirebaseHelper.updateAmountProduct(product.id!, amount);
        });
      }
      unFinishOrders.remove(order);
      DialogUtil.hideLoading();
      SendNotify.sendNotify(
          token: order.orderBy!.token ?? '',
          title: 'Giao hàng thất bại',
          body:
              'Đơn hàng đã không thể giao đến bạn. Xin lõi bạn vì sự bất tiện này!');
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    unWaitOrderListener.cancel();
    unFinishOrderListener.cancel();
    finishOrderListener.cancel();
  }
}
