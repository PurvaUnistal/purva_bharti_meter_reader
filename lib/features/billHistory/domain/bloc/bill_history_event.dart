part of 'bill_history_bloc.dart';

abstract class BillHistoryEvent extends Equatable {}


class BillHistoryPageLoadEvent extends BillHistoryEvent {
  final BuildContext context;
  BillHistoryPageLoadEvent({required this.context});
  @override
  List<Object> get props => [context];
}

class BillHistorySearchKeywordEvent extends BillHistoryEvent {
  final String searchKeyword;
  BillHistorySearchKeywordEvent({required this.searchKeyword});
  @override
  List<Object> get props => [searchKeyword];
}