import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manager_getxcli/app/model/chapter_model.dart';
import 'package:manager_getxcli/app/model/comic_model.dart';
import 'package:manager_getxcli/app/model/page_model.dart';
import 'package:manager_getxcli/app/modules/home/flareController.dart';
import 'package:manager_getxcli/app/repository/home_repository.dart';

enum StatePage { comic, chapter, download, downloads }

class HomeController extends GetxController {
  TextEditingController commandCtr = TextEditingController();
  WareController wareController = WareController();
  OpenController openController = OpenController();
  FlareDLController dlController = FlareDLController();

  final count = 0.obs;
  var comics = List<ComicModel>().obs;
  var chapters = List<ChapterModel>().obs;
  var stateCurrent = StatePage.comic.obs;
  var downloads = List<PageModel>().obs;
  var nameDownloadCurrentChapter = "Chapter".obs;
  var namePageCompleted = ''.obs;
  var isDownload = true.obs;

  final HomeRepository repository;

  HomeController({@required this.repository}) {}

  increment() {
    wareController.increament();
  }

  xuLyText(String text) async {
    text = text.toLowerCase();

    if (isContainAll(['find', 'comic'], text)) {
      stateCurrent.value = StatePage.comic;
      //thuc hien trong nay neu co
      String words = text.split('comic')[1];
      words = words.trim().toLowerCase();
      comics.value = await repository.getComicFromText(words);
    } else if (isContainAll(['comic', 'name'], text)) {
      stateCurrent.value = StatePage.chapter;
      String words = text.split('"')[1].trim().toLowerCase();
      var comic = comics.firstWhere((comic) =>comic.name.trim().toLowerCase() == words );

      chapters.value = await repository.getChapterFromUrl(comic.url);
    } else if (isContainOr(['download', 'dowload'], text) &&
        isContainAll(['chapter', 'to'], text)) {
      stateCurrent.value = StatePage.download;
      var words = text.split('"');
      if (words.length != 5) {
        printError(info: "Loi nhap thieu command");
        return null;
      }
      var nameFrom = words[1].toLowerCase().trim();
      var nameTo = words[3].toLowerCase().trim();
      //get index
      var indexFrom = chapters
          .indexWhere((chapter) => chapter.name.toLowerCase() == nameFrom);
      var indexTo = chapters
          .indexWhere((chapter) => chapter.name.toLowerCase() == nameTo);
      if (indexFrom > indexTo) {
        var temp = indexTo;
        indexTo = indexFrom;
        indexFrom = temp;
      }

      isDownload.value = true;
      for (var i = indexFrom; i < indexTo + 1; i++) {
        printInfo(info: 'Dang tai chapter ${chapters[i].name}');
        nameDownloadCurrentChapter.value = chapters[i].name;
        await repository.downloadChapter(chapters[i], (PageModel page) {
          var indexFinded = downloads.indexWhere((dd) => page.name == dd.name);
          if (indexFinded < 0) namePageCompleted.value = page.name;
        });
        downloads.clear();
        printInfo(info: 'Hoan thanh viec chapter ${chapters[i].name}');
        namePageCompleted.value = "Completed";
        isDownload.value = false;
      }
    } else if (isContainOr(['download', 'dowload'], text) &&
        isContainAll(['chapter'], text)) {
      stateCurrent.value = StatePage.download;
      String words = text.split('"')[1].trim();
      for (var chapterItem in chapters.value) {
        if (chapterItem.name.toLowerCase() == words) {
          nameDownloadCurrentChapter.value = chapterItem.name;
          await repository.downloadChapter(chapterItem, (PageModel page) {
            var pageFinded = downloads.indexWhere((m) => page.name == m.name);
            if (pageFinded < 0) downloads.add(page);
          });
          printInfo(info: 'Download xong chapter ${chapterItem.name}');
          break;
        }
      }
    }
  }

  bool isContainAll(List<String> data, String content) {
    int count = 0;
    data.forEach((element) {
      if (content.contains(element)) count++;
    });
    if (count == data.length)
      return true;
    else
      return false;
  }

  bool isContainOr(List<String> data, String content) {
    bool findedOr = false;
    data.forEach((element) {
      if (content.contains(element)) {
        printInfo(info: "True with " + data.toString());
        findedOr = true;
      }
    });
    printInfo(info: "False with " + data.toString());
    return findedOr;
  }

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}
}
