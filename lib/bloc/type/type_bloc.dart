import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'type_event.dart';
part 'type_state.dart';

class TypeBloc extends Bloc<TypeEvent, TypeState> {
  TypeBloc() : super(TypeInitial()) {
    on<TypeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
