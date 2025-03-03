# Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

# Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

# Usage

## Command

- Controller

```dart
class AuthController extends GetxController {
  final AuthRepository _authRepository;
  late final Command command;

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    command = Command<LoggedUser, Credentials>(_signin);
  }

  Future<Either<AppException, LoggedUser>> _signin(
      Credentials credentials) async {
    return await _authRepository.signin(credentials);
  }
}
```

- Widget

```dart
class ExampleWidget extends StatelessWidget {
  final Command<String, int> fetchCommand;

  const ExampleWidget({super.key, required this.fetchCommand});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CommandState<String>>(
      valueListenable: fetchCommand.currentState,
      builder: (context, state, _) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => fetchCommand.execute(123),
              child: const Text('Carregar Dados'),
            ),
            if (state is Loading) const CircularProgressIndicator(),
            if (state is Success) Text('Dados: ${state.data}'),
            if (state is Error) Text('Erro: ${state.exception}'),
          ],
        );
      },
    );
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
