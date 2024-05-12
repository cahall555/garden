import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/garden_list.dart';
import 'view/auth_landing.dart';
import 'view/user_create.dart';
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
import 'provider/user_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/account_provider.dart';
import 'provider/farm_provider.dart';
import 'provider/users_account_provider.dart';
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
	ChangeNotifierProvider(create: (context) => UserProvider()),
	ChangeNotifierProvider(create: (context) => AuthProvider()),
	ChangeNotifierProvider(create: (context) => AccountProvider()),
	ChangeNotifierProvider(create: (context) => FarmProvider()),
	ChangeNotifierProvider(create: (context) => UsersAccountsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
//    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: LandingPage()//authProvider.isLoggedIn ? AuthLanding() : UserCreate(),
    );
  }
}



//class MyApp extends StatelessWidget {
//  const MyApp({super.key});

//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Garden Journal',
//      theme: ThemeData(
//        textTheme: GoogleFonts.tavirajTextTheme(),
//        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
//        useMaterial3: true,
//      ),
//      home: AuthLanding()//const MyHomePage(title: 'Garden Journal'),
//    );
//    Image.asset('assets/herb_garden.webp');
//  }
//}

//class MyHomePage extends StatefulWidget {
//  const MyHomePage({super.key, required this.title});
//  final String title;

//  @override
//  State<MyHomePage> createState() => _MyHomePageState();
//}

//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        title: Text(
//          widget.title,
//          style: GoogleFonts.homemadeApple(
//            textStyle: TextStyle(
//              fontWeight: FontWeight.bold,
//              color: Colors.green[800],
//            ),
//          ),
//        ),
//      ),
//      body: Container(
//        decoration: const BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage(
//                'assets/herb_garden.webp'), //Image.asset('assets/' + ('herb_garden.webp')),
//            fit: BoxFit.cover,
//          ),
//        ),
//      ),
//      bottomNavigationBar: BottomNavigation(),
//    );
//  }
//}
