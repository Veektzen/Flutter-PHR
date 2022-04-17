final String tableAllergies = 'allergies';

class AllergyFields {
  static final List<String> values = [
    // all fields
    id, user_id, allergy, image
  ];

  static final String id = '_id';
  static final String user_id = 'user_id';
  static final String allergy = 'allergy';
  static final String image = 'image';
}

class Allergy {
  final int id;
  final int user_id;
  final String allergy;
  final String image;

  const Allergy({
    this.id,
    this.user_id,
    this.allergy,
    this.image,
  });

  Allergy copy({
    int id,
    int user_id,
    String allergy,
    String image,
  }) =>
      Allergy(
        id: id ?? this.id,
        user_id: user_id ?? this.user_id,
        allergy: allergy ?? this.allergy,
        image: image ?? this.image,
      );

  static Allergy fromMap(Map<String, Object> map) => Allergy(
        id: map[AllergyFields.id] as int,
        user_id: map[AllergyFields.user_id] as int,
        allergy: map[AllergyFields.allergy] as String,
        image: map[AllergyFields.image] as String,
      );

  Map<String, Object> toMap() => {
        AllergyFields.id: id,
        AllergyFields.user_id: user_id,
        AllergyFields.allergy: allergy,
        AllergyFields.image: image,
      };

  int getId() {
    return id;
  }

  int getUserId() {
    return user_id;
  }

  String getAllergy() {
    return allergy;
  }

  String getImage() {
    return image;
  }
}
