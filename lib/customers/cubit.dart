import 'package:bloc/bloc.dart';
import '../app/DataSource.dart';

class ChosenUserCubit extends Cubit<ChosenUserCubitState> {
  final DataSource ds;

  ChosenUserCubit(this.ds) : super(ChosenUserCubitState());

  Future<void> choseUser(String id) async {
    if (state.id == id) {
      return;
    } else {
      emit(ChosenUserCubitStateLoading());
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
  final Map<String, dynamic> data = {};
  final String id = "";
  // ChosenUserCubitState(this.data, this.id);
}

class ChosenUserCubitStateInit extends ChosenUserCubitState {
  final Map<String, dynamic> data = {};
  final String id = "";
  // ChosenUserCubitStateInit(this.data, this.id) : super(data, id);
}

class ChosenUserCubitStateLoading extends ChosenUserCubitState {
  final Map<String, dynamic> data = {};
  final String id = "";
}

class ChosenUserCubitStateReady extends ChosenUserCubitState {
  final Map<String, dynamic> data;
  final String id;
  ChosenUserCubitStateReady(this.data, this.id);
}

class ChosenUserCubitStateError extends ChosenUserCubitState {}
