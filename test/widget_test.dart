// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manager_getxcli/main.dart';

void main() {
  test("chao", () {
    var text = "chao cac \"chung ta\" chung toi co dieu can biet";
    var b = ["chao","ban"];
    int count =0;
    expect(text.split(RegExp('"((\W\|\w)+?)"'))[2],'chung ta');



  });
}
