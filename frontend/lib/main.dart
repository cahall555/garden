import 'package:coverage/coverage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'view/garden_list.dart';
import 'view/auth_landing.dart';
import 'view/user_create.dart';
import 'components/garden_bottom_nav.dart';
import 'view/journal_list.dart';
import 'view/tags_list.dart';
import 'view/plant_detail.dart';
import 'view/tag_detail.dart';
import 'model/plant.dart';
import 'model/tag.dart';
import 'model/apis/garden_api.dart';
import 'model/apis/account_api.dart';
import 'model/apis/user_api.dart';
import 'model/apis/users_account_api.dart';
import 'model/apis/auth_api.dart';
import 'model/apis/plant_api.dart';
import 'model/apis/ws_api.dart';
import 'model/apis/journal_api.dart';
import 'model/apis/tag_api.dart';
import 'model/apis/plants_tag_api.dart';
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
import 'provider/users_account_provider.dart';
import 'services/repositories/plant_repository.dart';
import 'services/repositories/garden_repository.dart';
import 'services/repositories/user_account_repository.dart';
import 'services/repositories/ws_repository.dart';
import 'services/repositories/journal_repository.dart';
import 'services/repositories/tag_repository.dart';
import 'services/repositories/sync_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/connection_status.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  connectionStatus.initialize();

  connectionStatus.connectionChange.listen((bool isConnected) {
    print('Connection status changed: $isConnected');
  });


  try {
    await dotenv.load(fileName: ".env");
    print('API_URL: ${dotenv.env['API_URL']}');
  } catch (e) {
    print('Failed to load .env file: $e');
  }

  final client = http.Client();
  final storage = const FlutterSecureStorage();
  final gardenApiService = GardenApiService(client);
  final accountApiService = AccountApiService(client);
  final userApiService = UserApiService(client);
  final usersAccountApiService = UsersAccountApiService(client);
  final authApiService = AuthApiService(client, storage);
  final plantApiService = PlantApiService(client);
  final wsApiService = WsApiService(client);
  final journalApiService = JournalApiService(client);
  final tagApiService = TagApiService(client);
  final plantsTagApiService = PlantsTagApiService(client);
  final plantRepository = PlantRepository();
  final gardenRepository = GardenRepository();
  final userAccountRepository = UserAccountRepository();
  final wsRepository = WaterScheduleRepository();
  final journalRepository = JournalRepository();
  final tagRepository = TagRepository();
  final syncLogRepository = SyncLogRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                GardenProvider(gardenApiService, gardenRepository, syncLogRepository)),
        ChangeNotifierProvider(
            create: (context) =>
                PlantProvider(plantApiService, plantRepository, syncLogRepository)),
        ChangeNotifierProvider(
            create: (context) => WsProvider(wsApiService, wsRepository, syncLogRepository)),
        ChangeNotifierProvider(
            create: (context) =>
                JournalProvider(journalApiService, journalRepository, syncLogRepository)),
        ChangeNotifierProvider(
            create: (context) => TagProvider(tagApiService, tagRepository, syncLogRepository)),
        ChangeNotifierProvider(
            create: (context) => PlantsTagProvider(plantsTagApiService)),
        ChangeNotifierProvider(
            create: (context) =>
                UserProvider(userApiService, userAccountRepository)),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(authApiService: authApiService)),
        ChangeNotifierProvider(
            create: (context) =>
                AccountProvider(accountApiService, userAccountRepository)),
        ChangeNotifierProvider(
            create: (context) => UsersAccountsProvider(usersAccountApiService)),
      ],
      child: MyApp(tagApiService: tagApiService, tagRepository: tagRepository),
    ),
  );
     // connectionStatus.dispose();
}

class MyApp extends StatefulWidget {
  final TagApiService tagApiService;
  final TagRepository tagRepository;

  const MyApp({
    Key? key,
    required this.tagApiService,
    required this.tagRepository,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;

  @override
  initState() {
    super.initState();
    //TODO: is this timer idea a good idea, how should it be implemented? The current issue appears to be with the get current account api call.
/*    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final accountProvider = context.read<AccountProvider>();
      final currentAccount = await accountProvider.currentAccountId();

      if(currentAccount != null) {
	      final accountId = currentAccount.id;
	context.read<GardenProvider>().syncWithBackend(accountId);
      } else {
	print('No account found');
      }
    }); */ 
  }

  @override
  void dispose() {
  //  _timer?.cancel();
    super.dispose();
  }

//  MyApp({required this.tagApiService, required this.tagRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garden Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Color(0XFFFED16A),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0XFF987D3F),
          selectionHandleColor: Color(0XFF987D3F),
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/plantDetail': (context) {
          final Plant plant =
              ModalRoute.of(context)!.settings.arguments as Plant;
          heroTag:
          'plantDetailHero-${plant.id}';
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) =>
                      TagProvider(widget.tagApiService, widget.tagRepository, context.read<SyncLogRepository>())),
            ],
            child: PlantDetail(plant: plant),
          );
        },
        '/tagDetail': (context) => TagDetail(
              tag: ModalRoute.of(context)!.settings.arguments as Tag,
            ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermission();
    });
  }

  void requestPermission() async {
    final statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();
    print(statuses);
    setState(() {
      _permissionsGranted = statuses.values.every((status) => status.isGranted);
    });

    if (!_permissionsGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Error'),
          content: const Text('Please enable the required permissions.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LandingPage(),
    );
  }
}
