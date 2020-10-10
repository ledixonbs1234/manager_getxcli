import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:manager_getxcli/app/model/chapter_model.dart';
import 'package:http/http.dart' as http;
import 'package:manager_getxcli/app/model/comic_model.dart';
import 'package:dio/dio.dart';
import 'package:manager_getxcli/app/model/page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeRepository {
  Future<Document> getDocumentWeb(String url) async {
    final response = await http.Client().get(Uri.parse(url));

    if (response.statusCode != 200) {
      return null;
    }
    return parse(response.body);
  }

  downloadChapter(ChapterModel chapter, callback) async {
    printInfo(info: 'Start downloadChapter ${chapter.name}');
    await checkPermission();

    var urlImages = await getUrlImageFromUrlChapter(chapter.url);
    String progress = "";
    var folder = await createFolder(chapter.nameComic);
    var dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
      options.headers['referer'] = 'http://www.nettruyen.com/';
    }));
    var count = 1;
    var futures = <Future>[];


     for (var urlImage in urlImages) {
      var nameImage = checkNameUrl(urlImage, count);
      var urlRealPath = "${folder.path}/$nameImage";
      count++;
      var page = PageModel(
          name: nameImage, urlPath: urlImage, urlRealpath: urlRealPath);

      try {
         futures.add( dio.download(
          urlImage,
          urlRealPath,
          onReceiveProgress: (receibyte, totalByte) {
            var progress = ((receibyte / totalByte) * 100) ;
            if(progress > 99){
              page.progess = "Hoan Thanh";
              callback(page);
            }
          },
        ));
      } catch (e) {
        printError(info: nameImage + ' ' + e.toString());
      }
    }
     await Future.wait(futures);
    printInfo(info: 'End downloadChapter ${chapter.name}');
    //   urlImages.forEach((urlImage) async {
    //   var nameImage = checkNameUrl(urlImage, count);
    //   var urlRealPath = "${folder.path}/$nameImage";
    //   count++;
    //   var page = PageModel(
    //       name: nameImage, urlPath: urlImage, urlRealpath: urlRealPath);
    //
    //   try {
    //     await dio.download(
    //       urlImage,
    //       urlRealPath,
    //       onReceiveProgress: (receibyte, totalByte) {
    //         progress = ((receibyte / totalByte) * 100).toStringAsFixed(0) + "%";
    //         page.progess = progress;
    //         callback(
    //           page
    //         );
    //       },
    //     );
    //
    //     printInfo(info:'End downloadChapter ${chapter.name}');
    //   } catch (e) {
    //     printError(info:nameImage+' '+ e.toString());
    //   }
    // });
  }

  String checkNameUrl(String url, int count) {
    if (url.indexOf('.jpg') >= 0)
      return 'image' + count.toString() + '.jpg';
    else if (url.indexOf('png') >= 0)
      return 'image' + count.toString() + '.png';
    else
      return 'image' + count.toString() + '.jpg';
  }

  Future<Directory> createFolder(String name) async {
    Directory folder = await getExternalStorageDirectory();
    return await Directory('${folder.path}/$name').create(recursive: true);
  }

  checkPermission() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      await Permission.storage.request();
    }
  }

  Future<List<String>> getUrlImageFromUrlChapter(String urlChapter) async {
    var document = await getDocumentWeb(urlChapter);
    var chaptersDo = document.getElementsByClassName('page-chapter');
    List<String> urlImages = List<String>();
    chaptersDo.forEach((element) {
      String src = element.getElementsByTagName('img')[0].attributes['src'];
      src = prefixUrl(src);
      urlImages.add(src);
    });
    return urlImages;
  }

  prefixUrl(String url) {
    String newUrl = url.substring(url.indexOf('//') + 2);
    return 'https://' + newUrl;
  }

  Future<List<ComicModel>> getComicFromText(String text) async {
    //Thuc hien lenh trong nay
    var textCross = text.replaceAll(' ', '+');
    var urlPrepage =
        'http://www.nettruyen.com/Comic/Services/SuggestSearch.ashx?q=';
    var url = urlPrepage + textCross;

    var document = await getDocumentWeb(url);
    if (document == null) {
      return null;
    }
    var elements = document.getElementsByTagName('li');
    if (elements.length == 0) {
      return null;
    }

    var comics = List<ComicModel>();
    elements.forEach((element) {
      String name = element.getElementsByTagName('h3')[0].text;
      var imageUrl = 'http://' +
          element
              .getElementsByTagName('img')[0]
              .attributes['src']
              .replaceFirst('//', '');
      var url = element.getElementsByTagName('a')[0].attributes['href'];
      var currentChapter = element.getElementsByTagName('i')[0].text;
      ComicModel comic = ComicModel(
          name: name,
          url: url,
          imageUrl: imageUrl,
          currentChapter: currentChapter);
      comics.add(comic);
    });
    return comics;
  }

  Future<List<ChapterModel>> getChapterFromUrl(String url) async {
    Document document = await getDocumentWeb(url);
    if (document == null) return null;
    var chaptersDo = document.getElementsByClassName('chapter');
    var chapters = List<ChapterModel>();
    var nameComic = document.getElementsByClassName('title-detail')[0].text;
    chaptersDo.forEach((element) {
      var child = element.getElementsByTagName('a')[0];
      String nameChapter = child.text;
      String urlChapter = child.attributes['href'];
      //var date = child.nextElementSibling;
      ChapterModel chapter = ChapterModel(
          name: nameChapter,
          url: urlChapter,
          date: 'nothing',
          nameComic: nameComic);
      chapters.add(chapter);
    });
    return chapters;
  }
}
