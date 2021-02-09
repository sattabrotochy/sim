import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:siminfoapp/model/data_model.dart';

class MyProvider extends ChangeNotifier {
  List<DataModel> gpList1 = [];
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
      gpList1 = newgpList;
      notifyListeners();
    });
  }

  get throwGpList {
    return gpList1;
  }


  List<DataModel> airtelList1=[];
  DataModel airtel_dataModel;


  Future<Void> getAirtelData() async {
    List<DataModel> newAirtelList = [];

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('AirtelData').get();
    querySnapshot.docs.forEach((element) {
      airtel_dataModel = DataModel(
          id: element.data()['id'],
          name: element.data()['name'],
          number: element.data()['number']);

      newAirtelList.add(airtel_dataModel);

      airtelList1 = newAirtelList;
      notifyListeners();
    });
  }

  get throwaitelList {
    return airtelList1;
  }




}
