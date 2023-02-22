import 'package:bloc/bloc.dart';
import '../app/DataSource.dart';

class ChosenUserCubit extends Cubit<ChosenUserCubitState> {
  final DataSource ds;

  ChosenUserCubit(this.ds) : super(ChosenUserCubitStateInit()) {
    final Map<String, dynamic> data = {};
    final String id = "";
  }

  Future<void> choseUser(String id) async {
    final currentState = state;
    if (currentState is ChosenUserCubitStateReady && currentState.id == id) {
    } else {
      emit(ChosenUserCubitStateLoading());
      final jsonItem = await ds.readData(id);
      emit(ChosenUserCubitStateReady(jsonItem, id));
    }
  }

  Future<void> updateUserData(String id, String key, String value) async {
    final currentState = state;
    if (currentState is ChosenUserCubitStateReady) {
      final jsonItem = currentState.data;
      await ds.updateData(id, jsonItem, key, value);
    }
  }
}

class ChosenUserCubitState {}

class ChosenUserCubitStateInit extends ChosenUserCubitState {}

class ChosenUserCubitStateLoading extends ChosenUserCubitState {}

class ChosenUserCubitStateReady extends ChosenUserCubitState {
  final Map<String, dynamic> data;
  final String id;
  ChosenUserCubitStateReady(this.data, this.id);
}

class ChosenUserCubitStateError extends ChosenUserCubitState {}
