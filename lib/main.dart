import 'package:flutter/material.dart';
import 'package:khazana/MutualFund/Dashboard.dart';
import 'package:khazana/model/getDetails.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vlwiqyntbwxhkcyzdsil.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZsd2lxeW50Ynd4aGtjeXpkc2lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI3OTIyNTAsImV4cCI6MjA1ODM2ODI1MH0.1IU1r_MeEST_9XhAdiPXvW05X_PZpUNPr6oP8lLCwFg',
  );
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FundProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: 
  const MyApp()));
}
// void main(){
//   runApp(
//     const MyApp()
//   );
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userController = TextEditingController();
  bool isLogin = true;
  String? error;

Future<void> signUp(BuildContext context) async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final username = _userController.text.trim();
  final supabase = Supabase.instance.client;

  try {
    // Check if user already exists BEFORE signing up
    final existingUserResponse = await supabase
        .from('userdetails')
        .select()
        .eq('emailId', email)
        .maybeSingle();

    if (existingUserResponse != null) {  // No .data needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User already exists with this email.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Sign up the user
    final signUpResponse = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = signUpResponse.user?.id;

    if (userId == null) {
      print("User is not logged in or needs verification!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email to verify your account.'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    // Insert user into the database
    await supabase.from('userdetails').insert({
      'user_id': userId,
      'userName': username,
      'emailId': email,
      'userPassword':password,
      'created_at': DateTime.now().toIso8601String()
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User registered successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      isLogin = true;
    });

  } catch (e) {
    print("Error: ${e.toString()}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<void> signIn(BuildContext context) async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  try {
    final response = await Supabase.instance.client
        .from('userdetails')
        .select()
        .eq('emailId', email)
        .eq('userPassword', password)
        .maybeSingle();
print(response);
    if (response != null) {
      // Success - Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height:300),
            Center(
              child: Text(isLogin ? 'Sign In' : 'Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),),
            ),
            if (!isLogin)
              TextField(
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                controller: _userController,
                decoration: const InputDecoration(labelText: 'User Name',),
              ),
            TextField(
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
           Container(
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              color:isLogin? Colors.green:Colors.blue,
              borderRadius: BorderRadius.circular(8)
            ),
            child:  TextButton(
              onPressed: () {
                if (isLogin) {
                  signIn(context);
                } else {
                  signUp(context);
                }
              },
              child: Text(isLogin ? 'Sign In' : 'Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
           ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin
                  ? "Don't have an account? Sign Up"
                  : "Already have an account? Sign In",style: TextStyle(color: Colors.amber),),
            )
          ],
        ),
      ),
    );
  }
}
