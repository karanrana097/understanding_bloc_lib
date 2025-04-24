
import 'package:bloc_concepts/counter_bloc.dart';
import 'package:flutter/material.dart';

import 'dart:async' as async;


void main() async {
  // Bloc.observer = SimpleBlocObserver();
  //
  // final cubit = CounterCubit();
  //
  // //await Future.delayed(Duration(seconds: 2));
  // cubit.increment();
  //
  // //await Future.delayed(Duration(seconds: 2));
  // cubit.increment();
  //
  // //await Future.delayed(Duration(seconds: 2));
  // cubit.increment();
  //
  // cubit.close();

  // final bloc = CounterBloc();
  //
  // var timer=  async.Timer.periodic(Duration(milliseconds :500) ,(_){
  //     print(bloc.state);
  // });
  //
  // var subscription = bloc.stream.listen((data){
  //    print("Bloc's data via stream is ${data}");
  // });
  //
  //
  // bloc.add(CounterIncrementPressed());
  // await async.Future.delayed(Duration(milliseconds: 500));
  // bloc.add(CounterIncrementPressed());
  // await async.Future.delayed(Duration(milliseconds: 500));
  //
  // bloc.add(CounterIncrementPressed());
  //
  // await async.Future.delayed(Duration(milliseconds: 500));
  //
  //
  //
  // timer.cancel();

  final bloc = CounterBloc();
  final bloc2 = CounterBloc();
  //final subscription = bloc.stream.listen(print); // 1
  bloc.add(CounterIncrementPressed());
  bloc.add(CounterIncrementPressed());
  bloc.add(CounterIncrementPressed());
  bloc2.add(CounterIncrementPressed());
  // CounterBloc()
  //   ..add(CounterIncrementPressed())
  //   ..add(CounterIncrementPressed())
  //   ..add(CounterIncrementPressed())
  //   ..close();

 // await subscription.cancel();
  bloc.close();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
