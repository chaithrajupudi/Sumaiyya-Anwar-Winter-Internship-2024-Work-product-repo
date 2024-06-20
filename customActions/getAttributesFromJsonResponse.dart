import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; 
import '/flutter_flow/custom_functions.dart'; 
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';

Future<List<AttributeStruct>?> getAttributesFromJsonResponse(dynamic jsonResponse) async {

  // Get the 'formatted_response' object
  Map<String, dynamic> formattedResponse =
      jsonResponse['results'][0]['formatted_response'];

  // Extract the attributes
  List<String> attributes = [];
  formattedResponse.forEach((key, value) {
    if (value is List<String>) {
      attributes.addAll(value);
    }
  });

  List<AttributeStruct> generatedAttributesList = [];
  for (int i = 0; i < attributes.length; i++) {
    String str = attributes[i];
    AttributeStruct productAttribute = AttributeStruct();
    productAttribute.index = i;
    productAttribute.name = str;
    productAttribute.attributePresent = true;
    generatedAttributesList.add(productAttribute);
  }
  FFAppState().generatedAttributes = generatedAttributesList;
  return generatedAttributesList;
}