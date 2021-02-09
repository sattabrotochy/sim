import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:siminfoapp/model/data_model.dart';
import 'package:siminfoapp/provider/my_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {







  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  final _nativeAdController = NativeAdmobController();
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: InterstitialAd.testAdUnitId,
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }



  List<DataModel> gpList = [];
  List<DataModel> airtelList = [];

  int current_state;
  final GlobalKey _scaffoldKey = new GlobalKey();

  Widget listItem({String name, String number}) {

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
            InkWell(
                onTap: () {
                  //print(post['number'].toString());
                  // "tel:*111*2" + Uri.encode("#");
                  setState(() {
                    launch("tel://" + number.toString());
                  });
                },
                child: Icon(Icons.call,color: Colors.blueAccent,))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current_state = 0;


    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3940256099942544/1033173712');
   // _bannerAd = createBannerAdd()..load();
    _interstitialAd = createInterstitialAd()..load();
    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print('Rewarded event: $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  Widget drawer() {
    return Container(
      child: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'assets/teletalk_image.jpg',
                  ),
                  fit: BoxFit.cover,
                )),
              ),
              ListTile(
                onTap: () {
                  sharedata("lallal",
                      "https://www.youtube.com/results?search_query=+share+system+use+in+flutter");
                  // FlutterShare.share(
                  //     title: "sad",
                  //     linkUrl: "https://www.youtube.com/watch?v=AdnVzpYYcuI");
                },
                title: Text("Share"),
                leading: Icon(Icons.share_rounded),
              ),
              ListTile(
                onTap: _launchURL,
                title: Text("More Apps"),
                leading: Icon(Icons.mobile_friendly_rounded),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => AirtelPage()));
                  // Navigator.of(context).pop();
                },
                title: Text("About"),
                leading: Icon(Icons.list),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future sharedata(String s, String t) async {
    await FlutterShare.share(
      title: s,
      linkUrl: t,
    );
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      _interstitialAd?.show();
    });

    MyProvider provider = Provider.of<MyProvider>(context);

    /// get gp data list
    provider.getGpData();
    gpList = provider.throwGpList;

    /// airtel data list

    provider.getAirtelData();
    airtelList=provider.throwaitelList;

   // print(gpList.length);

    return Scaffold(
      drawer: drawer(),
      key: _scaffoldKey,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black12,
        buttonBackgroundColor: Colors.white,
        height: 55,
        items: <Widget>[
          Container(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/gp.png'),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/airtel.png'),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/robi.png'),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/banglalink.png'),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/telitok.png'),
              ),
            ),
          ),
        ],
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            current_state = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: (current_state == 0)
                      ? Container(
                          child: ClipPath(
                            clipper: MyCliper(),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.blue),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer(),
                                      child: Icon(
                                        Icons.menu,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Grameenphone',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : (current_state == 1)
                          ? Container(
                              child: ClipPath(
                                clipper: MyCliper(),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Scaffold.of(context).openDrawer(),
                                          child: Icon(
                                            Icons.menu,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Airtel ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : (current_state == 2)
                              ? Container(
                                  child: ClipPath(
                                    clipper: MyCliper(),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.red),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  Scaffold.of(context)
                                                      .openDrawer(),
                                              child: Icon(
                                                Icons.menu,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Robi',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : (current_state == 3)
                                  ? Container(
                                      child: ClipPath(
                                        clipper: MyCliper(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Scaffold.of(context)
                                                          .openDrawer(),
                                                  child: Icon(
                                                    Icons.menu,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    'Banglalink ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: ClipPath(
                                        clipper: MyCliper(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Scaffold.of(context)
                                                          .openDrawer(),
                                                  child: Icon(
                                                    Icons.menu,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    'Teletalk',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                ),
                SizedBox(
                  height: 6,
                ),
                Expanded(
                  flex: 2,
                  child:(current_state==0)? ListView.separated(
                    shrinkWrap: true,
                    itemCount: gpList.length,
                    itemBuilder: (context, index) {

                      //print(gpList[index].name);
                      return gpList != null
                          ? listItem(
                              name: gpList[index].name,
                              number: gpList[index].number,
                            )
                          : CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      );
                    },
                    separatorBuilder: (context,index){
                      return index % 4==0?
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          height: 80,
                          color: Colors.green,
                          child: NativeAdmob(
                            adUnitID: NativeAd.testAdUnitId,
                            controller: _nativeAdController,
                            type: NativeAdmobType.full,
                            loading: Center(child: CircularProgressIndicator()),
                            error: Text('failed to load'),
                          )
                      ):gpList != null
                          ? listItem(
                        name: gpList[index].name,
                        number: gpList[index].number,
                      )
                          : CircularProgressIndicator();
                    },


                  ):(current_state==1)?
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: airtelList.length,
                    itemBuilder: (context, index) {

                      //print(gpList[index].name);
                      return airtelList != null
                          ? listItem(
                        name: airtelList[index].name,
                        number: airtelList[index].number,
                      )
                          : CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      );
                    },
                    separatorBuilder: (context,index){
                      return index % 4==0?
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          height: 80,
                          color: Colors.green,
                          child: NativeAdmob(
                            adUnitID: NativeAd.testAdUnitId,
                            controller: _nativeAdController,
                            type: NativeAdmobType.full,
                            loading: Center(child: CircularProgressIndicator()),
                            error: Text('failed to load'),
                          )
                      ):listItem(
                        name: airtelList[index].name,
                        number: airtelList[index].number
                      );
                    },

                  ):(current_state==2)?

                  ListView(

                  ):(current_state==3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 70);
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
