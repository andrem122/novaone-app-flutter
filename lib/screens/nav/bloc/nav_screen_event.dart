part of 'nav_screen_bloc.dart';

abstract class NavScreenEvent extends Equatable {
  const NavScreenEvent();

  @override
  List<Object> get props => [];
}

/// The navigation's screen's initial event
class NavScreenStart extends NavScreenEvent {}

/// A tab bar item on the navigation screen has been tapped
class NavScreenTabBarItemTapped extends NavScreenEvent {
  final int selectedIndex;

  NavScreenTabBarItemTapped({
    required this.selectedIndex,
  });

  @override
  List<Object> get props => super.props + [selectedIndex];
}
