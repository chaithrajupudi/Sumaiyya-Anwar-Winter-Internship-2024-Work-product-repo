import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'catalog_confirmation_page_model.dart';
export 'catalog_confirmation_page_model.dart';

class CatalogConfirmationPageWidget extends StatefulWidget {
  const CatalogConfirmationPageWidget({super.key});

  @override
  State<CatalogConfirmationPageWidget> createState() =>
      _CatalogConfirmationPageWidgetState();
}

class _CatalogConfirmationPageWidgetState
    extends State<CatalogConfirmationPageWidget> {
  late CatalogConfirmationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CatalogConfirmationPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFFF4B400),
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context).getText(
              'wl3r6jgg' /* Creation  Confirmed */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 30,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 878,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFFF4B400),
                      size: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
