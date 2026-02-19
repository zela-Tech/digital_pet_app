import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int happyDuration = 0;


  TextEditingController _nameController = TextEditingController();
  
  Timer? _timer; // Auto-Hunger-Time

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) hungerLevel = 100;

        //Win Condition
        if (happinessLevel > 80) {
          happyDuration += 30;
          if (happyDuration >= 180) {
            _showWinDialog();
          }
        }

        //Loss condition
        if (hungerLevel == 100 && happinessLevel <= 10) {
          _showLossDialog();
        }



      });
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }
  // Dynamic Color
  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
  // Mood Indicator
  String _moodText() {
    if (happinessLevel > 70) {
      return "Happy 😄";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }


  //Win/Loss Conditions dialog
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("You Win! 🎉"),
        content: Text("Your pet is thriving!"),
      ),
    );
  }
  void _showLossDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over 💀"),
        content: Text("Your pet was too hungry."),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Dynamic color Change
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset('assets/pet_image.png', height: 150),
            ),

            //Name Customization
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter Pet Name"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = _nameController.text;
                });
              },
              child: Text("Set Name"),
            ),


            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),

            Text('Mood: ${_moodText()}', style: TextStyle(fontSize: 18),),
            SizedBox(height: 16.0),

            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
