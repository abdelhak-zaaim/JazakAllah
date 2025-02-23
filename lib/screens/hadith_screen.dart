import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../constants.dart';

class HadithListView extends StatefulWidget {
  const HadithListView({Key? key}) : super(key: key);

  @override
  State<HadithListView> createState() => _HadithListViewState();
}

class _HadithListViewState extends State<HadithListView> {
  List _hadit = [];

  final PageController controller = PageController();

  void onPageChanged(int index) {
    controller.jumpToPage(index);
  }

  Future<void> readJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language');
    String jsonAssetPath = 'assets/hadit.json';

    if (language == 'en') {
      jsonAssetPath = 'assets/hadit.json';
    } else if (language == 'ar') {
      jsonAssetPath = 'assets/hadit.json';
    }

    final String response = await rootBundle.loadString(jsonAssetPath);
    final data = await json.decode(response);
    setState(() {
      _hadit = data['items'];
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/secondary_background.png"),
              fit: BoxFit.fill,
            )),
            child: Stack(children: <Widget>[
              Positioned(
                  top: 45.h,
                  left: 20.w,
                  right: 16.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Text(
                          'hadith'.tr,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                top: 70.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  height: 450.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    //color: AppColors.colorPrimaryLight
                  ),
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    itemCount: _hadit.length,
                    itemBuilder: (context, index) {
                      final randomIndex = Random().nextInt(_hadit.length);
                      final item = _hadit[randomIndex];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 36.0),
                              child: Text(
                                item['textArabic'],
                                style: TextStyle(
                                    color: AppColors.colorWhiteHighEmp,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Text(
                                item['textEnglish'],
                                style: TextStyle(
                                    color: AppColors.colorWhiteMidEmp,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(height: 26.h),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Text(
                                item['reference'],
                                style: TextStyle(
                                    color: AppColors.colorWhiteMidEmp,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      onPageChanged((controller.page ?? 0).round() + 1);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      height: 50.h,
                      width: 96.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.colorButtonGradientStart,
                            AppColors.colorButtonGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.colorWhiteHighEmp,
                          size: 24,
                        ),
                      ),
                    ),
                  ))
            ])),
      ),
    );
  }
}
