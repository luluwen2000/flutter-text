import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple Page', // Updated title for the app itself
      theme: ThemeData(
        // Using a simple theme, you can customize this further
        primarySwatch: Colors.blue, // You can change the primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Simple Input Page'), // Title for the AppBar
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
  // Controller to manage the text field's content
  final TextEditingController _textController = TextEditingController();

  // Function to handle button press (currently just prints the text)
  void _submitText() {
    // You can add logic here for what happens when the button is pressed
    // For example, send the text to an API, save it locally, etc.
    print('Submitted text: ${_textController.text}');
    // Optionally clear the text field after submission
    // _textController.clear();
    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text Submitted: ${_textController.text}')),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set the AppBar background color
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Set the title of the AppBar from the widget's properties
        title: Text(widget.title),
      ),
      body: Center( // Center the content vertically and horizontally
        child: Padding(
          // Add some padding around the column content
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Center the children vertically within the Column
            mainAxisAlignment: MainAxisAlignment.center,
            // Align children horizontally to the center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // The title text
              const Text(
                'Text', // The title content
                style: TextStyle(
                  fontSize: 48.0, // Make the text big
                  fontWeight: FontWeight.bold, // Make it bold
                  color: Colors.black, // Set the text color to black
                ),
              ),
              // Add some space between the title and the text field
              const SizedBox(height: 30.0),
              // The rounded text field
              TextField(
                controller: _textController, // Assign the controller
                decoration: InputDecoration(
                  hintText: 'Enter text here...', // Placeholder text
                  // Style the border to be rounded
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0), // Adjust radius for roundness
                    borderSide: const BorderSide(
                      color: Colors.grey, // Border color
                    ),
                  ),
                  // Style the border when the field is focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, // Use theme color when focused
                      width: 2.0,
                    ),
                  ),
                  // Add some padding inside the text field
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
              // Add some space between the text field and the button
              const SizedBox(height: 20.0),
              // The submission button
              ElevatedButton(
                onPressed: _submitText, // Call the _submitText function on press
                style: ElevatedButton.styleFrom(
                  // Add padding within the button
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  // Make the button shape rounded
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Match text field roundness
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16.0), // Set button text size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
