import 'package:bloc/bloc.dart';

class RoleCubit extends Cubit<String?> {
  RoleCubit() : super(null);

  void setRole(String role) {
    emit(role);
  }
}
