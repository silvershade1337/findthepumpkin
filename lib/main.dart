import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


String pumpkin = "🎃", skull = "💀", ref = "🔵", life = "❤️";

void offsetList(List list, int offset) {
  if(offset > 0) {
    for (var i = 0; i < offset; i++) {
      list.insert(0, list.removeLast());
    }
  }
  else if (offset <0) {
    for (var i = 0; i < -offset; i++) {
      list.add(list.removeAt(0));
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int score = 0;
  bool gamestarted = false;
  bool gameover = false;
  int lives = 3;
  bool userCanSelect = false;
  List<String> items = List.filled(6, skull, growable: true);
  List<String> hiddenitems = List.filled(6, "", growable: true);
  String abtitle = "";

  void _incrementCounter() {
    setState(() {
      score++;
    });
  }
  Future<void> newGame() async {
    score = 0;
    gamestarted = true;
    gameover = false;
    lives = 3;
  }
  Future<void> nextGame() async {
    userCanSelect = false;
    if (lives <= 0){
      gameover = true;
      setState(() {
        
      });
      return;
    }
    items = List.filled(6, skull, growable: true);
    hiddenitems = List.filled(6, "", growable: true);
    int ppos = Random().nextInt(6);
    int rpos = 0;
    do {
      rpos = Random().nextInt(6);
    } while (rpos == ppos);
    items[ppos] = pumpkin;
    items[rpos] = ref;
    hiddenitems[rpos] = ref;
    gamestarted = true;
    setState(() {
      
    });
    await Future.delayed(
      Duration(seconds: 5)
    );

    userCanSelect = true;
    await Future.delayed(
      Duration(seconds: 2)
    );

    int offset = Random().nextInt(3) + 1;
    offsetList(items, offset);
    offsetList(hiddenitems, offset);
    userCanSelect = true;

    setState(() {
      
    });
    await Future.delayed(
      Duration(seconds: 5),
      () {
        if (userCanSelect) {
          lives--;
          nextGame();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gamestarted? AppBar(
        title: Text(abtitle),
      ):null,
      body: gamestarted && !gameover? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 600,
              child: GridView.count(
                crossAxisCount: 2,
                children: items.map(
                  (item) => Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: userCanSelect? () {
                          if (item == skull) {
                            lives --;
                            nextGame();
                          }
                          else if (item == pumpkin) {
                            score += 10;
                            nextGame();
                          }
                        } : null, 
                        child: Text(!userCanSelect || item ==ref? item : "", style: TextStyle(fontSize: 25),)
                      ),
                    ),
                  )
                ).toList(),
              ),
            ),
            Text("Score: "+score.toString() + "  Lives: "+lives.toString(), style: Theme.of(context).textTheme.headlineMedium),
            
          ],
        ),
      ) 
      : 
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FittedBox(
                child: Text(
                  gameover? 'Game Over '+skull : 'Find The Pumpkin 🎃',
                  style: TextStyle(
                    fontSize: 200
                  ),
                ),
              ),
              if(gameover) Text("Score: "+score.toString(), style: Theme.of(context).textTheme.headlineMedium,),
              ElevatedButton(onPressed: () async {
                await newGame();
                nextGame();
              }, child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(gameover? "Play Again":"Start Game", style: Theme.of(context).textTheme.headlineMedium),
              ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.white),
              ),
              Column(
                children: [
                  Text("How to play?", style: Theme.of(context).textTheme.headlineMedium,),
                  Text("• The original positions of pumpkin and reference dot will be displayed for 5 seconds. Keep that in mind"
                        "\n• Next, the positions will shift by 1 or 2 places, you can notice by keeping track of the reference dot"
                        "\n• With respect to the shift in reference dot, find the position of the pumpkin")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
