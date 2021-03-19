import 'dart:ui';
import 'package:text_extraction/image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_extraction/GridDashBoard.dart';
import 'package:text_extraction/audio.dart';
void main() => runApp(MaterialApp(home:Welcome()));



class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xff6e51e3),
      body: Container(
        margin:const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        width: 340,
        height: 700,
        decoration: BoxDecoration(
          color: Color(0xff6e51e3),

          border: Border.all(

            color: Colors.white,
            width:1.5,

          ),
          borderRadius: BorderRadius.circular(14.0),
        ),

        child: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              Container(

                child: Text('Handwriting Extraction',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Bilbo',
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 57,
                  ),
                ),
              ),
              SizedBox(height: 70),


              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),

                ),

                child:

                Text('Get Started',
                  style: TextStyle(
                    color: Color(0xff6e51e3),
                    letterSpacing: 2.0,
                    fontSize: 25,

                  ),),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },

              ),
              SizedBox(height:20),
            ],
          ),
        ),
      ),
    );
    // Add your onPressed code here!
  }
// Navigate to second route when tapped.
}




class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "NHE",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xff6e51e3),
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Home",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xff3213f5),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Image.asset(
                    "assets/setting.png",
                    width: 24,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          SizedBox(
            height: 70,
          ),
          GridDashboard(),


          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                ),
                label: 'Home',
                backgroundColor: Color(0xff655893),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history,
                  ),
                label: 'History',

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Color(0xff655893),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffb4a6d5),
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }
}



/// This is the main application widget.


/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {

  List<dynamic> texts;
  MyStatefulWidget(this.texts);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  final _controller = TextEditingController();

  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xE0101),
      body: Container(color: Color(0xff6e51e3),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),

        child: new SizedBox(
          width: 350.0,
          height: 500.0,
          child:TextFormField(
            maxLines: 80,
          controller: _controller,

          decoration: InputDecoration(border: OutlineInputBorder(),),
        ),)
      ),
    );
  }
}


