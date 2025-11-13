import 'package:flutter/material.dart';
import 'package:vpn_checker/vpn_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isVpnActive;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkVpnStatus();
  }

  Future<void> _checkVpnStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bool isActive = await VpnChecker.isVpnActive();
      setState(() {
        _isVpnActive = isActive;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VPN Checker Example'),
          elevation: 2,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isVpnActive == true
                      ? Icons.vpn_lock
                      : _isVpnActive == false
                          ? Icons.vpn_lock_outlined
                          : Icons.help_outline,
                  size: 100,
                  color: _isVpnActive == true
                      ? Colors.green
                      : _isVpnActive == false
                          ? Colors.grey
                          : Colors.orange,
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_errorMessage != null)
                  Column(
                    children: [
                      const Text(
                        'Error checking VPN status',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Text(
                        _isVpnActive == true ? 'VPN is Active' : 'VPN is Not Active',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _isVpnActive == true ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isVpnActive == true
                            ? 'Your device is currently using a VPN connection.'
                            : 'Your device is not using a VPN connection.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _checkVpnStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

