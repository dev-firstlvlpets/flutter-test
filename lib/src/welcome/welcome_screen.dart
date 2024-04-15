import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  static const routeName = '/welcome';

  //TODO: PageDecoration for alignments (body/title widget possible)
  final List<PageViewModel> _pages = [
    PageViewModel(
      title: 'I am a title',
      body: 'I am a body',
      image: Center(
        child: Image.asset('assets/images/flutter_logo.png'),
      ),
      //decoration: PageDecoration()
      //footer:
    ),
    PageViewModel(
        title: 'I am a title',
        body: 'I am a body',
        image: Center(
          child: Image.asset('assets/images/flutter_logo.png'),
        )),
    PageViewModel(
        title: 'I am a title',
        body: 'I am a body',
        image: Center(
          child: Image.asset('assets/images/flutter_logo.png'),
        ))
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntroductionScreen(
        pages: _pages,
        //dotsDecorator: ,
        done: const Text('Done'),
        next: const Text('Next'),
        back: const Text('Back'),
        showBackButton: true,
        //doneStyle: ,
        onDone: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
