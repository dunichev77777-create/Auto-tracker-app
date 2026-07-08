// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMaintenanceSettingCollection on Isar {
  IsarCollection<MaintenanceSetting> get maintenanceSettings =>
      this.collection();
}

const MaintenanceSettingSchema = CollectionSchema(
  name: r'MaintenanceSetting',
  id: -4461870437890493202,
  properties: {
    r'intervalKm': PropertySchema(
      id: 0,
      name: r'intervalKm',
      type: IsarType.long,
    ),
    r'intervalMonths': PropertySchema(
      id: 1,
      name: r'intervalMonths',
      type: IsarType.long,
    ),
    r'isSystem': PropertySchema(
      id: 2,
      name: r'isSystem',
      type: IsarType.bool,
    ),
    r'lastChangedDate': PropertySchema(
      id: 3,
      name: r'lastChangedDate',
      type: IsarType.dateTime,
    ),
    r'lastChangedOdometer': PropertySchema(
      id: 4,
      name: r'lastChangedOdometer',
      type: IsarType.long,
    ),
    r'showOnMainScreen': PropertySchema(
      id: 5,
      name: r'showOnMainScreen',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'vehicleId': PropertySchema(
      id: 7,
      name: r'vehicleId',
      type: IsarType.long,
    ),
    r'vehicleName': PropertySchema(
      id: 8,
      name: r'vehicleName',
      type: IsarType.string,
    )
  },
  estimateSize: _maintenanceSettingEstimateSize,
  serialize: _maintenanceSettingSerialize,
  deserialize: _maintenanceSettingDeserialize,
  deserializeProp: _maintenanceSettingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'vehicle': LinkSchema(
      id: 8221517162334663726,
      name: r'vehicle',
      target: r'Vehicle',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _maintenanceSettingGetId,
  getLinks: _maintenanceSettingGetLinks,
  attach: _maintenanceSettingAttach,
  version: '3.1.0+1',
);

int _maintenanceSettingEstimateSize(
  MaintenanceSetting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.vehicleName.length * 3;
  return bytesCount;
}

void _maintenanceSettingSerialize(
  MaintenanceSetting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.intervalKm);
  writer.writeLong(offsets[1], object.intervalMonths);
  writer.writeBool(offsets[2], object.isSystem);
  writer.writeDateTime(offsets[3], object.lastChangedDate);
  writer.writeLong(offsets[4], object.lastChangedOdometer);
  writer.writeBool(offsets[5], object.showOnMainScreen);
  writer.writeString(offsets[6], object.title);
  writer.writeLong(offsets[7], object.vehicleId);
  writer.writeString(offsets[8], object.vehicleName);
}

MaintenanceSetting _maintenanceSettingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MaintenanceSetting();
  object.id = id;
  object.intervalKm = reader.readLong(offsets[0]);
  object.intervalMonths = reader.readLongOrNull(offsets[1]);
  object.isSystem = reader.readBool(offsets[2]);
  object.lastChangedDate = reader.readDateTime(offsets[3]);
  object.lastChangedOdometer = reader.readLong(offsets[4]);
  object.showOnMainScreen = reader.readBool(offsets[5]);
  object.title = reader.readString(offsets[6]);
  object.vehicleId = reader.readLongOrNull(offsets[7]);
  return object;
}

P _maintenanceSettingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _maintenanceSettingGetId(MaintenanceSetting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _maintenanceSettingGetLinks(
    MaintenanceSetting object) {
  return [object.vehicle];
}

void _maintenanceSettingAttach(
    IsarCollection<dynamic> col, Id id, MaintenanceSetting object) {
  object.id = id;
  object.vehicle.attach(col, col.isar.collection<Vehicle>(), r'vehicle', id);
}

extension MaintenanceSettingQueryWhereSort
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QWhere> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MaintenanceSettingQueryWhere
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QWhereClause> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MaintenanceSettingQueryFilter
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QFilterCondition> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalKmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalKmGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalKmLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalKmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervalMonths',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervalMonths',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalMonths',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalMonths',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalMonths',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      intervalMonthsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalMonths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      isSystemEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSystem',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChangedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastChangedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastChangedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastChangedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedOdometerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChangedOdometer',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedOdometerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastChangedOdometer',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedOdometerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastChangedOdometer',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      lastChangedOdometerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastChangedOdometer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      showOnMainScreenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showOnMainScreen',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleName',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleName',
        value: '',
      ));
    });
  }
}

extension MaintenanceSettingQueryObject
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QFilterCondition> {}

extension MaintenanceSettingQueryLinks
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QFilterCondition> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicle(FilterQuery<Vehicle> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'vehicle');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterFilterCondition>
      vehicleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'vehicle', 0, true, 0, true);
    });
  }
}

extension MaintenanceSettingQuerySortBy
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QSortBy> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalKm', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalKm', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIntervalMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMonths', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIntervalMonthsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMonths', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByIsSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByLastChangedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByLastChangedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByLastChangedOdometer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedOdometer', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByLastChangedOdometerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedOdometer', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByShowOnMainScreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnMainScreen', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByShowOnMainScreenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnMainScreen', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByVehicleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleName', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      sortByVehicleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleName', Sort.desc);
    });
  }
}

extension MaintenanceSettingQuerySortThenBy
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QSortThenBy> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalKm', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalKm', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIntervalMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMonths', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIntervalMonthsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMonths', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByIsSystemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystem', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByLastChangedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByLastChangedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByLastChangedOdometer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedOdometer', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByLastChangedOdometerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChangedOdometer', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByShowOnMainScreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnMainScreen', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByShowOnMainScreenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnMainScreen', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByVehicleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleName', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QAfterSortBy>
      thenByVehicleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleName', Sort.desc);
    });
  }
}

extension MaintenanceSettingQueryWhereDistinct
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct> {
  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalKm');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByIntervalMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalMonths');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByIsSystem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSystem');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByLastChangedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChangedDate');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByLastChangedOdometer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChangedOdometer');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByShowOnMainScreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showOnMainScreen');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleId');
    });
  }

  QueryBuilder<MaintenanceSetting, MaintenanceSetting, QDistinct>
      distinctByVehicleName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleName', caseSensitive: caseSensitive);
    });
  }
}

extension MaintenanceSettingQueryProperty
    on QueryBuilder<MaintenanceSetting, MaintenanceSetting, QQueryProperty> {
  QueryBuilder<MaintenanceSetting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MaintenanceSetting, int, QQueryOperations> intervalKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalKm');
    });
  }

  QueryBuilder<MaintenanceSetting, int?, QQueryOperations>
      intervalMonthsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalMonths');
    });
  }

  QueryBuilder<MaintenanceSetting, bool, QQueryOperations> isSystemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSystem');
    });
  }

  QueryBuilder<MaintenanceSetting, DateTime, QQueryOperations>
      lastChangedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChangedDate');
    });
  }

  QueryBuilder<MaintenanceSetting, int, QQueryOperations>
      lastChangedOdometerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChangedOdometer');
    });
  }

  QueryBuilder<MaintenanceSetting, bool, QQueryOperations>
      showOnMainScreenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showOnMainScreen');
    });
  }

  QueryBuilder<MaintenanceSetting, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<MaintenanceSetting, int?, QQueryOperations> vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleId');
    });
  }

  QueryBuilder<MaintenanceSetting, String, QQueryOperations>
      vehicleNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleName');
    });
  }
}
