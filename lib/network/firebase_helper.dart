import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/customer.dart';
import 'package:pet_care/model/invoice.dart';
import 'package:pet_care/model/item_warehouse.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/room.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/user_request.dart';

import '../model/warehouse.dart';

class FirebaseHelper {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static const Duration timeout = Duration(milliseconds: 1000);

  static Future<QuerySnapshot?> login(UserRequest user) async {
    QuerySnapshot? result = await database
        .collection(Constants.users)
        .where(
          Constants.username,
          isEqualTo: user.name,
        )
        .where(Constants.password, isEqualTo: user.password)
        .get()
        .timeout(timeout);
    return result;
  }

  static Future<DocumentReference> register(UserResponse data) async {
    DocumentReference result =
        await database.collection(Constants.users).add(data.toMap());
    return result;
  }

  static Future<QuerySnapshot?> getAllStaff(String username) async {
    QuerySnapshot? result = await database
        .collection(Constants.users)
        .where(Constants.username, isNotEqualTo: username)
        .get()
        .timeout(timeout);
    return result;
  }

  static Future<void> editUser(UserResponse data) async {
    return await database
        .collection(Constants.users)
        .doc(data.id)
        .update(data.toMap());
  }

  static Future<void> deletedUser(UserResponse data) async {
    return await database
        .collection(Constants.users)
        .doc(data.id)
        .update({Constants.isDeleted: true});
  }

  static Future<String?> uploadFile(File file, String filename) async {
    final firebaseStorage = FirebaseStorage.instance;
    final Reference storageReference = firebaseStorage.ref().child(filename);
    Uint8List imageData = await file.readAsBytes();
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = storageReference.putData(imageData, metadata);
    } else {
      uploadTask = storageReference.putFile(file);
    }

