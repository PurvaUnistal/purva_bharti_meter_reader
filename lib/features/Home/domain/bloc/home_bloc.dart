import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meter_reader_new/Utils/Utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/button_widget.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';
import 'package:meter_reader_new/features/Home/helper/home_helper.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitState()) {
    on<HomePageLoadingEvent>(_pageLoader);
  }

  bool isPageLoader = false;
  PropertyTypeModel propertyTypeModel = PropertyTypeModel();
  List<PropertyTypeModel> listOfPropertyType = [];

  _pageLoader(HomePageLoadingEvent event, emit) async {
    emit(HomeInitState());
    var res = await  HomeHelper.getPendingBills(context: event.context);
    if(res != null){
      listOfPropertyType = res;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(emit) {
    emit(HomeFetchDataState(
      isPageLoader: isPageLoader,
      listOfPropertyType: listOfPropertyType,
      propertyTypeModel: propertyTypeModel,
    ));
  }
}
