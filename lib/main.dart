import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

@hwidget
Widget myApp() => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark(),
  home: Scaffold(
    body: CountWidget(),
  ),
);

@swidget
Widget simpleTextWidget(String text) {
  return Text(text);
}

@hwidget
Widget countWidget() {
  final countValue = useState(0);
  final countAni = useAnimationController(initialValue: 1, duration: Duration(seconds: 1));
  final fadeInAni = useAnimationController(duration: Duration(seconds: 1));
  final fadeInAnBtn = useAnimationController(duration: Duration(seconds: 1));
  final isMounted = useIsMounted();
  useEffect(() {
    Future.delayed(Duration(milliseconds: 150)).then((_) {
      if (isMounted())
        fadeInAni.forward();
      return Future.delayed(Duration(milliseconds: 300), () {
        if (isMounted())
          fadeInAnBtn.animateTo(1);
      });
    });
    return null;
  }, ['onetime']);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: countAni,
          builder: (BuildContext context, Widget child) {
            print('ani: $countAni');
            return SizeTransition(
                sizeFactor: countAni, child: child
            );
          },
          child: AnimatedBuilder(
            animation: fadeInAni,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(opacity: fadeInAni, child: child);
            },
            child: Center(
              child: SimpleTextWidget(
                'Count: ${countValue.value}',
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 18,),
      AnimatedSwitcher(
        reverseDuration: Duration.zero,
        duration: Duration(milliseconds: 1000),
        child: AnimatedBuilder(
          animation: fadeInAnBtn,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(opacity: fadeInAnBtn, child: child);
          },
          child: FloatingActionButton(
              child: Text('++'),
              key: ValueKey(countValue.value),
              onPressed: () {
                countValue.value = countValue.value + 2;
                countAni..reset()
                  ..forward();
              },
          ),
        ),
      )
    ],
  );
}