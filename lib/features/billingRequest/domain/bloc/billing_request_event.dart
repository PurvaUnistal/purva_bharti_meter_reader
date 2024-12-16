import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BillingRequestEvent extends Equatable {}

class BillingRequestPageLoadingEvent extends BillingRequestEvent {
  final BuildContext context;
  BillingRequestPageLoadingEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
class SyncSearchBPNumberEvent extends BillingRequestEvent {
  final BuildContext context;
  SyncSearchBPNumberEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class SelectMeterCameraEvent extends BillingRequestEvent {
  final BuildContext context;
  SelectMeterCameraEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class SelectMeterGalleryEvent extends BillingRequestEvent {
  final BuildContext context;
  SelectMeterGalleryEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange1Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange1Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange2Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange2Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange3Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange3Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange4Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange4Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange5Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange5Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange6Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange6Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange7Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange7Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange8Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange8Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange9Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange9Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class OnChange10Event extends BillingRequestEvent {
  final BuildContext context;
  OnChange10Event({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class SumAllMeterReadEvent extends BillingRequestEvent {
  final BuildContext context;
  SumAllMeterReadEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object?> get props => [context,];
}

class SetLocationEvent extends BillingRequestEvent {
  final BuildContext context;
  SetLocationEvent({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class CheckAmountPopEvent extends BillingRequestEvent {
  final BuildContext context;
  CheckAmountPopEvent({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class BillingRequestPreviewEvent extends BillingRequestEvent {
  final BuildContext context;
  BillingRequestPreviewEvent({required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class BillingHideShowEvent extends BillingRequestEvent {
  final bool isHideShow;
  BillingHideShowEvent({required this.isHideShow});
  @override
  // TODO: implement props
  List<Object> get props => [isHideShow];
}

class BillingRequestSubmitEvent extends BillingRequestEvent {
  final BuildContext context;
  BillingRequestSubmitEvent({required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}
