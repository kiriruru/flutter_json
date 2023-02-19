import 'package:bloc/bloc.dart';

class ChosenUserCubit extends Cubit<String> {
  ChosenUserCubit(String isUserChosen) : super(isUserChosen);

  void choseUser(String id) => emit(id);
}
