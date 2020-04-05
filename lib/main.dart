import 'package:flutter/material.dart';
import 'dart:async';
import "dart:math";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(WinkWinkApp());

/*
ChangeNotifierProvider(
    create: (context) => Nagginess(),
 */
class Nagginess with ChangeNotifier {
  int value = 1;

  void setValue(int newValue) {
    value = min(max(newValue, 1), 10);
    notifyListeners();
  }
}

class WinkWinkApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wink wink',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: NudgesView(),
    );
  }
}





class WinkAppBar extends StatelessWidget {
  WinkAppBar({this.title});

  // Fields in a Widget subclass are always marked "final".

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      // Row is a horizontal, linear layout.
      child: Row(
        // <Widget> is the type of items in the list.
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null, // null disables the button
          ),
          // Expanded expands its child to fill the available space.
          Expanded(
            child: title,
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}


class NudgesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return ActiveNudgesList(
        nudges: <Nudge>[
          Nudge(name: 'Wash hands', description: "Reminders to wash hands", emoji: "🖐", nagFrequency: 2, nudgeTexts: [
            "Wash hands for at least 20s to decrease Covid spread 🧼🖐",
            "When was the last time you washed your hands?",
            "Have you touched any surface someone else touched? Maybe wash your hands"
          ]),
          Nudge(name: 'Protect the elderly', description: "Tips to pay proper attention to older citizens and other risk groups", emoji: "👴", nagFrequency: 1, nudgeTexts: [
            "Keep 2m distance to people when you are going about your day, especially risk groups such as the elderly",
            "Do you know someone in a risk group? Perhaps you could ask them if they need help with groceries"
          ]),
          Nudge(name: 'Shop responsibly', description: "Hints on when and how to buy groceries etc", emoji: "🛒", nagFrequency: 0.5, nudgeTexts: [
            "Don't stockpile groceries and supplies unnecessarily. Maybe aim for a 1-2 week consumption? 🛒",
            "Consider finding out what time the fewest people go shopping, and go then if you can. Calm and responsible!",
            "If you show any symptoms, or are in a risk group, try to ask family and friends to help you with groceries"
          ]),
        ],
    );
  }
}

class NagginessSelector extends StatefulWidget {

  @override
  _NagginessState createState() => _NagginessState();
}

class _NagginessState extends State<NagginessSelector> {
  int _nagginess = 1;

  int getNagginess() {
    return _nagginess;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nagginess',
              style: Theme.of(context).textTheme.display1,
            ),
            Slider(
              value: _nagginess.toDouble(),
              min: 1,
              max: 10,
              divisions: 10,
              label: '$_nagginess',
              onChanged: (value) {
                setState(
                  () {
                      _nagginess = value.toInt();
                  },
                );
              },
            ),
          ],
        )
    );
  }
}

abstract class AbstractNudge {
  String getName();
  String getDescription();
  String getEmoji();
  double getNagFrequency();
  String getNudgeText();
}

class Nudge implements AbstractNudge {
  const Nudge({this.name, this.description, this.emoji, this.nagFrequency, this.nudgeTexts});
  final String name;
  final String description;
  final String emoji;
  final double nagFrequency;
  final List<String> nudgeTexts;

  static final _random = new Random();

  @override
  String getName() {
    return name;
  }

  @override
  double getNagFrequency() {
    return nagFrequency;
  }

  @override
  String getEmoji() {
    return emoji;
  }

  @override
  String getDescription() {
    return description;
  }

  @override
  String getNudgeText() {
    return nudgeTexts[_random.nextInt(nudgeTexts.length)];
  }

}

typedef void ActivationChangedCallback(Nudge product, bool inCart);

class ActiveNudgesListItem extends StatelessWidget {
  ActiveNudgesListItem({this.nudge, this.isActive, this.onActivationChanged, this.nagginess})
      : super(key: ObjectKey(nudge));

  final AbstractNudge nudge;
  final bool isActive;
  final ActivationChangedCallback onActivationChanged;
  final int nagginess;


  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return isActive ?
      Theme.of(context).accentColor : Theme.of(context).canvasColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!isActive) return null;

    return TextStyle(
      color: Colors.black54,
    );
  }

  Text _getFrequencyText(BuildContext context) {
    if (!isActive) return null;
    int globalNagginess = 1;
    double effectiveNagginess = globalNagginess * nudge.getNagFrequency();
    return Text(effectiveNagginess.toString() + "/day");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onActivationChanged(nudge, isActive);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(nudge.getEmoji()),
      ),
      title: Text(nudge.getName(), style: _getTextStyle(context)),
      subtitle: Text(nudge.getDescription()),
      trailing: _getFrequencyText(context),
    );
  }
}

class ActiveNudgesList extends StatefulWidget {
  ActiveNudgesList({Key key, this.nudges}) : super(key: key);

  final List<AbstractNudge> nudges;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.

  @override
  _ActiveNudgesListState createState() => _ActiveNudgesListState();
}

class _ActiveNudgesListState extends State<ActiveNudgesList> {
  Set<Nudge> _activeNudges = Set<Nudge>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String nudgeText) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("wink wink"),
          content: Text(nudgeText),
        );
      },
    );
  }


  void _handleNudgeActivationChanged(Nudge nudge, bool wasActive) {
    setState(() {
      if (!wasActive) {
        _activeNudges.add(nudge);
        _scheduleNudge(nudge);
      } else {
        _activeNudges.remove(nudge);
      }
    });
  }

  Expanded _nudgeList(BuildContext context) {
    return Expanded(child:
    ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: widget.nudges.map((AbstractNudge product) {
        return ActiveNudgesListItem(
            nudge: product,
            isActive: _activeNudges.contains(product),
            onActivationChanged: _handleNudgeActivationChanged,
          );
      }).toList(),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nudges'),
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NagginessSelector()));
          },
        )],
      ),
      body: Column(children: [_nudgeList(context)])
    );
  }

  Future _scheduleNudge(AbstractNudge nudge) async {
    double daySeconds = 24.0 * 60.0 * 60.0;
    int globalNagginess = 10; // TODO change
    double effectiveNagginess = globalNagginess * nudge.getNagFrequency();
    double distance = daySeconds / effectiveNagginess;
    if (globalNagginess == 10) {
      distance = 5.0; // they asked for it, probably for demo purposes
    }
    // TODO: try to schedule in 08.00 -- 20.00 range
    var scheduledNotificationDateTime =
      DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('wink-wink-nudges',
        'Wink Wink nudges', 'Notifications keeping you and the world around you healthy!');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    String nudgeText = nudge.getNudgeText();
    await flutterLocalNotificationsPlugin.schedule(
        0,
        nudge.getName(),
        nudgeText,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: nudgeText);

  }
}
