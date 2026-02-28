import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppData(),
      child: MainApp(),
    ),
  );
}

class AppData extends ChangeNotifier{
  Map<String, int> stepsData = {};
  Map<String, double> waterData = {};

  void addSteps(String date, int steps){
    stepsData[date] = steps;
    notifyListeners();
  }

  void changeSteps(String date, int steps){
    stepsData[date] = steps;
    notifyListeners();
  }

  void deleteSteps(String date){
    stepsData.remove(date);
    notifyListeners();
  }

  void addWater(String date, double water){
    waterData[date] = water;
    notifyListeners();
  }

  int get totalSteps => stepsData.values.fold(0, (a, b) => a + b);
  double get totalWater => waterData.values.fold(0.0, (a, b) => a + b);
}

class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HOMESCREEN",
          style: GoogleFonts.merriweather(
            textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("STATISTICS", 
                style: GoogleFonts.alegreya(
                  textStyle: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: appData.stepsData.length * 110,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: appData.stepsData.entries.map((entry) {
                          return BarChartGroupData(
                            x: appData.stepsData.keys.toList().indexOf(entry.key),
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: Colors.blue,
                                width: 25,
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                ),
                              ),
                            ],
                          );
                        }
                        ).toList(),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles( 
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text("Date", style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta){
                                if (value.toInt() < appData.stepsData.length){
                                  final date = appData.stepsData.keys.elementAt(value.toInt());
                                  return Text(date, style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                                  );
                                }
                                return const Text("");
                              },
                            ),
                          ),
                          leftTitles: AxisTitles( 
                            axisNameWidget: Text("Steps", style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: appData.waterData.length * 110,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: appData.waterData.entries.map((entry){
                          return BarChartGroupData(
                            x: appData.waterData.keys.toList().indexOf(entry.key),
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Colors.green,
                                width: 25,
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                ),
                              ),
                            ],
                          );
                        }
                        ).toList(),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles( 
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Center(
                              child: Text("Date", 
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta){
                                if (value.toInt() < appData.waterData.length){
                                  final date = appData.waterData.keys.elementAt(value.toInt());
                                  return Text(date, style:  GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),);
                                }
                                return const Text("");
                              },
                            ),
                          ),
                          leftTitles: AxisTitles( 
                            axisNameWidget: Align(
                              alignment: Alignment.center,
                              child: Text("Water", 
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade600, // warna background box
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "TOTAL STEPS: ${appData.totalSteps} Steps",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade600, // warna background box
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "TOTAL WATER: ${appData.totalWater} Liter",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
      
      bottomNavigationBar: LayoutBuilder(
        builder: (context, Constraints){
          bool isWidenScreen = Constraints.maxWidth > 600;

          return Container(
            color: Colors.amber.shade800,
            padding: const EdgeInsets.all(8),
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen? 12 : 8),
                    ),
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => StepsScreen()
                        )
                      );
                    },
                    icon: const Icon(Icons.directions_walk, size: 25),
                    label: Text("STEPS",
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen? 12 : 8),
                    ),
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => WaterScreen()
                        )
                      );
                    },
                    icon: const Icon(Icons.local_drink, size: 25),
                    label: Text("WATER", 
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class StepsScreen extends StatefulWidget{
  const StepsScreen({super.key});

  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>{
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  String _mode = "";

  Future<void> _pickDate() async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2035),
    );

    if (picked != null){
      setState((){
        _dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      }
      );
    }
  }

  void _submitSteps(AppData appData){
    final date = _dateController.text;
    final steps = int.tryParse(_stepsController.text) ?? 0;

    if (date.isEmpty || steps <= 0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choose valid amount of steps.")),
      );
      return;
    }

    if (_mode == "add"){
      if (appData.stepsData.containsKey(date)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data on this date already exists, use Change.")),
        );
        return;
      }
      appData.addSteps(date, steps);
    } else if (_mode == "change"){
      if (!appData.stepsData.containsKey(date)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("There is no data in this date, use Add.")),
        );
        return;
      }
      appData.changeSteps(date, steps);
    }

    _stepsController.clear();
    _dateController.clear();
    setState((){
      _mode = "";
    }
    );
  }

  void _delete(AppData appData){
    final date = _dateController.text;
    if (date.isEmpty || !appData.stepsData.containsKey(date)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is no data in this date.")),
      );
      return;
    }
    appData.deleteSteps(date);
    _dateController.clear();
    _stepsController.clear();
    setState((){
      _mode = "";
    }
    );
  }

  String _getIndicator(int steps){
    if (steps < 4000) return "Bad";
    if (steps <= 8000) return "Average";
    return "Good";
  }

  @override
  Widget build(BuildContext context){
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("STEPS TRACKER SCREEN",
        style: GoogleFonts.merriweather(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
        centerTitle: true,
        automaticallyImplyActions: false,
        backgroundColor: Colors.amber.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("DATE",
            style: GoogleFonts.alegreya(
              textStyle: TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold
              ),
            ),
            ),
            TextField(
              controller: _dateController,
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
              decoration: const InputDecoration(hintText: "Choose Date"),
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _stepsController,
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Input Steps"),
            ),
            const SizedBox(height: 20),

            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    shape: RoundedRectangleBorder( 
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle( 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){
                    setState((){
                      _mode = "add";
                    }
                    ); 
                    _submitSteps(appData);
                  },
                  child: Text("ADD", 
                  style: GoogleFonts.alegreya(
                    textStyle: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    shape: RoundedRectangleBorder( 
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle( 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){
                    final date = _dateController.text;
                    final steps = int.tryParse(_stepsController.text) ?? 0;
                    if (date.isNotEmpty && steps > 0){
                      if (appData.stepsData.containsKey(date)){
                        appData.changeSteps(date, steps);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("There is no data in this date yet, use ADD first."),),
                        );
                      }
                    }
                  },
                  child: Text("CHANGE", 
                  style: GoogleFonts.alegreya(
                    textStyle: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    shape: RoundedRectangleBorder( 
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle( 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => _delete(appData),
                  child: Text("DELETE", 
                  style: GoogleFonts.alegreya(
                    textStyle: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: appData.stepsData.length,
                itemBuilder: (context, index){
                  final date = appData.stepsData.keys.elementAt(index);
                  final steps = appData.stepsData[date]!;
                  return Card(
                    color: Colors.amber.shade700,
                    elevation: 4,
                    child: ListTile(
                      title: Text("Date: $date", 
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        ),
                      ),
                      ),
                      subtitle: Text("Steps: $steps",
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        ),
                      ),
                      ),
                      trailing: Text(_getIndicator(steps),
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle( 
                        fontSize: 19, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black
                        ),
                      ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, Constraints){
          bool isWidenScreen = Constraints.maxWidth > 600;
          return Container(
            color: Colors.amber.shade800,
            padding: const EdgeInsets.all(8),
            height: 75,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75), 
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen ? 12 : 8),
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    icon: const Icon(Icons.home, size: 25),
                    label: Text("HOME", 
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen ? 12 : 8),
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WaterScreen()),
                      );
                    },
                    icon: const Icon(Icons.local_drink, size: 25),
                    label: Text("WATER", 
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class WaterScreen extends StatefulWidget{
  const WaterScreen({super.key});

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen>{
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  Future<void> _pickDate() async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null){
      setState((){
        _dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      }
      );
    }
  }

  void _submitWater(AppData appData){
    final date = _dateController.text;
    final water = double.tryParse(_waterController.text) ?? 0.0;

    if (date.isEmpty || water <= 0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount of water.")),
      );
      return;
    }
    if (appData.waterData.containsKey(date)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The data for this date already exists.")),
      );
      return;
    }

    appData.addWater(date, water);
    _waterController.clear();
  }

  String _getIndicator(double water){
    if (water < 1.5) return "Bad";
    if (water <= 2.0) return "Average";
    return "Good";
  }

  @override
  Widget build(BuildContext context){
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("WATER INTAKE SCREEN",
          style: GoogleFonts.merriweather(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyActions: false,
        backgroundColor: Colors.amber.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("DATE", 
            style: GoogleFonts.alegreya(
              textStyle: TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold
              ),
            ),
            ),
            TextField(
              controller: _dateController,
              style: const TextStyle( 
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(hintText: "Choose Date"),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _waterController,
              style: const TextStyle( 
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Input Water (Liter)"),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle( 
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _submitWater(appData),
              child: Text("Submit",
              style: GoogleFonts.merriweather(
                textStyle: TextStyle(
                  fontSize: 15
                ),
              ),
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: appData.waterData.length,
                itemBuilder: (context, index){
                  final date = appData.waterData.keys.elementAt(index);
                  final water = appData.waterData[date]!;
                  return Card(
                    color: Colors.amber.shade700,
                    elevation: 4,
                    child: ListTile(
                      title: Text("Date: $date",
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        ),
                      ),
                      ),
                      subtitle: Text("Water: $water Liter", 
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        ),
                      ),
                      ),
                      trailing: Text(_getIndicator(water),
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle( 
                          fontSize: 19, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        ),
                      ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, Constraints){
          bool isWidenScreen = Constraints.maxWidth > 600;

          return Container(
            color: Colors.amber.shade800,
            padding: const EdgeInsets.all(8),
            height: 75,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen ? 12 : 8,),
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => StepsScreen()),
                      );
                    },
                    icon: const Icon(Icons.directions_walk, size: 25),
                    label: Text("STEPS", 
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom( 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 75),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: isWidenScreen ? 12 : 8),
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    icon: const Icon(Icons.home, size: 25),
                    label: Text("HOME", 
                    style: GoogleFonts.alegreya(
                      textStyle: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
