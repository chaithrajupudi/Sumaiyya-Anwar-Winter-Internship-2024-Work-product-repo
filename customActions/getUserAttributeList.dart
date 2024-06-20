import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; 
import '/flutter_flow/custom_functions.dart';
import 'package:flutter/material.dart';

String getUserAttributeList() {
  final List<AttributeStruct>? appStateVariable = FFAppState().attributes;

  if (appStateVariable == null) {
    return ''; 
  }

  String result = '';

  for (int i = 0; i < appStateVariable.length; i++) {
    result += appStateVariable[i].name;
    if (i < appStateVariable.length - 1) {
      result += ', ';
    }
  }
  return result;
}