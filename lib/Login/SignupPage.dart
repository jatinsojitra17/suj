import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:sujin/Login/LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  bool _isIncorrect = false;
  String _selectedRole = 'merchant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF37BB9B),
              Color(0xFF71D9E2), // Lighter shade of the brand color
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // Set maximum width for content
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "assets/Sujin.png",
                    height: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: 30),

                  DropDown<String>(
                    items: [
                      'merchant',
                      'member',
                    ],
                    hint: Text('Select Role'),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _isIncorrect
                          ? Colors.red.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _isIncorrect
                          ? Colors.red.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedRole == 'merchant')
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: _isIncorrect
                            ? Colors.red.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                      child: TextFormField(
                        controller: _companyNameController,
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                          prefixIcon: Icon(Icons.business, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Call a function to handle signup logic
                      _handleSignup();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Signup',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).primaryColor;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.3),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Added spacing
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.white;
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).primaryColor;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.3),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    // Check if all required fields are filled
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        (_selectedRole == 'merchant' && _companyNameController.text.isEmpty)) {
      Fluttertoast.showToast(
        msg: 'Please fill all required fields',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      // Create user in FirebaseAuth

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get user ID from FirebaseAuth
      // String userId = userCredential.user!.uid;

      // Store user details in "users" collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_emailController.text)
          .set({
        'email': _emailController.text,
        'role': _selectedRole,
        'password': _passwordController.text,
        if (_selectedRole == 'merchant')
          'company name': _companyNameController.text,
      });

      // Check if user exists in "Merchants" collection
      DocumentSnapshot merchantDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_emailController.text)
          .get();
      if (merchantDoc.exists) {
        // Update existing document in "Merchants" collection
        await merchantDoc.reference.update({
          'email': _emailController.text,
          'password': _passwordController.text,
          'company name': _companyNameController.text,
          'role': _selectedRole,
        });
      } else {
        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection('Users');
        String documentId = _emailController.text;
        collectionRef.doc(documentId).set({
          'email': _emailController.text,
          'password': _passwordController.text,
          'company name': _companyNameController.text,
          'role': _selectedRole,
          // Add more fields as needed
        }).then((_) {
          print('Document added with ID: $documentId');
        }).catchError((error) {
          print('Error adding document: $error');
        });
      }

      Fluttertoast.showToast(
        msg: 'Signup successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Signup failed: $e');
      Fluttertoast.showToast(
        msg: 'Signup failed: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 5,
      );
    }
  }
}





// create a node apis to store details of bills which includes bill number,bill date,customer info,products info,discount info