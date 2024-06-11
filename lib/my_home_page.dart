import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Appbar"),
      ),
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometrics =
              await _auth.canCheckBiometrics;
          if (canAuthenticateWithBiometrics) {
            try {
              final bool didAuthenticate = await _auth.authenticate(
                localizedReason: "Vui lòng xác minh để đăng nhập vào ứng dụng",
                options: const AuthenticationOptions(
                  biometricOnly: true,
                  useErrorDialogs: false,
                ),
              );
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } on PlatformException catch (e) {
              if (e.code == auth_error.notAvailable) {
                print(e.code);
              } else if (e.code == auth_error.notEnrolled) {
                print(e.code);
              } else if (e.code == auth_error.lockedOut ||
                  e.code == auth_error.permanentlyLockedOut) {
                print(e.code);
              }
            }
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: Icon(
        _isAuthenticated ? Icons.lock_open : Icons.lock,
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const Text(
            "Account Balance",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isAuthenticated)
            const Text(
              "\$ 69,696",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!_isAuthenticated)
            const Text(
              "*****",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
        ],
      ),
    );
  }
}
