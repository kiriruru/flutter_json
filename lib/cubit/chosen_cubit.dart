import 'package:bloc/bloc.dart';

class ChosenUserCubit extends Cubit<String> {
  ChosenUserCubit() : super("");
  // final fieldDataSource;
  //  this.fieldDataSource

// CubitState {}
// CubitStateInit{}
// CubitStateLoading{}
// CubitStateRead{}
// CubitStateError{}

  Future<void> choseUser(String id) async => {
        // state.loading=
        emit(id)
      };
}



// добавить сюда Дата соурс (передать зависимость)
// сделать типизарованный класс
// прочитать про кубит стэйт
// стэйт нужно обернуть в объект



