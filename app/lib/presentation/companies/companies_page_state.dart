import '../../domain/domain.dart';

sealed class CompaniesPageState {
  const CompaniesPageState();

  const factory CompaniesPageState.initial() = Initial;
  const factory CompaniesPageState.loading() = Loading;
  const factory CompaniesPageState.loaded(List<Company> companies) = Loaded;
  const factory CompaniesPageState.error(String message) = Error;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<Company> companies) loaded,
  }) {
    return switch (this) {
      Initial() => initial(),
      Loading() => loading(),
      Error(message: final message) => error(message),
      Loaded(companies: final companies) => loaded(companies),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(String message)? error,
    T Function(List<Company> companies)? loaded,
    required T Function() orElse,
  }) {
    return switch (this) {
      Initial() => initial?.call() ?? orElse(),
      Loading() => loading?.call() ?? orElse(),
      Error(message: final message) => error?.call(message) ?? orElse(),
      Loaded(companies: final companies) => loaded?.call(companies) ?? orElse(),
    };
  }

  CompaniesPageState copyWith() {
    return switch (this) {
      Initial() => const Initial(),
      Loading() => const Loading(),
      Error(message: final message) => Error(message),
      Loaded(companies: final companies) => Loaded(companies),
    };
  }
}

final class Initial extends CompaniesPageState {
  const Initial();
}

final class Loading extends CompaniesPageState {
  const Loading();
}

final class Loaded extends CompaniesPageState {
  final List<Company> companies;

  const Loaded(this.companies);
}

final class Error extends CompaniesPageState {
  final String message;

  const Error(this.message);
}