    await uploadTask.whenComplete(() => print('Upload complete'));
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  static Future<String?> uploadFileWeb(Uint8List file, String filename) async {
    final firebaseStorage = FirebaseStorage.instance;
    final Reference storageReference = firebaseStorage.ref().child(filename);
    final metadata = SettableMetadata(contentType: 'image/png');
    UploadTask uploadTask = storageReference.putData(file, metadata);
    await uploadTask.whenComplete(() => print('Upload complete'));
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  static Future<DocumentReference> newProduct(Product product) async {
    return database.collection(Constants.products).add(product.toMap());
  }

  static Future<QuerySnapshot> getAllProducts() async {
    return database
        .collection(Constants.products)
        .orderBy(Constants.sold)
        .get();
  }

  static Future<void> updateProduct(Product product) async {
    return database
        .collection(Constants.products)
        .doc(product.id)
        .update(product.toMap());
  }

  static Future<void> updateProductWarehouse(
      String id, int amount, int price) async {
    return database
        .collection(Constants.products)
        .doc(id)
        .update({Constants.amount: amount, Constants.priceInput: price});
  }

  static Future<void> updateAmountProduct(String id, int amount) async {
    return database
        .collection(Constants.products)
        .doc(id)
        .update({Constants.amount: amount});
  }

  static Future<DocumentReference> newService(ServiceModel service) async {
    return database.collection(Constants.services).add(service.toMap());
  }

  static Future<QuerySnapshot> getAllServices() async {
    return database.collection(Constants.services).get();
  }

  static Future<DocumentReference> newWarehouse(Warehouse warehouse) async {
    return database.collection(Constants.warehouse).add(warehouse.toMap());
  }

  static Future<DocumentReference> addProductToWarehouse(
      Product item, String id) async {
    return database
        .collection(Constants.warehouse)
        .doc(id)
        .collection(Constants.products)
        .add(item.toMap());
  }

  static Future<QuerySnapshot> getAllCustomer() async {
    return database.collection(Constants.customers).get();
  }

  static Future<QuerySnapshot> getTypeProducts() async {
    return database.collection(Constants.typeProduct).get();
  }

  static Future<DocumentReference> newTypeProduct(String type) async {
    return database
        .collection(Constants.typeProduct)
        .add({Constants.type: type});
  }

  static Future<DocumentReference> newCustomer(Customer customer) async {
    return database.collection(Constants.customers).add(customer.toMap());
  }

  static Future<void> updateCustomer(int times, String id) async {
    return database
        .collection(Constants.customers)
        .doc(id)
        .update({Constants.times: times});
  }

  static Future<DocumentReference> newInvoice(Invoice invoice) async {
    return database.collection(Constants.invoices).add(invoice.toMap());
  }

  static Future<void> updateInvoice(Invoice invoice) {
    return database
        .collection(Constants.invoices)
        .doc(invoice.id!)
        .update(invoice.toMap());
  }

  static Future<void> newInvoiceProduct(
      Product product, String invoiceId) async {
    return database
        .collection(Constants.invoices)
        .doc(invoiceId)
        .collection(Constants.products)
        .doc(product.id)
        .set(product.toMap());
  }

  static Future<DocumentReference> newInvoiceService(
      ServiceModel serviceModel, String invoiceId) async {
    return database
        .collection(Constants.invoices)
        .doc(invoiceId)
        .collection(Constants.services)
        .add(serviceModel.toMapForInvoice());
  }

  static Future<QuerySnapshot> getAllInvoice() async {
    return database
        .collection(Constants.invoices)
        .orderBy(Constants.createdAt, descending: true)
        .get();
  }

  static Future<QuerySnapshot> getAllProductInInvoice(String docId) async {
    return database
        .collection(Constants.invoices)
        .doc(docId)
        .collection(Constants.products)
        .get();
  }

  static Future<QuerySnapshot> getAllServiceInInvoice(String docId) async {
    return database
        .collection(Constants.invoices)
        .doc(docId)
        .collection(Constants.services)
        .get();
  }

  static Future<void> addToCart(Product product, String userid) async {
    return database
        .collection(Constants.users)
        .doc(userid)
        .collection(Constants.carts)
        .doc(product.id)
        .set({Constants.amount: product.amount});
  }

  static Future<DocumentSnapshot> getProductFromCart(String id, String userID) {
    return database
        .collection(Constants.users)
        .doc(userID)
        .collection(Constants.carts)
        .doc(id)
        .get();
  }

  static Future<QuerySnapshot> getAllProductFromCart(String userID) {
    return database
        .collection(Constants.users)
        .doc(userID)
        .collection(Constants.carts)
        .get();
  }

  static Future<DocumentSnapshot> getProductFromID(String id) {
    return database.collection(Constants.products).doc(id).get();
  }

  static Future<DocumentReference> newRoomCat(Room room) {
    return database.collection(Constants.roomCat).add(room.toMap());
  }

  static Future<DocumentReference> newRoomDog(Room room) {
    return database.collection(Constants.roomDog).add(room.toMap());
  }

  static Future<bool> isExistRoomCat(String name) async {
    bool isExist = false;
    await database
        .collection(Constants.roomCat)
        .where(Constants.name, isEqualTo: name)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isExist = true;
      }
    });
    return isExist;
  }

  static Future<bool> isExistRoomDog(String name) async {
    bool isExist = false;
    await database
        .collection(Constants.roomDog)
        .where(Constants.name, isEqualTo: name)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isExist = true;
      }
    });
    return isExist;
  }

  static Future<QuerySnapshot> getAllRoomCat() async {
    return database.collection(Constants.roomCat).orderBy(Constants.name).get();
  }

  static Future<QuerySnapshot> getAllRoomDog() async {
    return database.collection(Constants.roomDog).orderBy(Constants.name).get();
  }

  static Future bookRoomCat(Room room) async {
    return database
        .collection(Constants.roomCat)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future checkOutCat(Room room) async {
    return database
        .collection(Constants.roomCat)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future bookRoomDog(Room room) async {
    return database
        .collection(Constants.roomDog)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future checkOutDog(Room room) async {
    return database
        .collection(Constants.roomDog)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }
}
