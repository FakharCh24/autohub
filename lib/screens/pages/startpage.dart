import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C2C2C),
          elevation: 0,
          title: const Text(
            'AutoHub',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for cars',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              // ⚡ Quick Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Quick Filters',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Archivo_Condensed',
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 10,
                      children: [
                        FilterChip(
                          label: Text(
                            "New Listings",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          selectedColor: const Color(
                            0xFFFFB347,
                          ).withOpacity(0.2),
                          backgroundColor: const Color(0xFF2C2C2C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Color(0xFFFFB347)),
                          ),
                          onSelected: (bool selected) {},
                        ),
                        FilterChip(
                          label: Text(
                            "Price Drop",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          selectedColor: const Color(
                            0xFFFFB347,
                          ).withOpacity(0.2),
                          backgroundColor: const Color(0xFF2C2C2C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Color(0xFFFFB347)),
                          ),
                          onSelected: (bool selected) {},
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list_alt,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: 'Filter',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Browse Categories",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // 🚗 Category Buttons
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  categoryChip("SUV"),
                  categoryChip("Sedan"),
                  categoryChip("Hatchback"),
                  categoryChip("Truck"),
                ],
              ),

              const SizedBox(height: 20),

              // 🚘 Featured Cars
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Featured Cars',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Archivo_Condensed',
                      ),
                    ),
                    const SizedBox(height: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        carCard(
                          "assets/images/car1.jpg",
                          "HONDA CIVIC RS-TURBO 2025",
                          "Rs 90,00,000",
                          "New York, NY",
                          true,
                        ),
                        carCard(
                          "assets/images/car2.jpg",
                          "TOYOTA REVO GR 2022",
                          "Rs 1,250,000",
                          "Los Angeles, CA",
                          false,
                        ),
                        carCard(
                          "assets/images/car3.jpg",
                          "2024 Toyota RAV4 Hybrid",
                          "Rs 32,500",
                          "Chicago, IL",
                          false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      );
      }

  // 🔹 Helper: Category Chip
  static Widget categoryChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB347).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.5)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFB347),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }

  // 🔹 Helper: Car Card
  static Widget carCard(
    String image,
    String title,
    String price,
    String location,
    bool favorite,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF2C2C2C).withOpacity(0.8),
                  child: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite
                        ? const Color(0xFFFFB347)
                        : Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFFFB347),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
