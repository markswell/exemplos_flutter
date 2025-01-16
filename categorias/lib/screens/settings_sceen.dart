import 'package:flutter/material.dart';

import '../components/application_app_bar.dart';
import '../components/main_drawer.dart';
import '../models/settings.dart';

class SettingsSceen extends StatefulWidget {
  final Function(Setting) onSettingsChange;
  final Setting setting;

  const SettingsSceen({
    super.key,
    required this.setting,
    required this.onSettingsChange,
  });

  @override
  State<SettingsSceen> createState() => _SettingsSceenState();
}

class _SettingsSceenState extends State<SettingsSceen> {
  Widget _createSwitch(
    String title,
    String subTitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile.adaptive(
      title: Text(title),
      subtitle: Text(subTitle),
      value: value,
      onChanged: (value) {
        onChanged(value);
        widget.onSettingsChange(widget.setting);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      drawer: MainDrawer(),
      appBar: ApplicationAppBar.createAppBar('Configurações', context),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Configurações',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _createSwitch(
                  'Sem glutem',
                  'Só exibe refeições sem glutem',
                  widget.setting.isGlutenFree,
                  (value) => setState(() {
                    widget.setting.isGlutenFree = value;
                  }),
                ),
                _createSwitch(
                  'Sem lactose',
                  'Só exibe refeições sem lactose',
                  widget.setting.isLactoseFree,
                  (value) => setState(() {
                    widget.setting.isLactoseFree = value;
                  }),
                ),
                _createSwitch(
                  'Vegana',
                  'Só exibe refeições veganas',
                  widget.setting.isVegan,
                  (value) => setState(() {
                    widget.setting.isVegan = value;
                  }),
                ),
                _createSwitch(
                  'Vegetariana',
                  'Só exibe refeições vegetarianas',
                  widget.setting.isVegetarian,
                  (value) => setState(() {
                    widget.setting.isVegetarian = value;
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
