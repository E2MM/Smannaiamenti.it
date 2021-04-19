import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smannaiamenti/pages/smannaiamenti.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("it_IT");
  Intl.defaultLocale = "it_IT";
  runApp(SmannaiamentiApp());
}
