import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int>{
  CounterCubit() : super(0);

  void increment() {
    //addError(Exception('Inc Error!'),StackTrace.current);
    emit(state + 1);
  }
  
  @override
  void onChange(Change<int> change){
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace){
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

}

// class CounterCubit extends Cubit<int>{
//   CounterCubit(int initialState) : super(initialState);
// }