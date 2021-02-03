import 'package:flutter/material.dart';

class TabScrollDemo extends StatefulWidget {
  @override
  _TabScrollDemoState createState() => _TabScrollDemoState();
}

class _TabScrollDemoState extends State<TabScrollDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool disableScrollControl = false;
  ScrollController _scrollController;

  List foodCategories = ['Cat1', 'Cat2', 'Cat3', 'Cat4', 'Cat5'];

  List<Widget> tabList;
  List list = [];
  List<double> offsets = [0, 500, 1000, 1500, 2000];
  @override
  void initState() {
    super.initState();
    tabList = foodCategories
        .map((e) => Tab(
              text: e,
            ))
        .toList();
    for (int j = 0; j < foodCategories.length; ++j) {
      list.add(foodCategories[j]);
      list.addAll(
          ['Test1', 'Test2', 'Test3', 'Test4', 'Test5', 'Test6'].map((e) => e));
    }
    // Create TabController for getting the index of current tab
    _tabController = TabController(length: tabList.length, vsync: this);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (!disableScrollControl) {
        // This will simply check if the specified offset is reached, if it is then it will move the tabcontroller to that as well
        bool flag = false;
        for (int i = 1; !flag && i < offsets.length; ++i) {
          if (_scrollController.offset < offsets[i]) {
            _tabController.animateTo(i - 1);
            flag = true;
          }
        }
        if (!flag) {
          _tabController.animateTo(tabList.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              disableScrollControl = true;
              _scrollController
                  .animateTo(offsets[_tabController.index],
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn)
                  .then((value) => disableScrollControl = false);
            },
            controller: _tabController,
            tabs: tabList,
          ),
          title: Text('Tabs Demo'),
        ),
        body: Container(
          child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemBuilder: (context, index) => ListTile(
              title: Text(
                list[index],
                style: foodCategories.contains(list[index])
                    ? TextStyle(
                        fontWeight: FontWeight.w900,
                      )
                    : null,
              ),
            ),
            itemCount: list.length,
          ),
        ),
      ),
    );
  }
}
