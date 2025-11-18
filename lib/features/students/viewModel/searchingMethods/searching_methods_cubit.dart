import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'searching_methods_state.dart';

class SearchingMethodsCubit extends Cubit<SearchingMethodsState> {
  SearchingMethodsCubit() : super(SearchingMethodsInitial());
}
