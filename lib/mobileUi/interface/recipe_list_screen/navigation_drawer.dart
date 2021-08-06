import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  BuildContext _context;
  BuildContext get getContext => _context;
  set setContext(BuildContext context) => _context = context;
  @override
  Widget build(BuildContext context) {
    setContext = context;
    return Drawer(
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          ExpansionTile(
            backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
            collapsedBackgroundColor: Theme.of(context).colorScheme.onSecondary,
            title: Text(
              "Kategori İşlemleri",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            children: [
              ListTile(
                title: Text("Kategori Ekle"),
                leading: Icon(Icons.add),
                trailing: IconButton(
                  icon: Icon(Icons.open_in_new_outlined),
                  tooltip: "Kategori Ekle",
                  onPressed: goToCategoryAdd,
                ),
              ),
              ListTile(
                title: Text("Kategorileri Listele"),
                leading: Icon(Icons.view_list),
                trailing: IconButton(
                  icon: Icon(Icons.open_in_new_outlined),
                  tooltip: "Kategorileri Listele",
                  onPressed: goToCategoryList,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goToCategoryAdd() {
    Navigator.pushNamed(getContext, "/categoryAdd");
  }

  void goToCategoryList() {
    Navigator.pushNamed(getContext, "/categoryList");
  }
}
