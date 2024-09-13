import 'package:quickglossary/core/enum/enum_color.dart';
import 'package:quickglossary/core/enum/enum_state_trivia.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:quickglossary/presentation/pages/home/home_page.dart';
import 'package:quickglossary/presentation/widgets/card_cabecera.dart';
import 'package:quickglossary/presentation/widgets/floating_button_widget.dart';
import 'package:quickglossary/presentation/widgets/form_input_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickglossary/presentation/widgets/msj_confirmacion.dart';
import 'package:quickglossary/presentation/bloc/trivia/bloc.dart';
import 'package:quickglossary/presentation/widgets/loading_widget.dart';
import 'package:quickglossary/injection_container.dart';

class TriviaPage extends StatefulWidget {
  final AssetImage backgroundImage = new AssetImage("assets/images/background.png");

  TriviaPage({Key key}) : super(key: key);

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  BuildContext contextPage;
  Word word = new Word();
  int successCounter = 0;

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
          child: BlocProvider<TriviaBloc>(
            create: (_) => sl<TriviaBloc>(),
            child: BlocConsumer<TriviaBloc, TriviaState>(listener: (context, state) {
              this.contextPage = context;

              if (state is GoToHome) {
                Navigator.of(this.contextPage).pop();
                final route = MaterialPageRoute(builder: (context) => HomePage());
                Navigator.of(this.contextPage).push(route);
              } else if (state is Loaded) {
                this.word = state.word;
                if (state.stateTrivia == EnumStateTrivia.SUCCESS)
                  this.successCounter++;
                else if (state.stateTrivia == EnumStateTrivia.FAILED) this.successCounter = 0;
                if (state.stateTrivia == EnumStateTrivia.WAITING) this.word.spanishText = "";
              }
            }, builder: (context, state) {
              this.contextPage = context;
              if (state is Empty) {
                BlocProvider.of<TriviaBloc>(this.contextPage).add(GetReload(word: new Word()));
                return SizedBox(height: 0);
              } else if (state is Loading) {
                return LoadingWidget();
              } else if (state is Loaded) {
                return _getControles(word: this.word, stateTrivia: state.stateTrivia);
              } else if (state is Invalid) {
                Color colorFont = Colors.grey;
                if (state.code == "UNKNOWN_WORD") {
                  colorFont = Colors.red;
                  this.word = state.word;
                  return _getControles(word: this.word, stateTrivia: EnumStateTrivia.FAILED);
                }
                //muestro mensaje de validacion y reacargo la pantalla
                return MsjConfirmacion(
                    titulo: "Aviso",
                    mensaje: state.message,
                    onAceptar: (BuildContext context, String data) {
                      BlocProvider.of<TriviaBloc>(this.contextPage).add(GetReload(word: state.word));
                    });
              } else if (state is Error) {
                //muestro mensaje de error y reacargo la pantalla
                return MsjConfirmacion(
                    titulo: "Error",
                    mensaje: state.message,
                    onAceptar: (BuildContext context, String data) {
                      BlocProvider.of<TriviaBloc>(this.contextPage).add(GetReload(word: new Word()));
                    });
              } else {
                return SizedBox(height: 0);
              }
            }),
          ),
        ));
  }

  Widget _getControles({Word word, EnumStateTrivia stateTrivia}) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(height: 5),
      titleWords(successCounter),
      SizedBox(height: 20),
      textCategory(),
      SizedBox(height: 10),
      textEnglishText(),
      SizedBox(height: 10),
      textSpanishText(stateTrivia),
      SizedBox(height: 30),
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [buttonHome(), SizedBox(width: 100), buttonTest(stateTrivia), buttonPick()],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ))
    ]);
  }

  Widget buttonHome() {
    return FloatingButtonWidget(
        icon: Icons.arrow_back,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        onClickAction: (context, word) {
          BlocProvider.of<TriviaBloc>(contextPage).add(GetHome());
        });
  }

  Widget buttonTest(EnumStateTrivia stateTrivia) {
    return stateTrivia == EnumStateTrivia.WAITING
        ? FloatingButtonWidget(
            icon: Icons.check,
            iconColor: Colors.white,
            backgroundColor: EnumColor.secondaryColor,
            contextParent: this.contextPage,
            word: this.word,
            title: "Check trivia",
            onClickAction: (context, word) {
              BlocProvider.of<TriviaBloc>(context).add(GetTest(word: word));
            })
        : SizedBox(height: 10);
  }

  Widget buttonPick() {
    return FloatingButtonWidget(
        icon: Icons.assistant_photo_outlined,
        iconColor: Colors.white,
        backgroundColor: EnumColor.secondaryColor,
        contextParent: this.contextPage,
        word: this.word,
        title: "Get trivia",
        onClickAction: (context, word) {
          BlocProvider.of<TriviaBloc>(context).add(GetPick());
        });
  }

  Widget titleWords(int successCounter) {
    return CardCabecera(
        titulo: "Trivia",
        subtitulo: "Success Counter: " + successCounter.toString(),
        icono: Icon(Icons.workspaces_outlined, color: Colors.grey, size: 40));
  }

  Widget textEnglishText() {
    return FormInputImageWidget(
        icon: Icons.format_textdirection_l_to_r_outlined,
        initValue: this.word.englishText,
        hint: 'English Text',
        colorFont: Colors.black,
        isEnabled: false,
        onChanged: (value) => {this.word.englishText = value});
  }

  Widget textSpanishText(EnumStateTrivia stateTrivia) {
    return FormInputImageWidget(
        icon: Icons.format_textdirection_r_to_l_outlined,
        initValue: this.word.spanishText,
        hint: 'Spanish Text',
        colorFont: stateTrivia == EnumStateTrivia.WAITING
            ? Colors.black
            : stateTrivia == EnumStateTrivia.SUCCESS
                ? EnumColor.successColor
                : EnumColor.failedColor,
        isEnabled: (stateTrivia == EnumStateTrivia.WAITING),
        onChanged: (value) => {this.word.spanishText = value});
  }

  Widget textCategory() {
    return FormInputImageWidget(
        icon: Icons.align_horizontal_left_sharp,
        initValue: this.word.category,
        hint: 'Category',
        colorFont: Colors.black,
        isEnabled: false,
        onChanged: (value) => {this.word.englishText = value});
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
