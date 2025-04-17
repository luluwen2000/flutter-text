import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // Change to track TextEntry objects instead of indices
  final Set<TextEntry> _selectedEntries = {};

  // Function to handle button press (currently just prints the text)
  void _submitText() {
    if (_textController.text.trim().isEmpty) {
      _textFocusNode.requestFocus();
      return;
    }
    
    setState(() {
      _entries.insert(0, TextEntry(
        text: _textController.text.trimRight(),
        timestamp: DateTime.now(),
      ));
    });
    
    // Completely reset the TextField state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textController.value = TextEditingValue.empty;
      _textFocusNode.requestFocus();
    });
  }

  // Update selection helpers to work with TextEntry objects
  void _toggleSelection(TextEntry entry) {
    setState(() {
      if (_selectedEntries.contains(entry)) {
        _selectedEntries.remove(entry);
      } else {
        _selectedEntries.add(entry);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEntries.clear();
    });
  }

  // Add method to generate unique URL for an entry
  String _generateEntryUrl(TextEntry entry) {
    // This is a example URL format - adjust the base URL as needed
    return 'myapp://text/${entry.id}';
  }

  // Add method to copy URL to clipboard
  void _copyEntryLink(TextEntry entry) {
    final url = _generateEntryUrl(entry);
    Clipboard.setData(ClipboardData(text: url)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    });
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
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.enter) {
                      if (event.isShiftPressed) {
                        // Manually insert newline at current cursor position
                        final currentText = _textController.text;
                        final selection = _textController.selection;
                        final newText = currentText.replaceRange(
                          selection.start,
                          selection.end,
                          '\n',
                        );
                        _textController.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(
                            offset: selection.start + 1,
                          ),
                        );
                      } else {
                        // Prevent default enter behavior and submit
                        _submitText();
                      }
                      // Prevent the default enter behavior
                      return;
                    }
                  }
                },
                child: TextField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  // Prevent the default enter behavior
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    hintText: 'Enter text here... (Shift+Enter for new line)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
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
              // Add action bar when items are selected
              if (_selectedEntries.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedEntries.length} selected',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          // Example action buttons - to be implemented later
                          IconButton(
                            icon: const Icon(Icons.visibility_off),
                            onPressed: () {
                              // Implement hide functionality
                            },
                            tooltip: 'Hide selected',
                          ),
                          IconButton(
                            icon: const Icon(Icons.local_offer),
                            onPressed: () {
                              // Implement tag functionality
                            },
                            tooltip: 'Add tags',
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _clearSelection,
                            tooltip: 'Clear selection',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    final isSelected = _selectedEntries.contains(entry);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      // Add subtle highlight when selected
                      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                      child: InkWell(
                        onLongPress: () => _toggleSelection(entry),
                        onTap: _selectedEntries.isNotEmpty 
                          ? () => _toggleSelection(entry)
                          : null,
                        child: Row(
                          children: [
                            // Subtle checkbox
                            SizedBox(
                              width: 40,
                              child: Opacity(
                                opacity: _selectedEntries.isNotEmpty || isSelected ? 1.0 : 0.2,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggleSelection(entry),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                            // Text content
                            Expanded(
                              child: ListTile(
                                title: Text(entry.text),
                                subtitle: Text(
                                  _formatTimestamp(entry.timestamp),
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                            // Add copy link button
                            IconButton(
                              icon: const Icon(Icons.link, size: 20),
                              onPressed: () => _copyEntryLink(entry),
                              tooltip: 'Copy link to entry',
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
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

// Update TextEntry class to have a unique ID
class TextEntry {
  final String id;  // Add unique ID
  final String text;
  final DateTime timestamp;

  TextEntry({
    required this.text,
    required this.timestamp,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString();  // Generate unique ID on creation

  // Compare by ID for equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;  // Compare IDs

  @override
  int get hashCode => id.hashCode;  // Use ID for hash
}
