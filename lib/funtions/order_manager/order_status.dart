import 'package:flutter/material.dart';

class OrderStatusConst {
  static const String choXacNhan = 'Chờ xác nhận';
  static const String dangChuanBiHang = 'Đang chuẩn bị hàng';
  static const String dangGiaoHang = 'Đang giao hàng';
  static const String giaoHangThanhCong = 'Thành công';
  static const String huyDon = 'Hủy đơn';
  static const String giaoHangThatBai = 'Giao hàng thất bại';

  static Color getColor(String status) {
    if (status == OrderStatusConst.huyDon) {
      return Colors.red;
    }
    if (status == OrderStatusConst.giaoHangThanhCong) {
      return Colors.green;
    }
    return Colors.blue;
  }

  static List<String> getList(String status) {
    switch (status) {
      case choXacNhan:
        return [choXacNhan];
      case huyDon:
        return [choXacNhan, huyDon];
      case dangChuanBiHang:
        return [choXacNhan, dangChuanBiHang];
      case dangGiaoHang:
        return [choXacNhan, dangChuanBiHang, dangGiaoHang];
      case giaoHangThanhCong:
        return [choXacNhan, dangChuanBiHang, dangGiaoHang, giaoHangThanhCong];
      case giaoHangThatBai:
        return [choXacNhan, dangChuanBiHang, dangGiaoHang, giaoHangThatBai];
    }
    return [choXacNhan];
  }
}
