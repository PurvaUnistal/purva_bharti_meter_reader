import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meter_reader/billHistory/domain/bloc/bill_history_bloc.dart';
import 'package:meter_reader/billHistory/presentation/widget/bill_history_box_widget.dart';

import '../../../Utils/CustomEmailTextField.dart';

class BillHistoryPage extends StatefulWidget {
  const BillHistoryPage({Key? key}) : super(key: key);

  @override
  State<BillHistoryPage> createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {

   @override
  void initState() {
     BlocProvider.of<BillHistoryBloc>(context).add(
         BillHistoryPageLoadEvent(context: context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: Container(
            color:  Colors.lightBlueAccent,
            child: Column(
              children: [
                AppBar(title: Text("Bill History"),
                  backgroundColor: Colors.lightBlueAccent,
                  elevation: 0,),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: CustomTextEmailField(
                      onChanged: (value) {
                        BlocProvider.of<BillHistoryBloc>(context).add(
                            BillHistorySearchKeywordEvent(searchKeyword: value));
                      },
                      enabled: true,
                      keyboardType: TextInputType.number,
                      validate: false,
                      hintText: "BP Number/Meter Number",
                      filledColor: Colors.white,
                    )
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<BillHistoryBloc, BillHistoryState>(
          builder: (context, state) {
            if(state is BillHistoryPageLoadState){
              return Center(child: SpinKitCubeGrid(color: Colors.lightBlueAccent, size: 50),);
            } else if(state is BillHistoryEmptyState){
               return Center(child:  Text("No Data Found", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),),);
            } else if(state is FetchBillHistoryDataState){
              return _listBuilder(dataState: state);
            } else{
              return const SizedBox.shrink();
            }
          },
        )
    );
  }

  Widget _listBuilder({required FetchBillHistoryDataState dataState}){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataState.billHistoryList.length,
        itemBuilder: (context, index) {
        return BillHistoryBoxWidget(billHistoryData: dataState.billHistoryList[index],
             userId: dataState.userId.toString(), schema: dataState.schema.toString());
    });
  }
}
