import 'package:bloc/bloc.dart';

sealed class UserEvent {}

final class AddAccountUserEvent extends UserEvent {}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());
}
