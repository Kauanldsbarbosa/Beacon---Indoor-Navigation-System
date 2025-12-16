// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBeaconCollection on Isar {
  IsarCollection<Beacon> get beacons => this.collection();
}

const BeaconSchema = CollectionSchema(
  name: r'Beacon',
  id: 3616079935554435535,
  properties: {
    r'averageRssi': PropertySchema(
      id: 0,
      name: r'averageRssi',
      type: IsarType.double,
    ),
    r'beaconId': PropertySchema(
      id: 1,
      name: r'beaconId',
      type: IsarType.string,
    ),
    r'distanceLabel': PropertySchema(
      id: 2,
      name: r'distanceLabel',
      type: IsarType.string,
    ),
    r'lastSeen': PropertySchema(
      id: 3,
      name: r'lastSeen',
      type: IsarType.dateTime,
    ),
    r'major': PropertySchema(
      id: 4,
      name: r'major',
      type: IsarType.long,
    ),
    r'minor': PropertySchema(
      id: 5,
      name: r'minor',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'txPower': PropertySchema(
      id: 7,
      name: r'txPower',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 8,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _beaconEstimateSize,
  serialize: _beaconSerialize,
  deserialize: _beaconDeserialize,
  deserializeProp: _beaconDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'room': LinkSchema(
      id: -1187545936933938994,
      name: r'room',
      target: r'Room',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _beaconGetId,
  getLinks: _beaconGetLinks,
  attach: _beaconAttach,
  version: '3.1.0+1',
);

int _beaconEstimateSize(
  Beacon object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.beaconId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.distanceLabel.length * 3;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _beaconSerialize(
  Beacon object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageRssi);
  writer.writeString(offsets[1], object.beaconId);
  writer.writeString(offsets[2], object.distanceLabel);
  writer.writeDateTime(offsets[3], object.lastSeen);
  writer.writeLong(offsets[4], object.major);
  writer.writeLong(offsets[5], object.minor);
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.txPower);
  writer.writeString(offsets[8], object.uuid);
}

Beacon _beaconDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Beacon(
    beaconId: reader.readStringOrNull(offsets[1]),
    lastSeen: reader.readDateTimeOrNull(offsets[3]),
    major: reader.readLong(offsets[4]),
    minor: reader.readLong(offsets[5]),
    name: reader.readStringOrNull(offsets[6]),
    txPower: reader.readLong(offsets[7]),
    uuid: reader.readString(offsets[8]),
  );
  return object;
}

P _beaconDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _beaconGetId(Beacon object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _beaconGetLinks(Beacon object) {
  return [object.room];
}

void _beaconAttach(IsarCollection<dynamic> col, Id id, Beacon object) {
  object.room.attach(col, col.isar.collection<Room>(), r'room', id);
}

extension BeaconQueryWhereSort on QueryBuilder<Beacon, Beacon, QWhere> {
  QueryBuilder<Beacon, Beacon, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BeaconQueryWhere on QueryBuilder<Beacon, Beacon, QWhereClause> {
  QueryBuilder<Beacon, Beacon, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> idBetween(
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

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterWhereClause> uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BeaconQueryFilter on QueryBuilder<Beacon, Beacon, QFilterCondition> {
  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> averageRssiEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageRssi',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> averageRssiGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageRssi',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> averageRssiLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageRssi',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> averageRssiBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageRssi',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beaconId',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beaconId',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beaconId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beaconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beaconId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beaconId',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> beaconIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beaconId',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distanceLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'distanceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'distanceLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> distanceLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition>
      distanceLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'distanceLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeen',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSeen',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> lastSeenBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> majorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'major',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> majorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'major',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> majorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'major',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> majorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'major',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> minorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minor',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> minorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minor',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> minorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minor',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> minorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> txPowerEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txPower',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> txPowerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'txPower',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> txPowerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'txPower',
        value: value,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> txPowerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'txPower',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension BeaconQueryObject on QueryBuilder<Beacon, Beacon, QFilterCondition> {}

extension BeaconQueryLinks on QueryBuilder<Beacon, Beacon, QFilterCondition> {
  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> room(
      FilterQuery<Room> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'room');
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterFilterCondition> roomIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'room', 0, true, 0, true);
    });
  }
}

extension BeaconQuerySortBy on QueryBuilder<Beacon, Beacon, QSortBy> {
  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByAverageRssi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageRssi', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByAverageRssiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageRssi', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByBeaconId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beaconId', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByBeaconIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beaconId', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByDistanceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceLabel', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByDistanceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceLabel', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minor', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minor', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByTxPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txPower', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByTxPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txPower', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension BeaconQuerySortThenBy on QueryBuilder<Beacon, Beacon, QSortThenBy> {
  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByAverageRssi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageRssi', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByAverageRssiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageRssi', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByBeaconId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beaconId', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByBeaconIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beaconId', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByDistanceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceLabel', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByDistanceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceLabel', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByMajorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'major', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minor', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minor', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByTxPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txPower', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByTxPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txPower', Sort.desc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Beacon, Beacon, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension BeaconQueryWhereDistinct on QueryBuilder<Beacon, Beacon, QDistinct> {
  QueryBuilder<Beacon, Beacon, QDistinct> distinctByAverageRssi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageRssi');
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByBeaconId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beaconId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByDistanceLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distanceLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeen');
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByMajor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'major');
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minor');
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByTxPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txPower');
    });
  }

  QueryBuilder<Beacon, Beacon, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension BeaconQueryProperty on QueryBuilder<Beacon, Beacon, QQueryProperty> {
  QueryBuilder<Beacon, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Beacon, double, QQueryOperations> averageRssiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageRssi');
    });
  }

  QueryBuilder<Beacon, String?, QQueryOperations> beaconIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beaconId');
    });
  }

  QueryBuilder<Beacon, String, QQueryOperations> distanceLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distanceLabel');
    });
  }

  QueryBuilder<Beacon, DateTime?, QQueryOperations> lastSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeen');
    });
  }

  QueryBuilder<Beacon, int, QQueryOperations> majorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'major');
    });
  }

  QueryBuilder<Beacon, int, QQueryOperations> minorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minor');
    });
  }

  QueryBuilder<Beacon, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Beacon, int, QQueryOperations> txPowerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txPower');
    });
  }

  QueryBuilder<Beacon, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
