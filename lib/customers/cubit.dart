import 'package:bloc/bloc.dart';
import '../app/DataSource.dart';

class ChosenUserCubit extends Cubit<ChosenUserCubitState> {
  final DataSource ds;

  ChosenUserCubit(this.ds) : super(ChosenUserCubitState({}, ""));

  Future<void> choseUser(String id) async {
    if (state.id == id) {
      return;
    } else {
      emit(ChosenUserCubitStateLoading({}, id));
      final jsonItem = await ds.readData(id);
      emit(ChosenUserCubitStateReady(jsonItem, id));
    }
  }

  Future<void> updateUserData(String id, String key, String value) async {
    final jsonItem = state.data;
    await ds.updateData(id, jsonItem, key, value);
  }
}

class ChosenUserCubitState {
  final Map<String, dynamic> data;
  final String id;
  ChosenUserCubitState(this.data, this.id);
}

class ChosenUserCubitStateInit extends ChosenUserCubitState {
  ChosenUserCubitStateInit(data, id) : super(data, id);
}

class ChosenUserCubitStateLoading extends ChosenUserCubitState {
  final String id;

  ChosenUserCubitStateLoading(data, this.id) : super(data, id);
}

class ChosenUserCubitStateReady extends ChosenUserCubitState {
  ChosenUserCubitStateReady(data, id) : super(data, id);
}

class ChosenUserCubitStateError extends ChosenUserCubitState {
  ChosenUserCubitStateError(data, id) : super(data, id);
}
