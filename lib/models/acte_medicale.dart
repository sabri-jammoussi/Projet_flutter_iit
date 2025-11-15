class ActeMedical {
  final String nom;
  final double tarif;

  ActeMedical({required this.nom, required this.tarif});

  factory ActeMedical.fromMap(Map<String, dynamic> data) {
    return ActeMedical(
      nom: data['nom'] ?? '',
      tarif: (data['tarif'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'tarif': tarif,
    };
  }
}
