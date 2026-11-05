/*
Part 1: super.key
super.key passes the key to the parent StatefulWidget constructor.
The key is used by Flutter to identify the widget in the widget tree.

The Key passed through super.key identifies the widget itself.
GlobalKey<FormState> (_keyForm) is used to access the FormState
and call validate() on the form.

Part 2: const
const makes Flutter faster because constant widgets can be reused
instead of creating new widget objects during rebuilds.

Part 3: Private State
The underscore (_) makes a class, field, or method private
within its Dart library.
State classes should be private because they are implementation details
and should not be accessed directly from other files.

Part 5: push vs go
push adds a new page on top of the navigation stack.
go changes the current route and replaces the current navigation stack.

Test 1:
Using push to Signup and pop to Login works.
Login stays in the stack and is not disposed.

Test 2:
Using go to Signup and then pop does not work as expected
because go replaces the previous route stack.
There is no previous Login page to pop back to.

Test 3:
Using go to Signup and then go to Login works
because go navigates directly to the Login route.

Test 4:
Using push to Signup and pressing the AppBar back arrow works
because it pops Signup and returns to Login.

With push, Login is not disposed when Signup opens.
With go, Login is disposed because its route is replaced.
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (username == Database.username &&
          password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong info")),
        );
      }
    }
  }

  @override
  void initState() {
    print(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _keyForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "please enter valid username ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (((value?.length) ?? 0) < 6) {
                        return "please enter valid password";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _inputCheck,
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await context.push<bool>("/signup");

                      if (result == true && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account created, please login"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
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
}

