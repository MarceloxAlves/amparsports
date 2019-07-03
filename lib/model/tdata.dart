import 'package:date_format/date_format.dart';

class TDate {

  static DateTime convertStringFromDate(String data){
    DateTime mdata = DateTime.parse(data);
    return mdata;
  }

 static String date_br(String data){
     return formatDate(TDate.convertStringFromDate(data), ["dd", '/', "mm", "/", "yyyy"]);
  }
}