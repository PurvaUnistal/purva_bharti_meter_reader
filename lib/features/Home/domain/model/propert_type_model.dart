class PropertyTypeModel {
  final String? name;
  final String? id;
  final String? status;
  final String? propCode;

  PropertyTypeModel({
     this.name,
     this.id,
     this.status,
     this.propCode,
  });

  bool get isActive => status == '1';

  factory PropertyTypeModel.fromJson(Map<String, dynamic> j) => PropertyTypeModel(
    name: j['name'] as String,
    id: j['id'] as String,
    status: j['status'] as String,
    propCode: j['prop_code'] as String,
  );
}