import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter BLoC Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔹 BlocBuilder (Rebuilds when counter changes)
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  'Counter: ${state.count}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                );
              },
            ),

            SizedBox(height: 20),

            // 🔹 BlocSelector (Rebuilds ONLY when even/odd changes)
            BlocSelector<CounterBloc, CounterState, bool>(
              selector: (state) => state.count % 2 == 0,
              builder: (context, isEven) {
                return Text(
                  isEven ? "Even Number" : "Odd Number",
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                );
              },
            ),

            SizedBox(height: 20),

            // 🔹 BlocListener (Shows Snackbar when counter reaches 10)
            BlocListener<CounterBloc, CounterState>(
              listenWhen: (previous, current) => current.count == 10,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Counter reached 10!")),
                );
              },
              child: SizedBox.shrink(), // Empty widget, just for listening
            ),

            SizedBox(height: 30),

            // 🔹 BlocConsumer (Handles UI & Side-effects together)
            BlocConsumer<CounterBloc, CounterState>(
              listenWhen: (previous, current) => current.count == 5,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Counter reached 5!")),
                );
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () => context.read<CounterBloc>().add(IncrementCounter()),
                  child: Text('Increment'),
                );
              },
            ),

            SizedBox(height: 20),

            // 🔹 Reset Button (Uses context.read to access Bloc)
            ElevatedButton(
              onPressed: () => context.read<CounterBloc>().add(ResetCounter()),
              child: Text('Reset Counter'),
            ),

            SizedBox(height: 20),

            // 🔹 Using context.select (Only listens to counter value)
            Builder(
              builder: (context) {
                final counter = context.select<CounterBloc, int>((bloc) => bloc.state.count);
                return Text("Counter (using select): $counter");
              },
            ),

          ],
        ),
      ),
    );
  }
}
