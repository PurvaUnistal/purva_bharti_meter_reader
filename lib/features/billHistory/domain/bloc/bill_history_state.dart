part of 'bill_history_bloc.dart';

abstract class BillHistoryState extends Equatable {
  const BillHistoryState();
}

class BillHistoryInitial extends BillHistoryState {
  @override
  List<Object> get props => [];
}

class BillHistoryPageLoadState extends BillHistoryState {
  @override
  List<Object> get props => [];
}

class BillHistoryEmptyState extends BillHistoryState {
  @override
  List<Object> get props => [];
}

class FetchBillHistoryDataState extends BillHistoryState {
  final List<BillHistoryModel> billHistoryList;
  FetchBillHistoryDataState(
      {required this.billHistoryList});
  @override
  List<Object> get props => [billHistoryList];
}