import 'package:apiraiser/apiraiser.dart';

class ProjectTable {
  static final List<ColumnInfo> columns = List.from([
    const ColumnInfo(
      name: "Name",
      datatype: ColumnDataType.shortText,
      isRequired: false,
      isUnique: false,
      isForeignKey: false,
      foreignName: "",
      foreignTable: "",
    ),
    const ColumnInfo(
      name: "Description",
      datatype: ColumnDataType.longText,
      isRequired: true,
      isUnique: false,
      isForeignKey: false,
      foreignName: "",
      foreignTable: "",
    ),
    const ColumnInfo(
      name: "Deployed",
      datatype: ColumnDataType.boolean,
      isRequired: false,
      isUnique: false,
      isForeignKey: false,
      foreignName: "",
      foreignTable: "",
    ),
  ]);
}
