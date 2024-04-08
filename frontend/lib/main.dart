import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view/garden_list.dart';
import 'package:provider/provider.dart';
import 'provider/garden_provider.dart';
import 'provider/plant_provider.dart';

void main() {
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GardenProvider()),
      ChangeNotifierProvider(create: (context) => PlantProvider()),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Garden Journal'),
    );
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
      appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
               title: Text(widget.title,
			style: GoogleFonts.homemadeApple( 
				textStyle: TextStyle(
					fontWeight: FontWeight.bold,
					color: Colors.green[800],
			),
		),
      	),
	),
	drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Garden'),
            ),
            ListTile(
              title: const Text('Journal'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Tags'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
     	body: Center(

               child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

		Expanded(
            child: MaterialApp( 
	    	debugShowCheckedModeBanner: false,
		initialRoute: '/',
        	routes: {
          		'/': (context) => GardenList(),
	  	},
	    ),
          ),
	    
          ],
        ),
      ),
          );
  }
}
