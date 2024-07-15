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
  final String schema;
  final String userId;
  FetchBillHistoryDataState(
      {required this.billHistoryList ,
    required this.schema,
    required this.userId});
  @override
  List<Object> get props => [billHistoryList, schema, userId];
}