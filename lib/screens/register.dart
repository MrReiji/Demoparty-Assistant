import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _checkboxValue = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedCountry = "Germany"; // Default value for country selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login / Registration", style: GoogleFonts.oswald()),
        backgroundColor: Color(0xFF1F1F1F),
      ),
      drawer: AppDrawer(currentPage: "Register"),
      backgroundColor: Color(0xFF191919),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Login Section
            Text(
              "Login",
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildInputField("Handle", Icons.person),
            _buildPasswordField("Password", _isPasswordVisible, (bool visible) {
              setState(() {
                _isPasswordVisible = visible;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Login action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text("LOG IN", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Not registered yet? Look below!",
                style: GoogleFonts.roboto(color: Colors.grey[400]),
              ),
            ),
            SizedBox(height: 30),

            // Register Section
            Text(
              "Register",
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildInputField("Handle", Icons.person),
            _buildInputField("Group", Icons.group),
            _buildDropdownField("Country", _selectedCountry, (String? newValue) {
              setState(() {
                _selectedCountry = newValue!;
              });
            }),
            _buildInputField("Access Key", Icons.vpn_key),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Scan ticket action
              },
              icon: Icon(FontAwesomeIcons.qrcode, size: 16),
              label: Text("SCAN TICKET"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildPasswordField("Password", _isPasswordVisible, (bool visible) {
              setState(() {
                _isPasswordVisible = visible;
              });
            }),
            _buildPasswordField("Repeat", _isConfirmPasswordVisible, (bool visible) {
              setState(() {
                _isConfirmPasswordVisible = visible;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Register action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text("REGISTER", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[850],
        ),
      ),
    );
  }

  // Helper method to build password fields with visibility toggle
  Widget _buildPasswordField(String label, bool isVisible, Function(bool) toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              toggleVisibility(!isVisible);
            },
          ),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[850],
        ),
      ),
    );
  }

  // Helper method to build dropdown field for country selection
  Widget _buildDropdownField(String label, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[850],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            items: <String>['Germany', 'USA', 'France', 'Japan', 'Other']
                .map<DropdownMenuItem<String>>((String country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(country),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
