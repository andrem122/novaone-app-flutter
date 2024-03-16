import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'slider_screen_event.dart';
part 'slider_screen_state.dart';

class SliderScreenBloc extends Bloc<SliderScreenEvent, SliderScreenState> {
  SliderScreenBloc() : super(SliderScreenInitial());
}
