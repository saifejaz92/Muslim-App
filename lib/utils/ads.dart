import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  void initState() {
    super.initState();
    initbannerAd();
  }

  late BannerAd bannerAd;
  bool isLoaded = false;
  bool isloading = true;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";

  initbannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            isloading = false;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          Fluttertoast.showToast(msg: "Ad Error $error");
        }),
        request: const AdRequest());

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: isLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : const Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }
}
