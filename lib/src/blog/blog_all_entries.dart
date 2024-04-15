import 'package:firstlvlpets/src/shared/models/blog_entry.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BlogAllEntries extends StatefulWidget {
  const BlogAllEntries({super.key});

  static const routeName = '/blog/all-entries';

  @override
  State<BlogAllEntries> createState() => _BlogAllEntriesState();
}

class _BlogAllEntriesState extends State<BlogAllEntries> {
  static const _pageSize = 16;

  final PagingController<int, BlogEntry> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final newItems = [
        BlogEntry(id: 1, title: 'Blog1'),
        BlogEntry(id: 2, title: 'Blog2'),
        BlogEntry(id: 3, title: 'Blog3'),
        BlogEntry(id: 4, title: 'Blog4'),
        BlogEntry(id: 1, title: 'Blog1'),
        BlogEntry(id: 2, title: 'Blog2'),
        BlogEntry(id: 3, title: 'Blog3'),
        BlogEntry(id: 4, title: 'Blog4'),
        BlogEntry(id: 1, title: 'Blog1'),
        BlogEntry(id: 2, title: 'Blog2'),
        BlogEntry(id: 3, title: 'Blog3'),
        BlogEntry(id: 4, title: 'Blog4'),
        BlogEntry(id: 1, title: 'Blog1'),
        BlogEntry(id: 2, title: 'Blog2'),
        BlogEntry(id: 3, title: 'Blog3'),
        BlogEntry(id: 4, title: 'Blog4'),
      ];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('first lvl Pets')),
      body: PagedGridView<int, BlogEntry>(
        pagingController: _pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 300),
        builderDelegate: PagedChildBuilderDelegate<BlogEntry>(
          itemBuilder: (context, item, index) => Container(
            margin: EdgeInsets.all(8.0),
            height: 350,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(22)),
            child: Center(
              child: Text(
                //TODO: custom widget
                item.title,
              ),
            ),
          ),
        ),
      ),
      // body: PagedListView<int, BlogEntry>(
      //   pagingController: _pagingController,
      //   builderDelegate: PagedChildBuilderDelegate<BlogEntry>(
      //     itemBuilder: (context, item, index) => Container(
      //       color: Colors.blueAccent,
      //       margin: EdgeInsets.all(8.0),
      //       height: 200,
      //       child: Text(
      //         //TODO: custom widget
      //         item.title,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
