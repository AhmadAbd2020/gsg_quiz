import 'package:flutter/material.dart';
import 'package:gsg_quiz/brain/screenshot.dart';
import 'package:gsg_quiz/models/quote.dart';
import 'package:gsg_quiz/services/services.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final screenShot = ScreenShot();

  String imageUrl = '';

  Future<void> fetchImage() async {
    try {
      String fetchedImageUrl = await ApiService().getImage('building');
      setState(() {
        imageUrl = fetchedImageUrl;
      });
    } catch (e) {
      setState(() {
        imageUrl = '';
      });
    }
  }

  Future<QuoteModel> fetchQuote() async {
    return ApiService().getQuote();
  }

  refreshData() async {
    fetchImage();
    fetchQuote();
  }

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    try {
      await fetchImage();
    } catch (e) {
      print('null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: screenShot.globalKey,
        child: SafeArea(
          child: FutureBuilder<QuoteModel>(
            future: fetchQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading quote"));
              } else {
                QuoteModel quote = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.6), BlendMode.dstATop),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () async {
                            refreshData();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xFFA0B383),
                          ),
                        ),
                      ),
                      const SizedBox(height: 200),
                      Center(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          child: Text(
                            quote.content ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          color: const Color(0xFFA0B383),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            quote.author ?? '',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          screenShot.capturePng(context);
        },
        backgroundColor: Colors.green,
        label: const Text(
          'Take Screenshot',
          style: TextStyle(fontSize: 24),
        ),
        icon: const Icon(
          Icons.share_rounded,
          size: 24,
        ),
      ),
    );
  }
}
