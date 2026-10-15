import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/features/billHistory/domain/model/bill_history_model.dart';
import 'package:meter_reader_new/features/billHistory/helper/bill_history_helper.dart';

part 'bill_history_event.dart';
part 'bill_history_state.dart';

class BillHistoryBloc extends Bloc<BillHistoryEvent, BillHistoryState> {

  List<BillHistoryModel>  _billHistoryList = [];
  List<BillHistoryModel>  get billHistoryList => _billHistoryList;

  List<BillHistoryModel>  _billHistorySearchList = [];
  List<BillHistoryModel>  get billHistorySearchList => _billHistorySearchList;

  BillHistoryBloc() : super(BillHistoryInitial()) {
    on<BillHistoryPageLoadEvent>(_pageLoad);
    on<BillHistorySearchKeywordEvent>(_searchKeyword);
  }

  _pageLoad(BillHistoryPageLoadEvent event, emit) async {
    emit(BillHistoryPageLoadState());
    _billHistorySearchList = [];
    _billHistoryList = [];
    await _fetchBillHistoryData(context: event.context,);
    _eventCompleted(emit);
  }

  _fetchBillHistoryData({required BuildContext context,}) async {
    try{
      var res =  await BillHistoryHelper.fetchBillHistoryData(context: context,);
      if(res != "error"){
        if(res['data'] != null){
          _billHistoryList =  billHistoryResponse(res['data']);
          _billHistorySearchList = billHistoryResponse(res['data']);
        }
        }
    } catch(e){
      log("_fetchBillHistoryData-->${e.toString()}");
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
     emit(FetchBillHistoryDataState(billHistoryList: billHistoryList));
  }
}
