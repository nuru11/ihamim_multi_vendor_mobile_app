import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // ✅ Makes it scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Top Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.blue, // Red background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Location + Bell
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.white, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "Addis Ababa",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.filter_list,
                              color: Colors.white, size: 20),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

           

            // 🔹 Banner Carousel
            // _buildSectionHeader("Offers"),
            SizedBox(height: 20,),
           SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network("http://assets.ntechagent.com/ihamim_app/toyota.png", fit: BoxFit.contain),
                      ),
                      // const SizedBox(height: 6),
                      // Text("Cat ${index + 1}",
                      //     style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              },
            ),
          ),


          SizedBox(
            height: 180,
            child: CarouselView(
              itemExtent: MediaQuery.of(context).size.width * 0.85,
              shrinkExtent: MediaQuery.of(context).size.width * 0.85,
              children: [
                _buildBanner("http://assets.ntechagent.com/ihamim_app/1.jpeg"),
                _buildBanner("http://assets.ntechagent.com/ihamim_app/2.jpeg"),
                _buildBanner("http://assets.ntechagent.com/ihamim_app/3.jpeg"),
              ],
            ),
          ),

          const SizedBox(height: 20),

            // 🔹 Popular Products
            _buildSectionHeader("Popular Products", showSeeAll: true),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const NeverScrollableScrollPhysics(), // prevent nested scroll
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          "http://assets.ntechagent.com/ihamim_app/1.jpeg",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Product ${index + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("\$99",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section header
  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          if (showSeeAll)
            TextButton(
              onPressed: () {},
              child: const Text("See All"),
            )
        ],
      ),
    );
  }

  /// 🔹 Banner builder
  Widget _buildBanner(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
    );
  }
}
