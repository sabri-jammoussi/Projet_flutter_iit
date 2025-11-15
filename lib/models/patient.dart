class Patient {
  final String?id;
  final String nom;
  final String email;
  final int age;

  Patient({
    this.id,
    required this.nom,
    required this.email,
    required this.age,
  });

  factory Patient.fromMap(Map<String, dynamic> data) {
    return Patient(
      id: data['id'] ,
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? '',
      'nom': nom,
      'email': email,
      'age': age,
    };
  }
}
