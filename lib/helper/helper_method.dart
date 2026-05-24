import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime dataTime = timestamp.toDate();

  String year = dataTime.year.toString();

  String month = dataTime.month.toString();

  String day = dataTime.day.toString();

  String formattedData = '$day/$month/$year';

  return formattedData;
}
