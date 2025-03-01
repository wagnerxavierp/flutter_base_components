import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

sealed class CommandState<Result> {
  const CommandState();
}

class Initial<Result> extends CommandState<Result> {
  const Initial();
}

class Loading<Result> extends CommandState<Result> {
  const Loading();
}

class Success<Result> extends CommandState<Result> {
  final Result data;
  const Success(this.data);
}

class Error<Result> extends CommandState<Result> {
  final Exception exception;
  const Error(this.exception);
}

class Command<Result, Param> {
  final Future<Either<Exception, Result>> Function(Param) _action;
  final VoidCallback? onCancel;
  final int maxHistoryLength;

  final ValueNotifier<CommandState<Result>> currentState;
  final List<CommandState<Result>> _history = [];

  Command(
    this._action, {
    this.onCancel,
    this.maxHistoryLength = 10,
  }) : currentState = ValueNotifier(const Initial());

  Future<void> execute([Param? parameter]) async {
    _updateState(const Loading());

    try {
      final either = await _action(parameter as Param);
      either.fold(
        (exception) => _updateState(Error(exception)),
        (result) => _updateState(Success(result)),
      );
    } catch (e) {
      _updateState(Error(Exception(e.toString())));
    }
  }

  void cancel() {
    onCancel?.call();
  }

  void _updateState(CommandState<Result> newState) {
    currentState.value = newState;
    _history.add(newState);
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
    }
  }
}

Command<Result, Param> createCommand<Result, Param>(
  Future<Either<Exception, Result>> Function(Param) action, {
  VoidCallback? onCancel,
  int maxHistoryLength = 10,
}) {
  return Command<Result, Param>(
    action,
    onCancel: onCancel,
    maxHistoryLength: maxHistoryLength,
  );
}
