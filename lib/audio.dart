import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:share/share.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';

class VoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AudioRoute(),
    );
  }
}
class AudioRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio"),
        backgroundColor:  Color(0xff6e51e3),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(90),
                child: Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.mic,
                            color:  Color(0xff6e51e3), size: 70.0),
                        onPressed: () async {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpeechScreen()),
                          );
                        }

                    ),
                    SizedBox(height: 50),
                    Text(
                      'Microphone',
                      style: TextStyle(
                          color: Color(0xff6e51e3), letterSpacing: 2.0, fontSize: 30),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(90),

                child: Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.audiotrack,
                            color: Color(0xff6e51e3), size: 70.0),
                        onPressed: () async {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoiceApp()),
                          );
                        }
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Upload Audio Files',
                      style: TextStyle(
                          color:  Color(0xff6e51e3), letterSpacing: 2.0, fontSize: 20),
                    ),
                  ],
                ),
              ),

            ]
        ),
      ),


    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        backgroundColor: Color(0xff6e51e3),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share(_text.toString());
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Color(0xff6e51e3),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 3000),
        repeatPauseDuration: const Duration(milliseconds: 700),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),

      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}


class SecondRoute extends StatefulWidget {
  List texts;
  SecondRoute(this.texts);



  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {


  @override
  Widget build(BuildContext context) {
    //print(widget.texts);
    return Scaffold(
      appBar: AppBar(
        title: Text("NHE"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: widget.texts.map((text) {
                    return Text(text,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        fontSize: 20,
                      ),);
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

          ],
        ),
      ),

    );
  }
}
class Audio extends StatefulWidget {
  @override
  _AudioState createState() => new _AudioState();
}

class _AudioState extends State<Audio> {
  String _fileName = '...';
  File _file;
  String _path = '...';
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(type: _pickingType, allowedExtensions: [_extension]);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path.split('/').last : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: new Center(
              child: new Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new DropdownButton(
                          hint: new Text('LOAD PATH FROM'),
                          value: _pickingType,
                          items: <DropdownMenuItem>[
                            new DropdownMenuItem(
                              child: new Text('FROM AUDIO'),
                              value: FileType.audio,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM GALLERY'),
                              value: FileType.image,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM VIDEO'),
                              value: FileType.video,
                            ),
                            new DropdownMenuItem(
                              child: new Text('FROM ANY'),
                              value: FileType.any,
                            ),
                            new DropdownMenuItem(
                              child: new Text('CUSTOM FORMAT'),
                              value: FileType.custom,
                            ),
                          ],
                          onChanged: (value) => setState(() => _pickingType = value)),
                    ),
                    new ConstrainedBox(
                      constraints: new BoxConstraints(maxWidth: 150.0),
                      child: _pickingType == FileType.custom
                          ? new TextFormField(
                        maxLength: 20,
                        autovalidate: true,
                        controller: _controller,
                        decoration: InputDecoration(labelText: 'File type'),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                          if (reg.hasMatch(value)) {
                            _hasValidMime = false;
                            return 'Invalid format';
                          }
                          _hasValidMime = true;
                        },
                      )
                          : new Container(),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                      child: new RaisedButton(
                        onPressed: () => _openFileExplorer(),
                        child: new Text("Open file picker"),
                      ),
                    ),
                    new Text(
                      'URI PATH ',
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      _path ?? '...',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      textScaleFactor: 0.85,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Text(
                        'FILE NAME ',
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Text(
                      _fileName,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }}
