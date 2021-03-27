abstract class IEntity {
  int id;
  get getEntityName;
  IEntity.fromData(dynamic object);

  Map<String, dynamic> convertToMap();
}
