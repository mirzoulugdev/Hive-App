import 'package:hive/hive.dart';
import 'package:hive_app/model/car_model.dart';

class AddCar {
  AddCar.insertCar({
    required String carName,
    required String carBrand,
    required int carPrice,
  }) {
    final showRoom = Hive.box("showRoom");
    showRoom.add(
      CarModel(
        name: carName,
        brand: carBrand,
        price: carPrice,
      ),
    );
  }
}
