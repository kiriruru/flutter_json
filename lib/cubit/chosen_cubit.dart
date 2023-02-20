import 'package:bloc/bloc.dart';

class ChosenUserCubit extends Cubit<String> {
  final DataSource ds;
  ChosenUserCubit(this.ds) : super(ChosenUserCubitStateInit());

  Future<void> choseUser(String id) async {
    emit(ChosenUserCubitStateLoading());
    // получаем данные от покетбейза + парсинг json
    // final t = await ds.getData(); 
    emit(ChosenUserCubitStateReady(t));
  }
}

class ChosenUserCubitState {}
class ChosenUserCubitStateInit extends ChosenUserCubitState {}
class ChosenUserCubitStateLoading extends ChosenUserCubitState {}
class ChosenUserCubitStateReady extends ChosenUserCubitState {
  final Map<String,Sring> data;
  ChosenUserCubitStateReady(this.data);
}
class ChosenUserCubitStateError extends ChosenUserCubitState {}

// в BlocBuilder:
if(state is ChosenUserCubitStateInit){
  // ...
} else if(state is ChosenUserCubitStateLoading){
  // show CircleProgressIndicator
} else if(state is ChosenUserCubitStateready){
  ...
