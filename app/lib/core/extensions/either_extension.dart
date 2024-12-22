import 'package:external_dependencies/external_dependencies.dart';

extension EitherExt<L, R> on Either<L, R> {
  R toRight() {
    return fold(
      (_) => throw AssertionError(
        'Either instance is not Right! You must check before with the isRight() method.',
      ),
      (r) => r,
    );
  }
}
