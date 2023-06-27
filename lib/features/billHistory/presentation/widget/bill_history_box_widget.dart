import '../../../../ExportFile/export_file.dart';

class BillHistoryBoxWidget extends StatelessWidget {

  final BillHistoryModel billHistoryData;
  final String schema;
  final String userId;

  const BillHistoryBoxWidget({required this.billHistoryData,
    required this.userId,
    required this.schema});

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.all(10.0),
       child: Card(
         child: Padding(
           padding: EdgeInsets.all(10.0),
           child:Column(
             children: [
               _textWidget(textName: "BP Number : ", textValue: billHistoryData.bpNumber.toString()),
               _textWidget(textName: "Meter Number : ", textValue: billHistoryData.meterNumber.toString()),
               _textWidget(textName: "Customer Name : ", textValue: "${billHistoryData.fistName.toString()}, ${billHistoryData.lastName.toString()}"),
               _textWidget(textName: "Mobile Number: ", textValue: "${billHistoryData.mobileNumber.toString()}"),
               _textWidget(textName: "Adress : ", textValue: "${billHistoryData.houseNumber.toString()}, ${billHistoryData.locality.toString()}"),

               Align(
                 alignment: Alignment.bottomRight,
                 child: _printButton(userId: userId, schema: schema, context: context),
               ),
             ],
           ),
         ),
       ),
    );
  }

  Widget _textWidget({required String textName, required String textValue}) {
     return Padding(
       padding: const EdgeInsets.all(3.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
             Text(textName, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),),
             Flexible(
                 child: Text(textValue,
                   style: TextStyle(color: Colors.black,
                       fontSize: 14, fontWeight: FontWeight.w400),)),

         ],
       ),
     );
  }

  Widget _printButton({required String userId,
    required String schema, required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      width: MediaQuery.of(context).size.width/3.5,
      child: Material(
        color: Colors.lightBlueAccent,
        child: InkWell(
          onTap: (){
            BlocProvider.of<BillPrintBloc>(context).add(BillPrintPageLoaderEvent(context: context,
                billId: billHistoryData.billId.toString(), schema: schema));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BillPrinterPage()));
          },
          splashColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.print, color: Colors.white,),
                Text("Print", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
