import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:text_extraction/audio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:text_extraction/grid.dart';
import 'package:text_extraction/image.dart';
import 'package:text_extraction/main.dart';
import 'package:text_extraction/function.dart';
import 'package:text_extraction/audio.dart';

class GridDashboard extends StatefulWidget {

  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {

  //show image
  File _image;


  Future<void> getImage(bool isCamera) async {
    File image;
    _image = null;

    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;

      //showImage(){
      if (image == null) {
        print("No Image selected here");
        /* return Text(
          "No Image selected here",
          style: TextStyle(
              color: Colors.grey[400], letterSpacing: 2.0, fontSize: 20),
        ); */
      }
      /* else {
        return Image.file(image, width: 200, height: 400);
      } */
      //}
    });
  }

  @override
  ProgressDialog pr;

  Widget _GridDashboard(BuildContext context) => Container(



    height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),


    child: Column(
      children: <Widget>[
        SizedBox(height: 24),
        Center(
          child: Text(
            "Open With ".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,

              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
            children: <Widget>[
              SizedBox(width: 30,),
              IconButton(
                  icon: Icon(Icons.camera_alt_rounded,
                    color: Color(0xff6e51e3),
                    size: 50,
                  ),
                  onPressed: () async  {
                    getImage(true);
                      pr.show();

                      var res = await pic2text(_image);
                      var resStr = await res.stream.bytesToString();
                      var body = json.decode(resStr);
                      print(body);

                  }
              ),

              SizedBox(width: 100,),
              IconButton(
                icon: Icon(Icons.photo,
                  color: Color(0xff6e51e3),
                  size: 50,),
                onPressed: () async {
                  await getImage(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PictureRoute(file: _image)),
                    );}

              ),
    ]
  ),
        SizedBox(height: 10,),
        Row(
            children:[
              SizedBox(width: 40,),
              Text('Camera'),
              SizedBox(width: 110,),
              Text('Gallery')
            ]
        ),
        SizedBox(height: 40),
        Padding(
            padding:
            EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
            child: TextField(
              controller: myController,

              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.text,

              decoration: InputDecoration(

                labelText: 'Enter your image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),

                ),
              ),

            )),

        //SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 8),
            RaisedButton(
                color: Colors.white,
                child: Text(
                  "Save".toUpperCase(),
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: ()  async {
                  try{
                    var res = await url2text(myController.text);
                    var response = res.body;
                    var body = json.decode(response);
                    print(body);
                  }
                  catch(e){
                    print('there is an error with the url submitted: $e');

                  }
                  var res = await url2text(myController.text);
                  var response = res.body;
                  var body = json.decode(response);
                  print(body);



                  //if(res.statusCode == 200){
                  //print('error');

                  //}

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdRoute(body)),
                  );
                }
            ),

          ],
        ),
      ],
    ),
  );


  //audio file propertie

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
        _path = await FilePicker.getFilePath(
            type: _pickingType, allowedExtensions: [_extension]);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path
            .split('/')
            .last : '...';
      });
    }
  }


  @override
  _displayDialogaudio() {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _GridDashboardaudio(context),
          );
        });
  }

  Widget _GridDashboardaudio(BuildContext context) =>
      Container(


          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),


          child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 5.0, right: 5.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: new DropdownButton(
                                hint: new Text('LOAD PATH FROM'),
                                value: _pickingType,
                                items: <DropdownMenuItem>[
                                  new DropdownMenuItem(
                                    child: new Text('Audio'),
                                    value: FileType.custom,
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => _pickingType = value)),
                          ),
                          Text('Choose a file extension of MP3, FLAC, WAV'),
                          new ConstrainedBox(
                            constraints: new BoxConstraints(maxWidth: 150.0),
                            child: _pickingType == FileType.custom
                                ? new TextFormField(
                              maxLength: 5,
                              autovalidate: true,
                              controller: _controller,
                              decoration: InputDecoration(
                                  labelText: 'File type'),
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
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: () => _openFileExplorer(),
                              child: new Text("Open file picker"),
                            ),
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
                          new Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: (){},
                              child: new Text("Transcribe"),
                            ),
                          ),
                        ],
                      ),
                    )),
              ])
      );


