import 'package:firstlvlpets/src/repository/entities.dart';
import 'package:firstlvlpets/src/shared/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets {
    return _pets;
  }

  Future<void> fetchPets() async {
    final supabase = Supabase.instance.client;
    //TODO: upload files
    // final petImage = await supabase.storage
    //     .from('PetImages')
    //     .download('public/userid_1.jpg');
    final petData = await supabase.from(PetEntity.entityName).select();
    //Best Practive: .eq('user_id', supabase.auth.currentUser!.id);

    List<Pet> pets = [];
    for (var row in petData) {
      var birthDate = DateTime.parse(row[PetEntity.birthdate]);
      var weightKg = row[PetEntity.weightKg].toDouble();
      pets.add(Pet(
          id: row[PetEntity.id],
          name: row[PetEntity.name],
          birthdate: birthDate,
          weightKg: weightKg));
    }
    _pets = pets;

    notifyListeners();
  }
}
