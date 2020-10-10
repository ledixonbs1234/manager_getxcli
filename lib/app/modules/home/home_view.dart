import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_getxcli/app/modules/home/flareController.dart';
import 'package:manager_getxcli/app/modules/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  WareController con = WareController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.stateCurrent.value == StatePage.comic) {
                  return Obx(() => getComicView());
                } else if (controller.stateCurrent.value == StatePage.chapter) {
                  return Obx(() => getChapterView());
                } else {
                  return Obx(() => getDownloadView2());
                }
              }),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          controller: controller.commandCtr,
                          onSubmitted: (value){
                            controller.xuLyText(controller.commandCtr.text);
                            controller.commandCtr.text = '';
                          },
                          style: GoogleFonts.roboto(fontSize: 14),
                        )),
                  ),
                  FlatButton(
                    color: Colors.grey,
                    onPressed: () {
                      //controller.commandctr.text = '';
                      controller.increment();
                    },
                    child: Text('Del'),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      controller.xuLyText(controller.commandCtr.text);
                      controller.commandCtr.text = '';
                    },
                    child: Text('Ok'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getDownloadView() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: FlareActor(
        "material/ware.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        controller: controller.wareController,
      ),
    );
  }

  Widget getDownloadView2() {
    return Column(
      children: [
        Text(controller.nameDownloadCurrentChapter.value),
        Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: true,
              itemCount: controller.downloads.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    onTap: () {},
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.downloads[index].name),
                        Text(controller.downloads[index].progess)
                      ],
                    ));
              }),
        ),
      ],
    );
  }

  Widget getComicView() {
    return ListView.builder(
        itemCount: controller.comics.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              onTap: () {
                controller.commandCtr.text = controller.commandCtr.text.trim() +
                    ' ' +
                    controller.comics[index].url;
              },
              onLongPress: () {},
              title: Row(
                children: [
                  Image.network(
                    controller.comics[index].imageUrl,
                    width: 80,
                    height: 110,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            controller.comics[index].name,
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.comics[index].currentChapter,
                            style: GoogleFonts.roboto(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  Widget getChapterView() {
    return ListView.builder(
        itemCount: controller.chapters.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              onTap: () {},
              onLongPress: () {
                controller.commandCtr.text = controller.commandCtr.text.trim() +
                    ' "' +
                    controller.chapters[index].name+'"';
              },
              title: Row(
                children: [Text(controller.chapters[index].name)],
              ));
        });
  }
}
