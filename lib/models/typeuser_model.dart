import 'dart:convert';

class TypeUserModel {
  final String name;
  final String typeuser;
  TypeUserModel({
    this.name,
    this.typeuser,
  });

  TypeUserModel copyWith({
    String name,
    String typeuser,
  }) {
    return TypeUserModel(
      name: name ?? this.name,
      typeuser: typeuser ?? this.typeuser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'typeuser': typeuser,
    };
  }

  factory TypeUserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TypeUserModel(
      name: map['name'],
      typeuser: map['typeuser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeUserModel.fromJson(String source) => TypeUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'TypeUserModel(name: $name, typeuser: $typeuser)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TypeUserModel &&
      o.name == name &&
      o.typeuser == typeuser;
  }

  @override
  int get hashCode => name.hashCode ^ typeuser.hashCode;
}
