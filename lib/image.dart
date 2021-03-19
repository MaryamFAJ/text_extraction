import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:share/share.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:text_extraction/function.dart';
import 'package:text_extraction/GridDashBoard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_extraction/main.dart';


class PictureRoute extends StatefulWidget {
  final File file;

  const PictureRoute({Key key, this.file}) : super(key: key);

  @override
  _PictureRouteState createState() => _PictureRouteState();
}

class _PictureRouteState extends State<PictureRoute> {
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            widget.file == null
                ? Container()
                : Image.file(
              widget.file,
              height: 500.0,
              width: 300.0,
            ),
            Row(
              //padding: EdgeInsets.all(20),
              children: [
                SizedBox(width: 70),
                IconButton(
                  icon: Icon(Icons.cancel_outlined,
                      color: Colors.red, size: 60.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 100),
                IconButton(
                  icon: Icon(Icons.check_circle_outline_rounded,
                      color: Colors.green, size: 60.0),
                  onPressed: () async {
                    pr.show();

                    var res = await pic2text(widget.file);
                    var resStr = await res.stream.bytesToString();
                    var body = json.decode(resStr);
                    print(body);


                    if (res.statusCode == 422) {
                      return print('an error occurred');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdRoute(body)),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ThirdRoute extends StatefulWidget {

  List<dynamic> texts;
  ThirdRoute(this.texts);


  @override
  _ThirdRouteState createState() => _ThirdRouteState();
}

enum TtsState { playing, stopped }

class _ThirdRouteState extends State<ThirdRoute> {
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print("Available languages ${languages}");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    var _newVoiceText = widget.texts.join('');

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);

      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }


  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
    });
  }


  @override
  Widget build(BuildContext context) {
    //print(widget.texts);
    return Scaffold(
      appBar: AppBar(
        title: Text("Extracted Text"),
        backgroundColor: Color(0xff6e51e3),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: widget.texts.map((text) {
                    return ListTile(
                      title: Text(text,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            //RaisedButton(
            //color: Colors.lightBlueAccent,
            //onPressed: () {
            // Add your onPressed code here!
            //Navigator.pop(context);
            //},
            //child: Text(
            //'Select Another Picture',
            //style: TextStyle(
            //color: Colors.white,
            //letterSpacing: 2.0,
            //fontSize: 20,
            //),
            //),
            // ),
            _buildSliders(),
            Row(
              children: [
                SizedBox(width: 40,),
                bottomBar(),
                SizedBox(width: 40,),
                IconButton(
                  icon: Icon(Icons.share_sharp,
                      color: Color(0xff6e51e3), size: 50.0),
                  onPressed: () {
                    Share.share( widget.texts.join(''));
                  },
                ),],

            ),

          ],
        ),
      ),

    );

  }
  Widget _buildSliders() {
    return Column(
      children:[
        Text("Pitch",
          style: TextStyle(color: Colors.black, letterSpacing: 2.0, fontSize: 20),
        ),_pitch(),
        Text("Speech Rate",
          style: TextStyle(color: Color(0xff6e51e3), letterSpacing: 2.0, fontSize: 20),
        ),
        _rate()],
    );
  }


  Widget _pitch() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() => pitch = newPitch);
      },
      min: 0.2,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.black54,
    );
  }

  Widget _rate() {
    title: 'Speech rate';
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 2.0,
      divisions: 20,
      label: "Rate: $rate",
      activeColor:
      Colors.blue,
    );
  }

  bottomBar() =>Container(
    margin: EdgeInsets.all(10.0),
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _speak,
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.green,

        ),
        SizedBox(width: 40),

        FloatingActionButton(
          onPressed: _stop,
          backgroundColor: Colors.red,
          child: Icon(Icons.stop),
        ),
      ],
    ),
  );
}