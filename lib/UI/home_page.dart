import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_app/features/add_car.dart';
import 'package:hive_app/model/car_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void deleteItem({required dynamic key}) {
    final showRoom = Hive.box('showRoom');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: const Text("Are you sure delete this car?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showRoom.delete(key);
                  Navigator.of(context).pop();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showRoom = Hive.box("showRoom");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: const Text("Car Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _brandController,
                decoration: InputDecoration(
                  label: const Text("Car Brand"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  label: const Text("Car Price"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    AddCar.insertCar(
                      carName: _nameController.text,
                      carBrand: _brandController.text,
                      carPrice: int.parse(
                        _priceController.text.trim(),
                      ),
                    );

                    _nameController.clear();
                    _brandController.clear();
                    _priceController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: showRoom.values.length,
                  itemBuilder: (context, index) {
                    List<CarModel> cars = showRoom.values.toList().cast();
                    return ListTile(
                      title: Text("${cars[index].brand} ${cars[index].name}"),
                      subtitle: Text("\$${cars[index].price}"),
                      trailing: IconButton(
                        onPressed: () {
                          final key = showRoom.keyAt(index);

                          deleteItem(key: key);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
