
import 'package:flutter/material.dart';

import 'package:spaceflutter/pages/MenuPage.dart';
import 'package:spaceflutter/pages/SpacePage.dart';
import 'package:spaceflutter/GamePlay.dart';


class SpaceFlutterApplication extends WidgetsApp {
  static double height, width;

  SpaceFlutterApplication()
      : super(
          initialRoute: '/',
          onGenerateRoute: myRouteFactory,
          navigatorObservers: [],
          color: Colors.black,
        );


  static Route<dynamic> myRouteFactory(RouteSettings settings) =>
      new PageRouteBuilder(pageBuilder: (BuildContext context,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        if(settings.name == '/'){
          return new MenuPage();
        } else{
          SpacePage spacePage = new SpacePage();
          GamePlay gamePlay = new GamePlay(spacePage.spacePageState);
          gamePlay.initGamePlay();
          return spacePage;
        }

      });
}
