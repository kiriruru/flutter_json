import 'package:bloc/bloc.dart';
import '../app/DataSource.dart';

class ChosenUserCubit extends Cubit<ChosenUserCubitState> {
  final DataSource ds;
  ChosenUserCubit(this.ds) : super(ChosenUserCubitStateInit());

  Future<void> choseUser(String id) async {
    emit(ChosenUserCubitStateLoading());
    await ds.readData(id);
    final jsonItem = ds.jsonItem;
    emit(ChosenUserCubitStateReady(jsonItem));
  }
}

class ChosenUserCubitState {}
// добавить иммутэйбл
// ай мэп фаст иммутэйбл коллекшн - предоставляет иммутаб мэпи листы

class ChosenUserCubitStateInit extends ChosenUserCubitState {}

class ChosenUserCubitStateLoading extends ChosenUserCubitState {}

class ChosenUserCubitStateReady extends ChosenUserCubitState {
  final Map<String, dynamic> data;
  ChosenUserCubitStateReady(this.data);
}

class ChosenUserCubitStateError extends ChosenUserCubitState {}
