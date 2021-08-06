import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/data/concrete/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/device_size_extension.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _listView,
    );
  }

  AppBar get _appBar => AppBar(
        title: Text("Ayarlar"),
      );
  Padding get _listView => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        child: ListView(
          children: [
            _darkThemeCard,
            _sizedBox,
            _deleteAllRecipeCard,
            _sizedBox,
            _deleteAllCategoryCard
          ],
        ),
      );
  Widget _settingHeaderCard(
          {GestureTapCallback onTap,
          BorderRadius radius,
          String text,
          String subtitle,
          Widget leading,
          Widget trailing,
          Color bgColor,
          AlignmentGeometry alignment}) =>
      Container(
        height: context.calculateByPercentage(12, SideTypes.VERTICAL),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: bgColor ?? Theme.of(context).colorScheme.surface,
        ),
        alignment: alignment ?? null,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ListTile(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(subtitle),
            leading: leading,
            trailing: trailing,
          ),
        ),
      );

  Widget get _darkThemeCard => _settingHeaderCard(
        leading: CircleAvatar(
          child: Icon(
            Provider.of<ThemeProvider>(context).isDarkThemeActive
                ? Icons.brightness_2_rounded
                : Icons.brightness_7_rounded,
            size: 25,
          ),
        ),
        trailing: Switch(
          value: Provider.of<ThemeProvider>(context).isDarkThemeActive,
          onChanged: (_) =>
              Provider.of<ThemeProvider>(context, listen: false).changeTheme(),
          activeColor: Theme.of(context).colorScheme.background,
        ),
        text: "Koyu Tema",
        alignment: Alignment.center,
        subtitle: Provider.of<ThemeProvider>(context).isDarkThemeActive
            ? "Koyu Tema Aktif"
            : "Koyu Temayı Aktif Edebilirsiniz",
        radius: BorderRadius.circular(15),
        bgColor: Theme.of(context).colorScheme.secondary,
      );
  Widget get _deleteAllRecipeCard => _settingHeaderCard(
        bgColor: Colors.redAccent,
        leading: CircleAvatar(
          child: Icon(Icons.delete_sharp, size: 25),
        ),
        radius: BorderRadius.circular(25),
        onTap: () {},
        alignment: Alignment.center,
        text: "Tarifleri Sil",
        subtitle: "Bütün Kaydedilmiş Tarifleri Sil",
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          iconSize: _iconSize,
          onPressed: () {},
          alignment: Alignment.center,
          tooltip: "Hepsini Sil",
        ),
      );
  Widget get _deleteAllCategoryCard => _settingHeaderCard(
        bgColor: Colors.redAccent,
        leading: CircleAvatar(
          child: Icon(Icons.delete_sharp, size: 25),
        ),
        radius: BorderRadius.circular(25),
        alignment: Alignment.center,
        onTap: () {},
        text: "Kategorileri Sil",
        subtitle: "Bütün Kaydedilmiş Kategorileri Sil",
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          iconSize: _iconSize,
          onPressed: () {},
          alignment: Alignment.center,
          tooltip: "Hepsini Sil",
        ),
      );
  Widget get _sizedBox => SizedBox(
        height: context.calculateByPercentage(2, SideTypes.VERTICAL),
      );
  Widget get _applicationOptions => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red.shade900,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _deleteAllRecipeCard,
            _sizedBox,
            _deleteAllCategoryCard,
          ],
        ),
      );
  double get _iconSize =>
      (context.calculateByPercentage(4, SideTypes.VERTICAL) +
          context.calculateByPercentage(8, SideTypes.HORIZONTAL)) /
      2;
  // Widget get _titleTextSizeSlider => Column(
  //       children: [
  //         Text("Başlıkların Harf Büyüklüğü"),
  //         Slider(
  //           value: Provider.of<ThemeProvider>(context).currentTitleTextSize,
  //           max: 50,
  //           min: 10,
  //           divisions: 20,
  //           label: Provider.of<ThemeProvider>(context)
  //               .currentTitleFontSizeSituation,
  //           onChanged: Provider.of<ThemeProvider>(context).setTitleSize,
  //         ),
  //       ],
  //     );
  // Widget get _otherTextsSizeSlider => Column(
  //       children: [
  //         Text("Diğer Yazıların Harf Büyüklüğü"),
  //         Slider(
  //           value: Provider.of<ThemeProvider>(context).currentOtherTextsSize,
  //           max: 45,
  //           min: 5,
  //           label: Provider.of<ThemeProvider>(context)
  //               .currentOtherTextsFontSizeSituation,
  //           divisions: 20,
  //           onChanged: Provider.of<ThemeProvider>(context).setSubtitleSize,
  //         ),
  //       ],
  //     );
}
