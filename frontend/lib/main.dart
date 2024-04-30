import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/garden_list.dart';
import 'components/garden_bottom_nav.dart';
import 'view/journal_list.dart';
import 'view/tags_list.dart';
import 'package:provider/provider.dart';
import 'provider/garden_provider.dart';
import 'provider/plant_provider.dart';
import 'provider/tag_provider.dart';
import 'provider/plants_tag_provider.dart';
import 'provider/ws_provider.dart';
import 'provider/journal_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
    print('API_URL: ${dotenv.env['API_URL']}');
  } catch (e) {
    print('Failed to load .env file: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GardenProvider()),
        ChangeNotifierProvider(create: (context) => PlantProvider()),
        ChangeNotifierProvider(create: (context) => WsProvider()),
        ChangeNotifierProvider(create: (context) => JournalProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => PlantsTagProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garden Journal',
      theme: ThemeData(
        textTheme: GoogleFonts.tavirajTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Garden Journal'),
    );
    Image.asset('assets/herb_garden.webp');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      bottomNavigationBar: BottomNavigation(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: GoogleFonts.homemadeApple(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/herb_garden.webp'), //Image.asset('assets/' + ('herb_garden.webp')),
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),

      //  body: Center(
      //  child: Column(
      //  mainAxisAlignment: MainAxisAlignment.center,
      //children: <Widget>[
      //Expanded(
      //child: MaterialApp(
      //debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      // routes: {
      // '/': (context) => GardenList(),
      //},
      //),
      //),
      // ],
      //),
      // ),
      //);

      //  body: Center(
      //  child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // children: <Widget>[
      // Expanded(
      // child: MaterialApp(
      // debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      // routes: {
      // '/': (context) => GardenList(),
      //},
      //),
      //),
      //  ],
      // ),
      //),
    );
  }
}
