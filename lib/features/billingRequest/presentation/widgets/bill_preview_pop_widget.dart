// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meter_reader/Utils/Utils.dart';
// import 'package:meter_reader/Utils/common_widgets/Loader/DottedLoader.dart';
// import 'package:meter_reader/Utils/common_widgets/Loader/SpinLoader.dart';
// import 'package:meter_reader/Utils/common_widgets/button_widget.dart';
// import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_bloc.dart';
// import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_event.dart';
// import 'package:meter_reader/features/billingRequest/domain/bloc/billing_request_state.dart';
//
// import 'ErorrRowWidget.dart';
// import 'row_widget.dart';
//
// class BillPreviewPopWidget extends StatefulWidget {
//   const BillPreviewPopWidget({super.key});
//
//   @override
//   State<BillPreviewPopWidget> createState() => _BillPreviewPopWidgetState();
// }
//
// class _BillPreviewPopWidgetState extends State<BillPreviewPopWidget> {
//   @override
//   void initState() {
//     BlocProvider.of<BillingRequestBloc>(context)
//         .add(BillingRequestPageLoadingEvent(context: context));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: BlocBuilder<BillingRequestBloc, BillingRequestState>(
//       builder: (context, state) {
//         if (state is BillingRequestFetchDataState) {
//           return _itemBuilder(dataState: state);
//         } else {
//           return const Center(
//             child: SpinLoader(),
//           );
//         }
//       },
//     ));
//   }
//
//   _itemBuilder({required BillingRequestFetchDataState dataState}) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           RowWidget(
//             leading: "BP Number : ",
//             trailing: dataState.bpNumberController.text.toString(),
//           ),
//           RowWidget(
//             leading: "Customer Name : ",
//             trailing: dataState.custNameController.text.toString(),
//           ),
//           RowWidget(
//             leading: "Meter Number : ",
//             trailing: dataState.meterNumberController.text.toString(),
//           ),
//           dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//               ? RowWidget(
//             leading: "Old Meter Reading Date : ",
//             trailing:
//             dataState.listOfBPNumber[0].oldMeterReadingDate.toString(),
//           )
//               : Container(),
//           dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//               ? RowWidget(
//             leading: "New Meter Install Date : ",
//             trailing:
//             dataState.listOfBPNumber[0].newMeterInstallDate.toString(),
//           )
//               : Container(),
//           dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//               ? RowWidget(
//             leading: "Old Meter Previous Reading : ",
//             trailing:
//             dataState.listOfBPNumber[0].oldMeterLastReading.toString(),
//           )
//               : Container(),
//           dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//               ? RowWidget(
//             leading: "Old Meter Current Reading : ",
//             trailing:
//             dataState.listOfBPNumber[0].oldMeterCurrentReading.toString(),
//           )
//               : Container(),
//           dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//               ? RowWidget(
//             leading: "New Meter Initial Reading : ",
//             trailing:
//             dataState.listOfBPNumber[0].newMeterOldReading.toString(),
//           )
//               : RowWidget(
//             leading: "Previous Reading : ",
//             trailing: dataState.listOfBPNumber[0].oldReading.toString(),
//           ),
//           RowWidget(
//             leading: dataState.listOfBPNumber[0].replaceStatus.toString() == "1"
//                 ? "New Meter Current Reading : "
//                 : "Meter Current Reading : ",
//             trailing: dataState.myReading.toStringAsFixed(3),
//           ),
//           RowWidget(
//             leading: "Last Meter Reader Date : ",
//             trailing: dataState.listOfBPNumber[0].lastBillGeneratedDate,
//           ),
//           RowWidget(
//             leading: "Last Bill Pay Date : ",
//             trailing: dataState.listOfBPNumber[0].lastBillPayDate,
//           ),
//           RowWidget(
//             leading: "Outstanding Amount : ",
//             trailing: dataState.listOfBPNumber[0].lastBillPreviousOutstanding,
//           ),
//           if (dataState.actualResult >= 0)...[
//             if (dataState.actualResult > 5 && dataState.actualResult < 25)...[
//               Column(
//                 children: [
//                   RowWidget(
//                     leading: "Message : ",
//                     trailing: "This Reading is valid",
//                   ),
//                   RowWidget(
//                     leading: "Consumption Reading : ",
//                     trailing: dataState.actualResult.toStringAsFixed(3),
//                   ),
//                 ],
//               )
//             ] else if (dataState.actualResult < 5) ...[
//               Column(
//                 children: [
//                   RowWidget(
//                     leading: "Message : ",
//                     trailing: "This Reading is Less then 5",
//                   ),
//                   RowWidget(
//                     leading: "Consumption Reading : ",
//                     trailing: dataState.actualResult.toStringAsFixed(3),
//                   ),
//                 ],
//               )
//             ] else...[
//               RowWidget(
//                 leading: "Message : ",
//                 trailing: "This Reading is Greater then 25",
//               ),
//               RowWidget(
//                 leading: "Consumption Reading : ",
//                 trailing: dataState.actualResult.toStringAsFixed(3),
//               ),
//             ]
//           ] else...[
//             ErrorRowWidget(
//               leading: "Message : ",
//               trailing: "This Negative Reading is not valid",
//             ),
//             if(actualResult < 0)...[
//               ErrorRowWidget(
//                 leading: "Consumption Reading : ",
//                 trailing: dataState.actualResult.toStringAsFixed(3),
//               ),
//             ] else...[
//               RowWidget(
//                 leading: "Consumption Reading : ",
//                 trailing: dataState.actualResult.toStringAsFixed(3),
//               ),
//             ]
//           ],
//           SizedBox(
//             height: 8,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               dataState.isBtnLoader == true ?  DottedLoaderWidget()
//                   : ButtonWidget(
//                 text: "Accept",
//                 onPressed: (){
//                   if (actualResult >= 0) {
//                     BlocProvider.of<BillingRequestBloc>(context).add(
//                         BillingRequestSubmitEvent(context: context));
//                   } else{
//                     Utils.errorSnackBar(msg: "This Negative Reading is not valid", context: context);
//                  return   Navigator.of(context).pop();
//                   }
//                 },
//               ),
//               ButtonWidget(
//                 text: "Edit",
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
