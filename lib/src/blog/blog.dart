import 'package:firstlvlpets/src/blog/blog_all_entries.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  static const routeName = '/blog';

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Lvl Pets')),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.donut_large), label: 'A'),
        BottomNavigationBarItem(icon: Icon(Icons.donut_large), label: 'B')
      ]),
      body: Center(
          child: Column(
        children: [
          Image.asset('assets/images/flutter_logo.png'),
          Text('Title'),
          Text('Most Read'),
          Row(
            children: [
              Image.asset('assets/images/flutter_logo.png'),
              Image.asset('assets/images/flutter_logo.png'),
              Image.asset('assets/images/flutter_logo.png')
            ],
          ),
          Row(
            children: [
              Text('Explore More'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, BlogAllEntries.routeName);
                  },
                  child: Text('See more'))
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Image.asset('assets/images/flutter_logo.png'),
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Image.asset('assets/images/flutter_logo.png'),
                      Positioned(
                        child: Checkbox(value: true, onChanged: (v) {}),
                        top: 0,
                        left: 0,
                      )
                    ],
                  ))
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Image.asset('assets/images/flutter_logo.png'),
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Image.asset('assets/images/flutter_logo.png'),
                      Positioned(
                        child: Checkbox(value: true, onChanged: (v) {}),
                        top: 0,
                        left: 0,
                      )
                    ],
                  ))
            ],
          ),
        ],
      )),
    );
  }
}
