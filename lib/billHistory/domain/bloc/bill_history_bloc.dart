import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meter_reader/Utils/global_constant.dart';
import 'package:meter_reader/billHistory/domain/model/bill_history_model.dart';
import 'package:meter_reader/billHistory/helper/bill_history_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bill_history_event.dart';
part 'bill_history_state.dart';

class BillHistoryBloc extends Bloc<BillHistoryEvent, BillHistoryState> {

  List<BillHistoryModel>  _billHistoryList = [];
  List<BillHistoryModel>  get billHistoryList => _billHistoryList;

  List<BillHistoryModel>  _billHistorySearchList = [];
  List<BillHistoryModel>  get billHistorySearchList => _billHistorySearchList;

  String _schema = "";
  String get schema => _schema;

  String _userId = "";
  String get userId => _userId;

  BillHistoryBloc() : super(BillHistoryInitial()) {
    on<BillHistoryPageLoadEvent>(_pageLoad);
    on<BillHistorySearchKeywordEvent>(_searchKeyword);
  }

  _pageLoad(BillHistoryPageLoadEvent event, emit) async {
    emit(BillHistoryPageLoadState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    _schema = pref.getString(GlobalConstants.schema) ?? "";
    _userId = pref.getString(GlobalConstants.id) ?? "";
    _billHistorySearchList = [];
    _billHistoryList = [];
     var res =  await BillHistoryHelper.fetchBillHistoryData(context: event.context,
          userId: userId, schema: schema);
     if(res != "error"){
       if(res['data'] != null){
         _billHistoryList =  billHistoryResponse(res['data']);
         _billHistorySearchList = billHistoryResponse(res['data']);
         if(billHistoryList.isNotEmpty){
           _eventCompleted(emit);
         }else{
           emit(BillHistoryEmptyState());
         }
       }else{
         emit(BillHistoryEmptyState());
       }
     }else{
       emit(BillHistoryEmptyState());
     }

  }

  _searchKeyword(BillHistorySearchKeywordEvent event, emit) {

       _billHistoryList = [];
       _eventCompleted(emit);
       if(event.searchKeyword.isNotEmpty){
         List<BillHistoryModel> bpNumberList = billHistorySearchList.where((element) => element.bpNumber.toString().toLowerCase()
             .contains(event.searchKeyword.toLowerCase())).toList();

         if(bpNumberList.isEmpty){
           List<BillHistoryModel> meterNumber = billHistorySearchList.where((element) => element.meterNumber.toString().toLowerCase()
               .contains(event.searchKeyword.toLowerCase())).toList();
           _billHistoryList =  meterNumber;
         }else{
           _billHistoryList =  bpNumberList;
         }

         _eventCompleted(emit);
       }else{
          _billHistoryList =  billHistorySearchList;
          _eventCompleted(emit);
       }
  }

  _eventCompleted(Emitter<BillHistoryState> emit) {
     emit(FetchBillHistoryDataState(billHistoryList: billHistoryList, schema: schema, userId: userId));
  }
}
