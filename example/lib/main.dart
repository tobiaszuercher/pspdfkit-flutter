///
///  Copyright © 2018-2019 PSPDFKit GmbH. All rights reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.
///
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pspdfkit_flutter/pspdfkit_global.dart';
import 'package:pspdfkit_flutter/pspdfkit_widget.dart';

const String _documentPath = 'PDFs/PSPDFKit.pdf';
const String _lockedDocumentPath = 'PDFs/protected.pdf';
const String _imagePath = 'PDFs/PSPDFKit_Image_Example.jpg';
const String _formPath = 'PDFs/Form_example.pdf';
const String _instantDocumentJsonPath = 'PDFs/Instant/instant-document.json';
const String _pspdfkitFlutterPluginTitle = 'PSPDFKit Flutter Plugin example app';
const String _basicExample = 'Basic Example';
const String _basicExampleSub = 'Opens a PDF Document.';
const String _imageDocument = 'Image Document';
const String _imageDocumentSub = 'Opens an image document.';
const String _darkTheme = 'Dark Theme';
const String _darkThemeSub = 'Opens a document in night mode with custom dark theme.';
const String _customConfiguration = 'Custom configuration options';
const String _customConfigurationSub = 'Opens a document with custom configuration options.';
const String _passwordProtectedDocument = 'Opens and unlocks a password protected document';
const String _passwordProtectedDocumentSub = 'Programmatically unlocks a password protected document.';
const String _formExample = 'Programmatic Form Filling Example';
const String _formExampleSub = 'Programmatically set and get the value of a form field.';
const String _importInstantJsonExample = 'Import Instant Document JSON';
const String _importInstantJsonExampleSub = 'Shows how to programmatically import Instant Document JSON.';
const String _widgetExampleFullScreen = 'PSPDFKit Widget Example (Fullscreen)';
const String _widgetExampleFullScreenSub = 'Opens a PDF Document in the widget with a full screen presentation.';
const String _widgetExampleEmbedded = 'PSPDFKit Widget Example (Embedded)';
const String _widgetExampleEmbeddedSub = 'Opens a PDF Document in the widget embedded with another widget.';
const String _pspdfkitFor = 'PSPDFKit for';
const double _fontSize = 21.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoApp(home: HomePage());
    } else {
      return MaterialApp(home: HomePage());
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _frameworkVersion = '';

  Future<File> extractAsset(String assetPath) async {
    final ByteData bytes = await DefaultAssetBundle.of(context).load(assetPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final Directory tempDir = await getTemporaryDirectory();
    final String tempDocumentPath = '${tempDir.path}/$assetPath';

    final File file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return file;
  }

  void pushPspdfWidgetFullScreen() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        Navigator.of(context).push<dynamic>(CupertinoPageRoute<dynamic>(builder: (_) => 
          CupertinoPageScaffold(child: PspdfWidget(documentPath: extractedDocument.path))));
      } else {
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (_) => 
          Scaffold(body: Center(child: PspdfWidget(documentPath: extractedDocument.path)))));
      }
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void pushPspdfWidgetEmbedded() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        Navigator.of(context).push<dynamic>(CupertinoPageRoute<dynamic>(builder: (_) => 
          CupertinoPageScaffold(child:Column(children: <Widget>[
            Expanded(child: PspdfWidget(documentPath: extractedDocument.path)),
            Expanded(child: Container(color: Colors.green)),
        ]))));
      } else {
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (_) => 
          Scaffold(body: Center(child: Column(children: <Widget>[
            Expanded(child: PspdfWidget(documentPath: extractedDocument.path)),
            Expanded(child: Container(color: Colors.green)),
        ])))));
      }
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void showDocument() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      Pspdfkit.present(extractedDocument.path);
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void showImage() async {
    try {
      final File extractedImage = await extractAsset(_imagePath);
      Pspdfkit.present(extractedImage.path);
    } on PlatformException catch (e) {
      print("Failed to present image document: '${e.message}'.");
    }
  }

  void applyDarkTheme() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      Pspdfkit.present(extractedDocument.path, {
        appearanceMode: appearanceModeNight,
        androidDarkThemeResource: 'PSPDFKit.Theme.Example.Dark'
      });
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void applyCustomConfiguration() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      Pspdfkit.present(extractedDocument.path, {
        pageScrollDirection: pageScrollDirectionVertical,
        pageScrollContinuous: false,
        fitPageToWidth: true,
        androidImmersiveMode: false,
        userInterfaceViewMode: userInterfaceViewModeAutomaticBorderPages,
        androidShowSearchAction: true,
        inlineSearch: false,
        showThumbnailBar: showThumbnailBarFloating,
        androidShowThumbnailGridAction: true,
        androidShowOutlineAction: true,
        androidShowAnnotationListAction: true,
        showPageNumberOverlay: false,
        showPageLabels: true,
        showDocumentLabel: false,
        invertColors: false,
        grayScale: false,
        startPage: 2,
        enableAnnotationEditing: true,
        enableTextSelection: false,
        androidEnableBookmarkList: false,
        androidEnableDocumentEditor: false,
        androidShowShareAction: true,
        androidShowPrintAction: false,
        showDocumentInfoView: true,
        appearanceMode: appearanceModeDefault,
        androidDefaultThemeResource: 'PSPDFKit.Theme.Example',
        iOSRightBarButtonItems:['thumbnailsButtonItem', 'activityButtonItem', 'searchButtonItem', 'annotationButtonItem'],
        iOSLeftBarButtonItems:['settingsButtonItem'],
        iOSAllowToolbarTitleChange: false,
        toolbarTitle: 'Custom Title',
        androidSettingsMenuItems:['theme', 'scrolldirection'],
        iOSSettingsMenuItems:['scrollDirection', 'pageTransition', 'appearance', 'brightness', 'pageMode', 'spreadFitting'],
        showActionNavigationButtons: false,
        iOSShowActionNavigationButtonLabels: false,
        pageLayoutMode: 'double',
        isFirstPageAlwaysSingle: true
      });
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void unlockPasswordProtectedDocument() async {
    try {
      final File extractedLockedDocument = await extractAsset(_lockedDocumentPath);
      Pspdfkit.present(extractedLockedDocument.path, {
        password: 'test123'
      });
    } on PlatformException catch (e) {
      print("Failed to present document: '${e.message}'.");
    }
  }

  void showFormDocumentExample() async {
    try {
      final File formDocument = await extractAsset(_formPath);
      await Pspdfkit.present(formDocument.path);
    } on PlatformException catch(e) {
      print("Failed to present document: '${e.message}'.");
    }

    try {
      Pspdfkit.setFormFieldValue("Lastname", "Name_Last");
      Pspdfkit.setFormFieldValue("0123456789", "Telephone_Home");
      Pspdfkit.setFormFieldValue("City", "City");
      Pspdfkit.setFormFieldValue("selected", "Sex.0");
      Pspdfkit.setFormFieldValue("deselected", "Sex.1");
      Pspdfkit.setFormFieldValue("selected", "HIGH SCHOOL DIPLOMA");
    } on PlatformException catch(e) {
      print("Failed to set form field values '${e.message}'.");
    }

    String lastName;
    try {
      lastName = await Pspdfkit.getFormFieldValue("Name_Last");
    } on PlatformException catch(e) {
      print("Failed to get form field value '${e.message}'.");
    }

    if (lastName != null) {
      print("Retrieved form field for fully qualified name \"Name_Last\" is $lastName.");
    }
  }

  void importInstantJsonExample() async {
    try {
      final File extractedDocument = await extractAsset(_documentPath);
      await Pspdfkit.present(extractedDocument.path);
    } on PlatformException catch(e) {
      print("Failed to present document: '${e.message}'.");
    }

    // Extract a string from a file.
    final String annotationsJson = await DefaultAssetBundle.of(context).loadString(_instantDocumentJsonPath);

    try {
      Pspdfkit.applyInstantJson(annotationsJson);
    } on PlatformException catch(e) {
      print("Failed to import Instant Document JSON '${e.message}'.");
    }
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  String frameworkVersion() {
    return '$_pspdfkitFor $_frameworkVersion\n';
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    String frameworkVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      frameworkVersion = await Pspdfkit.frameworkVersion;
    } on PlatformException {
      frameworkVersion = 'Failed to get platform version. ';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _frameworkVersion = frameworkVersion;
    });

    Pspdfkit.setLicenseKey("LICENSE_KEY_GOES_HERE");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      var title = themeData.textTheme.title;
      var subhead = themeData.textTheme.subhead;
      var crossAxisAlignment = CrossAxisAlignment.start;
      var padding = EdgeInsets.all(16.0);
      List<Widget> cupertinoListTiles = <Widget>[
        Divider(),
        GestureDetector(
          onTap: showDocument,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_basicExample, style: title),
                Text(_basicExampleSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: showImage,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_imageDocument, style: title),
                Text(_imageDocumentSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: applyDarkTheme,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_darkTheme, style: title),
                Text(_darkThemeSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: applyCustomConfiguration,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_customConfiguration, style: title),
                Text(_customConfigurationSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: unlockPasswordProtectedDocument,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_passwordProtectedDocument, style: title),
                Text(_passwordProtectedDocumentSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: showFormDocumentExample,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_formExample, style: title),
                Text(_formExampleSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: importInstantJsonExample,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_importInstantJsonExample, style: title),
                Text(_importInstantJsonExampleSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: pushPspdfWidgetFullScreen,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_widgetExampleFullScreen, style: title),
                Text(_widgetExampleFullScreenSub, style: subhead)
              ])),
        ),
        Divider(),
        GestureDetector(
          onTap: pushPspdfWidgetEmbedded,
          child: Container(
              color: Colors.transparent,
              padding: padding,
              child: Column(crossAxisAlignment: crossAxisAlignment, children: [
                Text(_widgetExampleEmbedded, style: title),
                Text(_widgetExampleEmbeddedSub, style: subhead)
              ])),
        ),
        Divider()
      ];
      return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(_pspdfkitFlutterPluginTitle, style: themeData.textTheme.title)),
              child: SafeArea(
                bottom: false,
                child: ExampleListView(themeData, frameworkVersion(), cupertinoListTiles))
              );
    } else {
      List<Widget> listTiles = <Widget>[
        ListTile(
            title: Text(_basicExample),
            subtitle: Text(_basicExampleSub),
            onTap: () => showDocument()),
        Divider(),
        ListTile(
            title: Text(_imageDocument),
            subtitle: Text(_imageDocumentSub),
            onTap: () => showImage()),
        Divider(),
        ListTile(
            title: Text(_darkTheme),
            subtitle: Text(_darkThemeSub),
            onTap: () => applyDarkTheme()),
        Divider(),
        ListTile(
            title: Text(_customConfiguration),
            subtitle: Text(_customConfigurationSub),
            onTap: () => applyCustomConfiguration()),
        Divider(),
        ListTile(
            title: Text(_passwordProtectedDocument),
            subtitle: Text(_passwordProtectedDocumentSub),
            onTap: () => unlockPasswordProtectedDocument()),
        Divider(),
        ListTile(
            title: Text(_formExample),
            subtitle: Text(_formExampleSub),
            onTap: () => showFormDocumentExample()),
        Divider(),
        ListTile(
            title: Text(_importInstantJsonExample),
            subtitle: Text(_importInstantJsonExampleSub),
            onTap: () => importInstantJsonExample()),
        Divider(),
      ];
      return Scaffold(
              appBar: AppBar(title: Text(_pspdfkitFlutterPluginTitle)),
              body: ExampleListView(themeData, frameworkVersion(), listTiles)
            );
    }
  }
}

class ExampleListView extends StatelessWidget {
  final ThemeData _themeData;
  final String _frameworkVersion;
  final List<Widget> _listTiles;

  ExampleListView(this._themeData, this._frameworkVersion, this._listTiles);

  @override
  Widget build(BuildContext buildContext) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        color: Colors.black12,
        padding: EdgeInsets.only(top: 24),
        child: Center(
          child: Text(_frameworkVersion,
              style: _themeData.textTheme.display1
                  .copyWith(fontSize: _fontSize, fontWeight: FontWeight.bold)),
        ),
      ),
      Expanded(
          child: Container(child: ListView(children: _listTiles)))
    ]);
  }
}
