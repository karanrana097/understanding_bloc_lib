# 📘 Flutter BLoC (Cubit & Bloc) - Notes & Best Practices

## 🚀 Introduction
This document serves as a comprehensive guide for understanding and using the BLoC (Business Logic Component) library in Flutter. It covers both `Cubit` and `Bloc` approaches with examples, tips, and advanced features.

---

## 📦 Bloc vs Cubit
- **Cubit** is a simpler version of Bloc that emits states without events.
- **Bloc** uses events to trigger state changes, offering more structured control.

---

## 🧪 Getting Started with Cubit

### 🔨 Create a Cubit
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}
```

### 🧑‍💻 Using Cubit
```dart
final cubit = CounterCubit();
print(cubit.state);
cubit.increment();
print(cubit.state);
cubit.close();
```

### 🔍 Stream Listener Example
```dart
final subscription = cubit.stream.listen(print);
cubit.increment();
await subscription.cancel();
cubit.close();
```

### 🔄 Track Changes
```dart
@override
void onChange(Change<int> change) {
  super.onChange(change);
  print(change);
}
```

### ❌ Handle Errors
```dart
@override
void onError(Object error, StackTrace stackTrace) {
  print('$error, $stackTrace');
  super.onError(error, stackTrace);
}
```

---

## ⚙️ BlocObserver
```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) => print('$change');

  @override
  void onTransition(Bloc bloc, Transition transition) => print('$transition');

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) => print('$error');
}
```

### ✅ Initialize Observer
```dart
void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}
```

---

## 🔁 Using Bloc

### 📦 Create Bloc
```dart
sealed class CounterEvent {}
class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}
```

### 🚀 Use Bloc
```dart
bloc.add(CounterIncrementPressed());
await Future.delayed(Duration.zero);
```

### 🧠 Track Transitions
```dart
@override
void onTransition(Transition<CounterEvent, int> transition) => print(transition);
```

---

## 🔍 Bloc Widgets

### ✅ BlocBuilder
```dart
BlocBuilder<BlocA, BlocAState>(
  builder: (context, state) {
    return Text("State: \$state");
  },
)
```

### 🎯 BlocSelector
```dart
BlocSelector<BlocA, BlocAState, int>(
  selector: (state) => state.count,
  builder: (context, count) => Text("Count: \$count"),
)
```

### ⚖️ BlocListener & BlocConsumer
```dart
BlocListener<BlocA, BlocAState>(
  listener: (context, state) => showSnackBar(context, "State changed!"),
  child: ChildWidget(),
)

BlocConsumer<BlocA, BlocAState>(
  listener: (context, state) => {},
  builder: (context, state) => Container(),
)
```

---

## 🧪 Event Transformers

### 🧹 debounceTime
```dart
on<SearchEvent>(
  (event, emit) => // your logic,
  transformer: (events, mapper) => events.debounceTime(Duration(milliseconds: 300)).switchMap(mapper),
)
```

### ⏳ throttleTime
```dart
on<ButtonPressEvent>(
  (event, emit) => // handle tap,
  transformer: (events, mapper) => events.throttleTime(Duration(seconds: 1)).switchMap(mapper),
)
```

### 📦 buffer
```dart
on<UserActionEvent>(
  (event, emit) => // handle batched events,
  transformer: (events, mapper) => events.bufferTime(Duration(seconds: 5)).asyncExpand(mapper),
)
```

---

## 🧱 BlocProvider Patterns

### 💧 Basic Usage
```dart
BlocProvider(
  create: (context) => MyBloc(),
  child: MyWidget(),
)
```

### 🔄 MultiBlocProvider
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => BlocA()),
    BlocProvider(create: (_) => BlocB()),
  ],
  child: MyApp(),
)
```

---

## 🧠 Pro Tips

- Use `context.read<BlocA>()` to access Bloc without listening.
- Use `context.watch<BlocA>()` for reactive state tracking.
- Use `context.select((BlocA bloc) => bloc.state.someField)` for precise rebuilds.
- Use `BlocProvider.value` for reusing an already instantiated Cubit/Bloc across routes.
- Always close your Cubits/Blocs to prevent memory leaks.
- Use `BlocOverrides.runZoned()` for custom observers in tests.

---

## 🧭 Navigation with BlocProvider
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<CounterCubit>(context),
      child: SecondScreen(),
    ),
  ),
);
```

### 🧩 Named Routes Example
```dart
routes: {
  '/': (context) => BlocProvider.value(value: _counterCubit, child: HomeScreen()),
  '/second': (context) => BlocProvider.value(value: _counterCubit, child: SecondScreen()),
}
```

---

## 🛠️ Shortcuts & Misc
- `Ctrl + Shift + F1`: Quick Dart import fixes
- `const`: Compile-time constant
- `final`: Runtime constant
- `?`: Nullable type indicator

---

## 🧵 Streams vs Futures
- **Future**: One-time async result.
- **Stream**: Continuous flow of data over time.

---

Happy Coding with Flutter BLoC! 🚀

