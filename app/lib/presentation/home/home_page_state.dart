sealed class HomePageState {
  const HomePageState();

  const factory HomePageState.initial() = Initial;

  T when<T>({
    required T Function() initial,
  }) {
    return switch (this) {
      Initial() => initial(),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    required T Function() orElse,
  }) {
    return switch (this) {
      Initial() => initial?.call() ?? orElse(),
    };
  }

  HomePageState copyWith() {
    return switch (this) {
      Initial() => const Initial(),
    };
  }
}

final class Initial extends HomePageState {
  const Initial();
}