//video

  _displayDialogvideo() {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _GridDashboardvideo(context),
          );
        });
  }

  Widget _GridDashboardvideo(BuildContext context) =>
      Container(


          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),


          child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 5.0, right: 5.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: new DropdownButton(
                                hint: new Text('LOAD PATH FROM'),
                                value: _pickingType,
                                items: <DropdownMenuItem>[
                                  new DropdownMenuItem(
                                    child: new Text('video'),
                                    value: FileType.custom,
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => _pickingType = value)),
                          ),
                          Text('Choose a file extension of MP4, avi'),
                          new ConstrainedBox(
                            constraints: new BoxConstraints(maxWidth: 150.0),
                            child: _pickingType == FileType.custom
                                ? new TextFormField(
                              maxLength: 5,
                              autovalidate: true,
                              controller: _controller,
                              decoration: InputDecoration(
                                  labelText: 'File type'),
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
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: () => _openFileExplorer(),
                              child: new Text("Open file picker"),
                            ),
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
                          new Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: (){},
                              child: new Text("Transcribe"),
                            ),
                          ),
                        ],
                      ),
                    )),
              ])
      );



//document

  _displayDialogdoc() {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _GridDashboarddoc(context),
          );
        });
  }

  Widget _GridDashboarddoc(BuildContext context) =>
      Container(


          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),


          child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 5.0, right: 5.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: new DropdownButton(
                                hint: new Text('LOAD PATH FROM'),
                                value: _pickingType,
                                items: <DropdownMenuItem>[
                                  new DropdownMenuItem(
                                    child: new Text('Documents'),
                                    value: FileType.custom,
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => _pickingType = value)),
                          ),
                          Text('Choose a file extension of pdf, txt, doc'),
                          new ConstrainedBox(
                            constraints: new BoxConstraints(maxWidth: 150.0),
                            child: _pickingType == FileType.custom
                                ? new TextFormField(
                              maxLength: 5,
                              autovalidate: true,
                              controller: _controller,
                              decoration: InputDecoration(
                                  labelText: 'File type'),
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
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: () => _openFileExplorer(),
                              child: new Text("Open file picker"),
                            ),
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
                          new Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: new RaisedButton(
                              onPressed: (){},
                              child: new Text("Transcribe"),
                            ),
                          ),

                        ],
                      ),
                    )),
              ])
      );




  @override
  displayDialog2() {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _GridDashboard2(context),
          );
        });
  }

  Widget _GridDashboard2(BuildContext context) =>
      Container(


          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),


          child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Center(
                  child: Text(
                    "Open With ".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,

                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Row(
                    children: <Widget>[
                      SizedBox(width: 30,),

                      IconButton(
                          icon: Icon(Icons.mic_none,
                            color: Color(0xff6e51e3),
                            size: 70,
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpeechScreen()),
                            );
                          }
                      ),

                      SizedBox(width: 100,),
                      IconButton(
                        icon: Icon(Icons.audiotrack,
                          color: Color(0xff6e51e3),
                          size: 70,),
                        onPressed: _displayDialogaudio,

                      ),
                    ]
                ), SizedBox(height: 30,),
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Text('Speech to Text'),
                    SizedBox(width: 80),
                    Text('Audio File')
                  ],
                ),
              ])
      );


  @override
  _displayDialog() {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _GridDashboard(context),
          );
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr;
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

    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            MenuItem(icon: 'assets/photo.png',
              title: 'Images',
              subtitle: 'Extract text from Images',
              onTap: _displayDialog,),
            MenuItem(icon: 'assets/document.png',
              title: 'Documents',
              subtitle: 'Extract text from Documents ',
              onTap: _displayDialogdoc,),
            MenuItem(icon: 'assets/headphones.png',
              title: 'Audio',
              subtitle: 'Speech to Text and trancribe',
              onTap: displayDialog2,),
            MenuItem(icon: 'assets/video.png',
              title: 'Video',
              subtitle: 'Get your video Trancription',
              onTap: _displayDialogvideo,),

          ]
      ),
    );
  }
}



class MenuItem extends StatelessWidget {
  final icon;
  final String title;
  final String subtitle;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title,this.subtitle, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: Color(0xffe3e0ed), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Image.asset(
              icon,
              width: 24,
            ),onPressed: onTap,
          ),
          SizedBox(
            height: 14,
          ),
          new GestureDetector(
            onTap: onTap,
            child: new Text(title,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            subtitle,
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xff655893),
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 14,
          ),
        ],
      ),
    );
  }
}



