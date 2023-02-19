import 'package:bloc/bloc.dart';

class ChosenUserCubit extends Cubit<bool> {
  ChosenUserCubit(bool isUserChosen) : super(isUserChosen);

  void choseUser() => emit(true);
}
