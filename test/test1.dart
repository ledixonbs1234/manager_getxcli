void main(){
  var text = "chao cac \"chung ta\" chung toi co dieu can biet";
  var b = ["chao","ban"];
  int count =0;
  expect(text.split(RegExp('"((\W\|\w)+?)"'))[2],'chung ta');
}