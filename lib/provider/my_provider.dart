import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:siminfoapp/model/data_model.dart';

class MyProvider extends ChangeNotifier {
  List<DataModel> gpList = [];
  DataModel gpDataModel;

  Future<Void> getGpData() async {
    List<DataModel> newgpList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('GpData').get();
    querySnapshot.docs.forEach((element) {
      gpDataModel = DataModel(
        id: element.data()['id'],
          name: element.data()['name'],
          number: element.data()['number']);

      newgpList.add(gpDataModel);
     // print(newgpList.length);
      gpList = newgpList;
      notifyListeners();
    });
  }

  get throwGpList {
    return gpList;
  }
}
