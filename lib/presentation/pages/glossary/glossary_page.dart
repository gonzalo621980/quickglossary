import 'package:quickglossary/core/enum/enum_color.dart';
import 'package:quickglossary/core/helper.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:quickglossary/presentation/pages/home/home_page.dart';
import 'package:quickglossary/presentation/widgets/card_cabecera.dart';
import 'package:quickglossary/presentation/widgets/floating_button_widget.dart';
import 'package:quickglossary/presentation/widgets/form_input_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickglossary/presentation/widgets/msj_confirmacion.dart';
import 'package:quickglossary/presentation/bloc/glossary/bloc.dart';
import 'package:quickglossary/presentation/widgets/loading_widget.dart';
import 'package:quickglossary/injection_container.dart';

class GlossaryPage extends StatefulWidget {
  final AssetImage backgroundImage = new AssetImage("assets/images/background.png");

  GlossaryPage({Key key}) : super(key: key);

  @override
  _GlossaryPageState createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  BuildContext contextPage;
  Word word = new Word();

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
          child: BlocProvider<GlossaryBloc>(
            create: (_) => sl<GlossaryBloc>(),
            child: BlocConsumer<GlossaryBloc, GlossaryState>(listener: (context, state) {
              this.contextPage = context;

              if (state is GoToHome) {
                Navigator.of(this.contextPage).pop();
                final route = MaterialPageRoute(builder: (context) => HomePage());
                Navigator.of(this.contextPage).push(route);
              }
            }, builder: (context, state) {
              this.contextPage = context;
              if (state is Empty) {
                BlocProvider.of<GlossaryBloc>(this.contextPage).add(GetReload(word: new Word()));
                return SizedBox(height: 0);
              } else if (state is Loading) {
                return LoadingWidget();
              } else if (state is Loaded) {
                this.word = state.word;
                return _getControles(word: this.word, confirmation: state.confirmation);
              } else if (state is ListAll) {
                return _getControlesList(words: state.words);
              } else if (state is Invalid) {
                Color colorFont = Colors.grey;
                if (state.code == "UNKNOWN_WORD") {
                  colorFont = Colors.red;
                  this.word = state.word;
                  return _getControles(word: this.word, fontColor: colorFont);
                }
                //muestro mensaje de validacion y reacargo la pantalla
                return MsjConfirmacion(
                    titulo: "Aviso",
                    mensaje: state.message,
                    onAceptar: (BuildContext context, String data) {
                      BlocProvider.of<GlossaryBloc>(this.contextPage).add(GetReload(word: state.word));
                    });
              } else if (state is Error) {
                //muestro mensaje de error y reacargo la pantalla
                return MsjConfirmacion(
                    titulo: "Error",
                    mensaje: state.message,
                    onAceptar: (BuildContext context, String data) {
                      BlocProvider.of<GlossaryBloc>(this.contextPage).add(GetReload(word: new Word()));
                    });
              } else {
                return SizedBox(height: 0);
              }
            }),
          ),
        ));
  }

  Widget _getControles({Word word, Color fontColor = Colors.black, bool confirmation = false}) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(height: 5),
      titleWords(word.englishText),
      SizedBox(height: 20),
      textCategory(),
      SizedBox(height: 10),
      textEnglishText(fontColor),
      SizedBox(height: 10),
      textSpanishText(),
      SizedBox(height: 10),
      textPronunciation(),
      SizedBox(height: 10),
      textDDefinition(),
      SizedBox(height: 30),
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [buttonHome(), buttonReadAll(), buttonRead(), buttonWrite(), buttonDelete(confirmation)],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ))
    ]);
  }

  Widget _getControlesList({List<Word> words}) {
    List<Widget> list = [];
    list.add(SizedBox(height: 5));
    list.add(titleWords(word.englishText));
    list.add(SizedBox(height: 20));
    words.forEach((Word word) {
      int score = Helper.getScore(word);
      list.add(ListTile(
          title: Text(word.englishText + " (" + word.category + ")" + " [" + score.toString() + "]"),
          tileColor: EnumColor.primaryColor));
    });
    list.add(SizedBox(height: 30));
    list.add(Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          children: [buttonReturn()],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )));

    return Container(
        height: MediaQuery.of(context).size.height, // Fixed height
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.max, children: list)));
  }

  Widget buttonReturn() {
    return FloatingButtonWidget(
        icon: Icons.arrow_back,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(contextPage).add(GetRead(word: new Word()));
        });
  }

  Widget buttonHome() {
    return FloatingButtonWidget(
        icon: Icons.arrow_back,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(contextPage).add(GetHome());
        });
  }

  Widget buttonReadAll() {
    return FloatingButtonWidget(
        icon: Icons.manage_search,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        word: this.word,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(context).add(GetReadAll());
        });
  }

  Widget buttonRead() {
    return FloatingButtonWidget(
        icon: Icons.search,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        word: this.word,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(context)
              .add(GetRead(word: new Word(englishText: word.englishText, category: word.category)));
        });
  }

  Widget buttonWrite() {
    return FloatingButtonWidget(
        icon: Icons.save,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        word: this.word,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(context).add(GetWrite(word: word));
        });
  }

  Widget buttonDelete(bool confirmation) {
    Color colorButton = confirmation ? Colors.red : EnumColor.secondaryColor;
    return FloatingButtonWidget(
        icon: Icons.delete,
        iconColor: Colors.white,
        backgroundColor: colorButton,
        contextParent: this.contextPage,
        word: this.word,
        onClickAction: (context, word) {
          BlocProvider.of<GlossaryBloc>(context).add(GetDelete(word: word, confirmation: confirmation));
        });
  }

  Widget titleWords(String wordName) {
    return CardCabecera(
        titulo: "Glossary",
        subtitulo: "Word: " + wordName,
        icono: Icon(Icons.workspaces_outlined, color: Colors.grey, size: 40));
  }

  Widget textEnglishText(Color fontColor) {
    return FormInputImageWidget(
        icon: Icons.format_textdirection_l_to_r_outlined,
        initValue: this.word.englishText,
        hint: 'English Text',
        colorFont: fontColor,
        onChanged: (value) => {this.word.englishText = value});
  }

  Widget textSpanishText() {
    return FormInputImageWidget(
        icon: Icons.format_textdirection_r_to_l_outlined,
        initValue: this.word.spanishText,
        hint: 'Spanish Text',
        onChanged: (value) => {this.word.spanishText = value});
  }

  Widget textCategory() {
    final List<String> _options = [
      '',
      'Pron./Prepos.',
      'Verb',
      'Adjective',
      'Animal',
      'Meal',
      'Clothes',
      'Trasnport',
      'Thing',
      'Others'
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.align_horizontal_left_sharp,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: DropdownButton<String>(
              style: TextStyle(color: Colors.black, fontSize: 21.0),
              isExpanded: true,
              elevation: 4,
              value: this.word.category,
              onChanged: (String newValue) {
                setState(() {
                  this.word.category = newValue;
                });
              },
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: (value.length == 0) ? Text('Category', style: TextStyle(color: Colors.grey)) : Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget textPronunciation() {
    return FormInputImageWidget(
        icon: Icons.campaign_sharp,
        initValue: this.word.pronunciation,
        hint: 'Pronunciation',
        onChanged: (value) => {this.word.pronunciation = value});
  }

  Widget textDDefinition() {
    return FormInputImageWidget(
        icon: Icons.check_outlined,
        initValue: this.word.definition,
        hint: 'Definition',
        multiline: true,
        onChanged: (value) => {this.word.definition = value});
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
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
