import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The base state class that is used for state management
class BaseState extends Equatable {
  final Key? key;

  const BaseState({this.key});

  @override
  List<Object?> get props => key != null ? [key!] : [];
}

/// The base event class that is used for state management
class BaseEvent extends Equatable {
  final Key? key;

  const BaseEvent({this.key});

  @override
  List<Object?> get props => key != null ? [key!] : [];
}

/// The base error state class for state management
class BaseStateError extends BaseState {
  final String error;
  final StackTrace? stackTrace;

  const BaseStateError({required this.error, this.stackTrace});

  @override
  List<Object?> get props => super.props + [error, stackTrace];
}
