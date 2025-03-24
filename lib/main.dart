import 'package:flutter/material.dart'; //importing this package because I want to use it

void main() {//main function
  runApp(//run app
    MaterialApp( //Wrapping it in MaterialApp
      home: FactorApp(),
    ),
  );
}


class FactorApp extends StatefulWidget {
  const FactorApp({super.key});
// `FactorApp` is a StatefulWidget because it changes over time
  @override
  State<FactorApp> createState()  => _FactorAppState();  // `createState` creates an instance of `_FactorAppState` to manage state
}

class _FactorAppState extends State<FactorApp> {// `_FactorAppState` holds the state for `FactorApp`
  final TextEditingController _controller = TextEditingController(); // `TextEditingController` is used to retrieve the value from the TextField
  List<int> _factors = [];  // `_factors` stores the list of calculated factors based on the user's input.


//Function to calculate factors of the number inserted
  void _calculateFactors() {
    int num = int.tryParse(_controller.text) ?? 0;
    if (num <= 0) {
      setState(() {
        _factors = [];
      });
      return;
    }

    List<int> factors = [];
    for (int i = 1; i <= num; i++) {
      if (num % i == 0) {
        factors.add(i);
      }
    }

    setState(() {
      _factors = factors;
    });
  }

  @override
  Widget build(BuildContext context) {
    // `Scaffold` provides the basic structure for the app's visual interface
    return Scaffold(
      // `AppBar` is the top navigation bar of the app
      appBar: AppBar(   title: Text('Factor Finder')), // Title of the app shown in the AppBar
      body: LayoutBuilder( // Responsive widget to adapt to different screen sizes
        builder: (context,constraints){
      return Padding(
        padding: const EdgeInsets.all(16.0), // 16-pixel padding on all sides
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space for the column
          children: [
            // `TextField` allows the user to input a number
            TextField(
              controller: _controller, // Controller to manage input value
              keyboardType: TextInputType.number, // Keyboard for numeric input
              decoration: InputDecoration(
                labelText: 'Enter a number',
                // Placeholder text in the input field
                border: OutlineInputBorder(), // Adds a border around the input field
              ),
            ),
            SizedBox(height: 20), // Adds vertical spacing of 20 pixels
            // `ElevatedButton` creates a button with elevated style
            ElevatedButton(
              onPressed: _calculateFactors,
              // Calls `_calculateFactors()` when pressed
              child: Text('Find Factors'), // Text on the button
            ),
            SizedBox(height: 20), // Adds vertical spacing of 20 pixels
            // If `_factors` list is empty, display a message
            _factors.isEmpty
                ? Text(
                'No factors to display.') // Message when there are no factors
                : Expanded( // `Expanded` makes the list take available space
              // `ListView.builder` creates a scrollable list
              child: ListView.builder(
                itemCount: _factors.length, // Number of items in the list
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _factors[index]
                          .toString(), // Display each factor as a list item
                    )
                  );
                },
              ),
            ),
          ],
        ),
      );
        },
      ),
    );
  }
}
