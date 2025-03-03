# Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

# Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

# Usage

## Command

- import

```dart
import 'package:flutter_base_components/components.dart';
```

- Create

```dart
class AuthController extends GetxController {
  final AuthRepository _authRepository;
  late final Command commandSignin;

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    commandSignin = Command<LoggedUser, Credentials>(_signin);
  }

  Future<Either<AppException, LoggedUser>> _signin(
      Credentials credentials) async {
    return await _authRepository.signin(credentials);
  }
}
```

- Use

```dart
ValueListenableBuilder<CommandState>(
    valueListenable: controller.commandSignin.currentState,
    builder: (context, state, _) {
        return Column(
            children: [
                ElevatedButton(
                    onPressed: () async {
                        if (validator.validate(credentials).isValid) {
                        controller.commandSignin.execute(credentials);
                        }
                    },
                    child: const Text('Entrar'),
                ),
                if (state is Loading) const CircularProgressIndicator(),
                if (state is Success) Text('User: ${state.data.toString()}'),
                if (state is Error) Text('Erro: ${state.exception}'),
            ],
        );
    },
)
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
