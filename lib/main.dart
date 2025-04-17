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
      // Add this line to remove the debug banner
      debugShowCheckedModeBanner: false,
      // Removed the title parameter as it's no longer used by MyHomePage
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Removed the title parameter as it's no longer needed
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controller to manage the text field's content
  final TextEditingController _textController = TextEditingController();
  // Add a FocusNode
  final FocusNode _textFocusNode = FocusNode();
  
  // Add a list to store text entries with timestamps
  final List<TextEntry> _entries = [];

  // Function to handle button press (currently just prints the text)
  void _submitText() {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _entries.insert(0, TextEntry(
        text: _textController.text,
        timestamp: DateTime.now(),
      ));
    });
    
    _textController.clear();
    _textFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    // Dispose the focus node when the widget is disposed
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar has been removed from here
      body: Center( // Center the content vertically and horizontally
        child: Padding(
          // Add some padding around the column content
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Center the children vertically within the Column
            mainAxisAlignment: MainAxisAlignment.start, // Changed to start alignment
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
                focusNode: _textFocusNode, // Add this line
                // Add onSubmitted handler
                onSubmitted: (_) => _submitText(),
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
              const SizedBox(height: 20.0),
              // Add Expanded widget with ListView to show entries
              Expanded(
                child: ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Text(entry.text),
                        subtitle: Text(
                          _formatTimestamp(entry.timestamp),
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }
}

// Add a class to represent a text entry
class TextEntry {
  final String text;
  final DateTime timestamp;

  TextEntry({
    required this.text,
    required this.timestamp,
  });
}
