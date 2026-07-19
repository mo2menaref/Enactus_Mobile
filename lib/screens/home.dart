import 'package:flutter/material.dart';
import '/widgets/custom_enactus_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enactus: Layouts & Widgets"),
        backgroundColor: Colors.blue[900],
      ),
      // Padding adds space around the entire body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("1. Row Layout", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Tasks Completed:'),
                Text(
                  '$_counter',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
            const Divider(height: 10),

            const Text("2. Stack Layout", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                // Bottom layer
                Container(height: 100, width: double.infinity, color: Colors.grey[300]),
                // Middle layer
                const Text("I am in the middle!", style: TextStyle(fontSize: 18)),
                // Top layer (Positioned)
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.star, color: Colors.orange, size: 30),
                ),
              ],
            ),
            const Divider(height: 30),

            const Text("3. Expanded vs Flexible", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                // Flexible wraps content tightly if it's small, or takes space if needed
                Flexible(
                  child: Container(
                    height: 50,
                    color: Colors.red[200],
                    child: const Center(child: Text("Flexible (Wrap)")),
                  ),
                ),
                const SizedBox(width: 10), // Spacing
                // Expanded FORCES the widget to fill all remaining space
                Expanded(
                  child: Container(
                    height: 80,
                    color: Colors.green[200],
                    child: const Center(child: Text("Expanded (Fill Space)")),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),

            const Text("4. Reusable Custom Widgets", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Calling it once
            const CustomEnactusCard(
              title: "Mobile Development Team",
              cardColor: Colors.blue,
            ),
            const SizedBox(height: 10), // Spacing

            // Calling it twice (Reusability in action!)
            const CustomEnactusCard(
              title: "Backend Development Team",
              cardColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}