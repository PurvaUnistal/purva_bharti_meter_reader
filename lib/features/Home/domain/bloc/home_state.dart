import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';

abstract class HomeState extends Equatable {}

class HomePageLoaderState extends HomeState {
  final BuildContext context;
  HomePageLoaderState({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class HomeInitState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HomeFetchDataState extends HomeState {
  final bool isPageLoader;
  final PropertyTypeModel propertyTypeModel;
  final List<PropertyTypeModel> listOfPropertyType;

  HomeFetchDataState({
    required this.isPageLoader,
    required this.propertyTypeModel,
    required this.listOfPropertyType,

});
  @override
  // TODO: implement props
  List<Object?> get props => [
    isPageLoader,
    propertyTypeModel,
    listOfPropertyType,
  ];
}