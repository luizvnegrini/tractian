import 'package:external_dependencies/external_dependencies.dart';

import '../../domain/domain.dart';
import 'companies_page_state.dart';

class CompaniesPageBloc extends BlocBase<CompaniesPageState> {
  final FetchCompanies fetchData;

  CompaniesPageBloc({
    required this.fetchData,
  }) : super(const CompaniesPageState.initial());

  Future<void> fetch() async {
    emit(const CompaniesPageState.loading());

    final result = await fetchData();
    final newState = result.fold(
      (exception) => CompaniesPageState.error('Try again later'),
      (companies) => CompaniesPageState.loaded(companies),
    );

    emit(newState);
  }
}