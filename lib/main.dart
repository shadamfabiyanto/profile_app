import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("My Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),

            // FOTO
            CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),

            SizedBox(height: 15),

            // NAMA
            Text(
              "Shadam Andika Fabiyanto",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            // DESKRIPSI
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Mahasiswa IT yang suka memancing dan bersepeda.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),

            SizedBox(height: 20),

            // HOBI (TANPA ICON BIAR AMAN)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
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
              child: Text(
                "Hobi: Memancing & Bersepeda",
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 25),

            // VIDEO
            _controller.value.isInitialized
                ? Container(
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

                          // BUTTON SIMPLE (AMAN)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _controller.value.isPlaying ? "||" : "▶",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}