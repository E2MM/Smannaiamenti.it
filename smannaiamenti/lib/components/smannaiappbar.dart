import 'package:flutter/material.dart';
import 'package:smannaiamenti/pages/home.dart';

import '../config.dart';

class SmannaiappBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isHomePage;

  SmannaiappBar({Key? key, this.isHomePage = false})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _SmannaiappBarState createState() => _SmannaiappBarState(isHomePage);
}

class _SmannaiappBarState extends State<SmannaiappBar> {
  var isHomePage;

  _SmannaiappBarState(this.isHomePage);

  Widget _buildLogo() {
    return Stack(
      children: [
        Container(
          width: 104.0,
          height: 98.0,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Image.asset(
          "web/icons/Icon-200.png",
          height: 98,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        "smannaiamenti.it",
        overflow: TextOverflow.fade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AppBar(
      title: Row(
        children: <Widget>[
          _buildLogo(),
          SizedBox(width: 8),
          isHomePage
              ? _buildTitle()
              : InkWell(
                  child: _buildTitle(),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        settings: RouteSettings(name: "/"),
                        pageBuilder: (context, animation1, animation2) =>
                            HomePage(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },
                  //highlightShape
                  // customBorder: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(20)),
                  // ),
                  //side: BorderSide(width: 50)),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  //radius: 50,
                ),
          Spacer(),
          Switch(
            value: currentTheme.isDarkMode(
              platformBrightness: mediaQuery.platformBrightness,
            ),
            onChanged: (value) {
              setState(() {
                currentTheme.setDarkMode(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
