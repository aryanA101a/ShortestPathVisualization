import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shortest_path/home_page_viewmodel.dart';
import 'package:shortest_path/locator.dart';
import 'package:shortest_path/my_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<HomePageViewModel>(),
        )
      ],
      child: MaterialApp(
        title: 'Shortest Path',
        home: const MyHomePage(),
      ),
    );
  }
}
