import 'dart:io';

import 'package:quickglossary/core/enum/enum_color.dart';
import 'package:quickglossary/core/helper.dart';
import 'package:quickglossary/presentation/pages/glossary/glossary_page.dart';
import 'package:quickglossary/presentation/pages/trivia/trivia_page.dart';
import 'package:quickglossary/presentation/widgets/card_cabecera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickglossary/presentation/widgets/floating_button_widget.dart';
import 'package:quickglossary/presentation/widgets/msj_confirmacion.dart';
import 'package:quickglossary/presentation/bloc/home/bloc.dart';
import 'package:quickglossary/presentation/widgets/form_button_widget.dart';
import 'package:quickglossary/presentation/widgets/loading_widget.dart';
import 'package:quickglossary/injection_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  final AssetImage backgroundImage = new AssetImage("assets/images/background.png");

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  BuildContext contextPage;
  String fileContent = "";
  int countWords = -1;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: EnumColor.backgroundColor,
          ),
          child: BlocProvider<HomeBloc>(
            create: (_) => sl<HomeBloc>(),
            child: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
              this.contextPage = context;

              if (state is GoToGlossary) {
                Navigator.of(this.contextPage).pop();
                final route = MaterialPageRoute(builder: (context) => GlossaryPage());
                Navigator.of(this.contextPage).push(route);
              } else if (state is GoToTrivia) {
                Navigator.of(this.contextPage).pop();
                final route = MaterialPageRoute(builder: (context) => TriviaPage());
                Navigator.of(this.contextPage).push(route);
              } else if (state is Imported) {
                BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
              } else if (state is Exported) {
                this.fileContent = state.data;
                _exportBackup();
              }
            }, builder: (context, state) {
              this.contextPage = context;
              if (state is Empty) {
                BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
                return SizedBox(height: 0);
              } else if (state is Loading) {
                return LoadingWidget();
              } else if (state is Loaded) {
                this.countWords = state.countWords;
                return _getControles(this.countWords);
              } else if (state is Error) {
                return MsjConfirmacion(
                    titulo: "Error",
                    mensaje: state.message,
                    onAceptar: (BuildContext context, String data) {
                      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
                    });
              } else {
                return SizedBox(height: 0);
              }
            }),
          ),
        ));
  }

  Widget _getControles(int countWords) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        imagenTitleWidget(),
        SizedBox(height: 5),
        titleWords(countWords),
        SizedBox(height: 60),
        buttonGlossary(),
        SizedBox(height: 5),
        buttonTrivia(),
        SizedBox(height: 50),
        Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: [buttonImport(), SizedBox(width: 10), buttonExport()],
              mainAxisAlignment: MainAxisAlignment.end,
            ))
      ],
    );
  }

  Widget imagenTitleWidget() {
    return new ClipPath(
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: this.widget.backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 60.0, bottom: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Quick Glossary",
              textAlign: TextAlign.center,
              style: TextStyle(shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.white.withOpacity(0.7),
                  offset: Offset(2.0, 2.0),
                ),
              ], fontSize: 40.0, fontWeight: FontWeight.w500, color: EnumColor.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonGlossary() {
    return FormButtonWidget(
        primaryColor: EnumColor.secondaryColor,
        textColor: Colors.white,
        icon: Icons.arrow_forward,
        text: 'Glossary',
        onClickAction: (context) {
          BlocProvider.of<HomeBloc>(this.contextPage).add(GetGlossary());
        });
  }

  Widget buttonTrivia() {
    return FormButtonWidget(
        primaryColor: EnumColor.secondaryColor,
        textColor: Colors.white,
        icon: Icons.arrow_forward,
        text: 'Trivia',
        onClickAction: (context) {
          BlocProvider.of<HomeBloc>(this.contextPage).add(GetTrivia());
        });
  }

  Widget titleWords(int countWords) {
    return CardCabecera(
        titulo: "Level Glossary",
        subtitulo: "Words counter: " + countWords.toString(),
        icono: Icon(Icons.workspaces_outlined, color: Colors.grey, size: 40));
  }

  Widget buttonImport() {
    return FloatingButtonWidget(
        icon: Icons.download,
        title: "Import backup",
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        onClickAction: (context, word) {
          _importBackup();
        });
  }

  Widget buttonExport() {
    return FloatingButtonWidget(
        icon: Icons.upload,
        title: "Export backup",
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        onClickAction: (context, word) {
          BlocProvider.of<HomeBloc>(context).add(GetExport());
        });
  }

  // Request permissions for storage access
  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      print('Storage permission granted');
    } else {
      setState(() {
        fileContent = "Permission denied!";
      });
    }
  }

  Future<void> _importBackup() async {
    await _requestPermission();

    FilePickerResult result = await FilePicker.platform.pickFiles(dialogTitle: "Import backup");
    if (result == null) {
      print("Path is empty.");
      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
      return;
    }

    try {
      String filePath = result.files.single.path;
      File file = File(filePath);
      this.fileContent = await file.readAsString();
      if (this.fileContent.isNotEmpty) {
        BlocProvider.of<HomeBloc>(this.contextPage).add(GetImport(this.fileContent));
      }
    } catch (e) {
      print("Failed to read file: '${e.message}'.");
      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
      return;
    }
  }

  Future<void> _exportBackup() async {
    await _requestPermission();

    Directory result = await FolderPicker.pick(
        allowFolderCreation: true,
        context: this.contextPage,
        rootDirectory: Directory(FolderPicker.ROOTPATH),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))));
    if (result == null) {
      print("Path is empty.");
      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
      return;
    }

    try {
      if (this.fileContent.isNotEmpty) {
        String fileName = Helper.getTimestamp().toString();
        String filePath = result.path + "/quickglossary_$fileName.backup";
        File file = File(filePath);
        await file.writeAsString(this.fileContent, flush: true);
      }
      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
    } catch (e) {
      print("Failed to write file: '${e.message}'.");
      BlocProvider.of<HomeBloc>(this.contextPage).add(GetReload());
      return;
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height);
    p.arcToPoint(
      Offset(0.0, size.height),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
