class TypeHabitat {
  final int id;
  final String libelle;

  TypeHabitat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        libelle = json['libelle'];
}
