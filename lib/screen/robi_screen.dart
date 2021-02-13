import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siminfoapp/model/offer_model.dart';
import 'package:siminfoapp/provider/my_provider.dart';
import 'package:url_launcher/url_launcher.dart';


class RobiScreen extends StatefulWidget {
  @override
  _RobiScreenState createState() => _RobiScreenState();
}

class _RobiScreenState extends State<RobiScreen> {
  List<OfferModel> robiMinuteList=[];
  List<OfferModel> robiinternetList=[];

  Widget offerList({String name, String Number}) {
    print(name);
    return Container(
      height: 70,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                  onTap: () {
                    //print(post['number'].toString());
                    // "tel:*111*2" + Uri.encode("#");
                    setState(() {
                      launch("tel://" + Number.toString());
                    });
                  },
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    MyProvider provider=Provider.of<MyProvider>(context);


    provider.getrobiOfferListIntenetr();
    robiinternetList=provider.throwrobinternetList;

    provider.getrobiOfferListminute();
    robiMinuteList=provider.throwrobiminuteList;


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Minute',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Internet',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: robiMinuteList.length,
              itemBuilder:(context,index)
              {
                return robiMinuteList !=null ?
                offerList(name:robiMinuteList[index].offerName,
                    Number: robiMinuteList[index].number
                ) :Center(
                  child: Text('No offer Available'),
                );
              },
            ),

            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: robiinternetList.length,
              itemBuilder:(context,index)
              {
                return robiinternetList !=null ?
                offerList(name:robiinternetList[index].offerName,
                    Number: robiinternetList[index].number
                ) :Center(
                  child: Text('No offer Available'),
                );
              },
            ),
          ],
        ),
      ),

    );
  }
}
