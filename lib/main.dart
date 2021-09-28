import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app_task/screens/EditInfo_screen.dart';
import 'package:login_app_task/screens/HomePage_screen.dart';
import 'package:login_app_task/screens/SignUp_screen.dart';
import 'package:login_app_task/screens/splashScreen.dart';
import 'Bloc/signIn_bloc/SignIn_bloc.dart';
import 'Bloc/signUp_bloc/SignUp_bloc.dart';
import 'Repository/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
        UserRepository(firebaseAuth: FirebaseAuth.instance);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigninBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(userRepository: userRepository),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          LoginPage.routeName: (context) => LoginPage(),
          SignUpForm.routeName: (context) => SignUpForm(),
          HomePage.routeName: (context) => HomePage(),
          EditInfo.routeName: (context) => EditInfo()
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  SigninBloc? signinBloc;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    signinBloc = BlocProvider.of<SigninBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocListener<SigninBloc, SigninState>(
                      listener: (context, state) {
                    if (state is SigninInitial) {
                      Center(child: Text('Waiting'));
                    }

                    if (state is SigninSucceed) {
                      Navigator.pushReplacementNamed(
                          context, HomePage.routeName);
                    }
                  }, child: BlocBuilder<SigninBloc, SigninState>(
                    builder: (context, state) {
                      if (state is SigninLoading)
                        return Center(child: CircularProgressIndicator());
                      else if (state is SigninFailed)
                        return // just in case of an unexpected error
                            Center(child: Text(state.message));
                      else
                        return Container();
                    },
                  )),
                  Container(
                      width: width * 0.3,
                      height: height * 0.3,
                      child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 100,
                          backgroundImage: NetworkImage(
                              'https://cdn.dribbble.com/users/915711/screenshots/5827243/weather_icon3.png'))),
                  SizedBox(height: 25),
                  Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 25),
                  TextField(
                      autofocus: false,
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  TextField(
                      autofocus: false,
                      controller: passwordController,
                      obscureText: _obscureText,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.red,
                      height: 50,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        signinBloc!.add(SignInPressed(
                            email: usernameController.text,
                            password: passwordController.text));
                      },
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, SignUpForm.routeName),
                          child: Text('Sign up.'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
