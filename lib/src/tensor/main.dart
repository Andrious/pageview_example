//import 'package:flutter/material.dart';
import 'package:pageview_example/src/source.dart';

/// Uncomment to try Tensor's example app separately.

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gallery Demo',
//       theme: ThemeData(primarySwatch: Colors.lightGreen),
//       home: const DisplayPage(),
//     );
//   }
// }

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key key}) : super(key: key);
  @override
  State createState() => _DisplayPageState();

  static void setState(VoidCallback fn){
    final state = SetState.of<_DisplayPageState>();
    // If null, then it's not the one currently being viewed.
    state?.setState(fn);
  }
}

class _DisplayPageState extends SetState<DisplayPage> {
//
  final List<String> images = [
    'assets/wallpaper-1.jpeg',
    'assets/wallpaper-2.jpeg',
    'assets/wallpaper-3.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox.fromSize(
        size: const Size.fromHeight(550),
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.8),
            itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                          colors: [
                            const Color(0x00000000).withOpacity(0.9),
                            const Color(0xff000000).withOpacity(0.01),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )),
    );
  }
}
