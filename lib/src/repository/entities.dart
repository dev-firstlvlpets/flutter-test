abstract class Entity {
  static String get entityName => '';
}

class PetEntity extends Entity {
  static String get entityName => 'Pet';

  static String get id => 'id';
  static String get name => 'name';
  static String get birthdate => 'birthdate';
  static String get profileImagePath => 'profile_image_path';
  static String get userId => 'user_id';
  static String get weightKg => 'weight_kg';
}
