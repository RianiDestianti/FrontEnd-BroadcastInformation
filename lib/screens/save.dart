import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Record Information',
      debugShowCheckedModeBanner: false,
      home: const RecordInformationPage(),
    );
  }
}

class RecordInformationPage extends StatelessWidget {
  const RecordInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
        backgroundColor: const Color(0xFF61C2C8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Record information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    RecordCard(
                      title: 'Jam Perpustakaan Diperpanjang Selama ...',
                      time: '10:00 AM - 12:00 PM',
                      location: 'Pwepustakaan',
                      category: 'Academy',
                      categoryColor: Colors.blue,
                      leadingColor: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    RecordCard(
                      title: 'Upacara Bendera Hari Senin',
                      time: '10:00 AM - 12:00 PM',
                      location: 'Lapangan Sekolah',
                      category: 'Announcements',
                      categoryColor: Colors.orange,
                      leadingColor: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    RecordCard(
                      title: 'Lomba Cerdas Cermat Antar Kelas',
                      time: '10:00 AM - 12:00 PM',
                      location: 'Aula Tertutup',
                      category: 'News',
                      categoryColor: Colors.blueAccent,
                      leadingColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final String category;
  final Color categoryColor;
  final Color leadingColor;

  const RecordCard({
    super.key,
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.categoryColor,
    required this.leadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 6,
          height: double.infinity,
          decoration: BoxDecoration(
            color: leadingColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 10,
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.bookmark_border),
          ],
        ),
      ),
    );
  }
}