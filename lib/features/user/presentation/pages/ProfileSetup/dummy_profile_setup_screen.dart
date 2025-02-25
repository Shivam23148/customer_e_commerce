import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';

import '../../widgets/my_elevated_button.dart';

class DummyProfileSetupScreen extends StatefulWidget {
  const DummyProfileSetupScreen({super.key});

  @override
  State<DummyProfileSetupScreen> createState() =>
      _DummyProfileSetupScreenState();
}

class _DummyProfileSetupScreenState extends State<DummyProfileSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Address",
                    style: TextStyle(
                        fontSize: getRelativeWidth(0.09),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.03),
                  ),
                  Text("House No."),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    // controller: _homeController,
                    decoration: InputDecoration(
                      hintText: "Enter your house no.",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text("Building No."),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    // controller: _buildingController,
                    decoration: InputDecoration(
                      hintText: "Enter first name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text("Landmark/ Nearby place"),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    // controller: _landmarkController,
                    decoration: InputDecoration(
                      hintText: "Enter your Landmark/ Nearby place",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text("City"),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    // controller: _cityController,
                    decoration: InputDecoration(
                      hintText: "Enter your city",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text("State"),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    // controller: _buildingController,
                    decoration: InputDecoration(
                      hintText: "Enter your state",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Text("Zip Code"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    // controller: _zipController,
                    decoration: InputDecoration(
                      hintText: "Enter zip code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: getRelativeHeight(0.03),
                  ),
                  MyElevatedButton(
                      onPressed: () {
                        print("Save Address button pressed");
                      },
                      text: "Save Address")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
