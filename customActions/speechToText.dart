import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

Future speechToText() async {
  String output = '';
  final SpeechToText speech = SpeechToText();

  bool isInitialized = await speech.initialize();
  FFAppState().stt = '';
  if (isInitialized) {
    speech.listen(
      onResult: (result) {
        if (!result.finalResult) {
          FFAppState().update(() {
            FFAppState().btnTalk = 'listening...';
            FFAppState().stt = '${result.recognizedWords}';
          });
        } else {
          FFAppState().update(() {
            output = '${result.recognizedWords}';
            FFAppState().sstSendText = '${result.recognizedWords}';
            FFAppState().btnTalk = 'Talk';
          });
        }
      },
      partialResults: true,
      cancelOnError: true,
      listenFor: Duration(seconds: 6),
    );
  }
}