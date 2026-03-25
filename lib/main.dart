import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late VideoPlayerController _controller;

  final List<Map<String, String>> profiles = [
  {
    "nama": "Shadam Andika Fabiyanto",
    "panggilan": "Shadam",
    "nim": "0112524035",
    "ttl": "Jakarta, 13 Februari 2002",
    "email": "shadamfabiyanto@gmail.com",
    "gender": "Laki-laki",
    "hobi": "Memancing dan Bermain Game",
    "makanan": "Pecel Lele",
    "image": "assets/profile1.jpg",
  },
  {
    "nama": "Adella Aprilia Sugianto",
    "panggilan": "Adella",
    "nim": "0112523001",
    "ttl": "Grobogan, 14 April 2001",
    "email": "adellaapriliasugianto@if.uai.ac.id",
    "gender": "Perempuan",
    "hobi": "Menonton Film",
    "makanan": "Bakso",
    "image": "assets/profile2.jpg",
  },
  {
    "nama": "Nama Teman 3",
    "panggilan": "Panggilan",
    "nim": "NIM",
    "ttl": "Tempat, Tanggal Lahir",
    "email": "email@gmail.com",
    "gender": "Laki-laki/Perempuan",
    "hobi": "Menonton Film",
    "makanan": "Makanan Favorit",
    "image": "assets/profile3.jpg",
  },
];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override // ✅ FIX 1: Added missing @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Group Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            // 🔁 LOOP PROFILE
            ...profiles.map((profile) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profile["image"]!),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Nama Lengkap : ${profile["nama"]}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Nama Panggilan : ${profile["panggilan"]}"),
                      Text("NIM : ${profile["nim"]}"),
                      Text("Tempat, Tanggal Lahir : ${profile["ttl"]}"),
                      Text("Email : ${profile["email"]}"),
                      Text("Jenis Kelamin : ${profile["gender"]}"),
                      Text("Hobi : ${profile["hobi"]}"),
                      Text("Makanan Favorit : ${profile["makanan"]}"),
                    ],
                  ),
                );
              }).toList(),

            SizedBox(height: 20),

            // 🎬 VIDEO (klik untuk fullscreen)
            _controller.value.isInitialized
            ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    FullScreenVideoPage(controller: _controller), // ✅ FIX 2: Capital 'F'
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

                // tombol play pause
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _controller.value.isPlaying ? "||" : "▶",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    : Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
          ],
        ),
      ),
    );
  }
}
class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;

  FullScreenVideoPage({required this.controller});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),

          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "X",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}