import 'package:firebase_core/firebase_core.dart';
import 'package:todo/index.dart';
import 'package:todo/login/login-provider.dart';
import 'package:todo/login/login.dart';
import 'package:todo/provider/provider.dart';
import 'package:todo/user-utils/cred.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LoginProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Credential(),
        ),
        ChangeNotifierProxyProvider<Credential,Manager>(
          create: (context) => Manager(cred: Credential()),
          update: (context, cred, _) => Manager(cred: cred),
        ),
      ],
      child: Consumer<Credential>(
        builder: (context, cred, _) {
          return FutureBuilder<bool>(
              future: cred.tryAutoLogin(),
              builder: (context, snapshot) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    fontFamily: "Raleway",
                    primarySwatch: Colors.blue,
                  ),
                  home: cred.isLogin
                      ? Display()
                      : snapshot.connectionState == ConnectionState.waiting
                          ? LoadingScreen()
                          : Login(),
                );
              });
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
