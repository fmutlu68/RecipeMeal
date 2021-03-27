import 'package:flutter_meal_app_update/models/abstract/i_entity.dart';

class Category implements IEntity {
  static final columnId = ["id", "INTEGER"];
  static final columnName = ["name", "TEXT"];
  static final columnParentId = ["parent_id", "INTEGER"];
  static final columnPath = ["path", "TEXT"];
  @override
  int id;
  int parentId;
  int hasDownloadedVideoCount, hasDownloadedAudioCount, hasVideoCount;
  String name;
  String path;
  Category({this.id, this.name, this.parentId, this.path});

  Category.fromData(dynamic object) {
    id = object["id"];
    parentId = object["parent_id"];
    name = object["name"];
    path = object["path"];
  }

  @override
  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> map = new Map();
    if (id != null && id.runtimeType == int) {
      map["id"] = id;
    }
    map["parent_id"] = parentId;
    map["name"] = name;
    if (path != null && path.runtimeType == String) {
      map["path"] = path;
    }
    return map;
  }

  @override
  get getEntityName => "Kategori";
}
