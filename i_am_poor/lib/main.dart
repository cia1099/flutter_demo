import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:i_am_poor/payment_configurations.dart';
import 'package:pay/pay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '0.01',
    status: PaymentItemStatus.final_price,
  )
];

class _MyHomePageState extends State<MyHomePage> {
  final paybutton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: _paymentItems,
    // type: GooglePayButtonType.buy,
    margin: const EdgeInsets.only(bottom: 50),
    width: 300,
    onPaymentResult: (result) {
      print('\x1b[43;1mpayment result keys = ${result.keys}\x1b[0m');
      print('\x1b[43;1mpayment result = ${json.encode(result)}\x1b[0m');
    },
    loadingIndicator: const Center(
      child: CupertinoActivityIndicator(),
    ),
  );

  late final richModel = RichModel(); //..addListener(() => setState(() {}));
  var showPay = false;

  BannerAd? _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAd(AdSize.largeBanner, 'ca-app-pub-3738593047663437/5682639656');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CupertinoNavigationBar(
      //   // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   middle: Text(title),
      // ),
      // backgroundColor: Colors.black26,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(richModel.title),
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    showPay
                        ? paybutton
                        // Image.asset('assets/rich.png')
                        : GestureDetector(
                            onTap: () => setState(() {
                              showPay ^= true;
                              // richModel.isRich = showPay;
                            }),
                            child: Image.asset(
                              'assets/coal@2x.png',
                              fit: BoxFit.cover,
                              // scale: 0.75,
                            ),
                          ),
                    Text.rich(
                        TextSpan(children: [
                          TextSpan(text: richModel.indicator[0]),
                          TextSpan(
                              text: richModel.indicator[1],
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => setState(() {
                                      richModel.isRich ^= true;
                                      showPay ^= true;
                                    }),
                              style: TextStyle(color: Colors.red)),
                          TextSpan(text: richModel.indicator[2]),
                        ]),
                        textAlign: TextAlign.center,
                        style: _contentStyle()),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Text(
                      richModel.question,
                      style: TextStyle(
                          fontFamily: 'RockSalt',
                          fontSize: 32,
                          color: richModel.richColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: CupertinoTheme.of(context).barBackgroundColor,
        height: AdSize.largeBanner.height.toDouble(),
        child: Offstage(
          offstage: _bannerAd == null,
          child: _bannerAd == null ? Placeholder() : AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }

  TextStyle _contentStyle({Color? color, double fontSize = 60}) {
    return TextStyle(
      fontFamily: 'JosefinSans',
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  /// Loads a banner ad.
  void _loadAd(AdSize adSize, String adUnitId) {
    final bannerAd = BannerAd(
      size: adSize,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }
}

class RichModel with ChangeNotifier {
  var _isRich = false;
  bool get isRich => _isRich;
  set isRich(bool v) {
    _isRich = v;
    _isRich ? rich() : poor();
  }

  var title = 'I Am Poor';
  var question = 'Are you poor';
  var indicator = ['Click ', 'coral', ' to become rich'];
  Color richColor = Colors.grey;
  void poor() {
    title = 'I Am Poor';
    question = 'Are you poor';
    indicator = ['Click ', 'coral', ' to become rich'];
    richColor = Colors.grey;
    notifyListeners();
  }

  void rich() {
    title = 'I Am Rich';
    question = 'You are rich';
    indicator = ['Click ', 'here', ' to bankrupt'];
    richColor = const Color(0xffFFDF00);
    notifyListeners();
  }
}
