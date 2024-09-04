import 'package:bloc/bloc.dart';

class EmailCubit extends Cubit<String?> {
  EmailCubit() : super(null);

  void setEmail(String email) {
    emit(email);
  }
}
