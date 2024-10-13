import 'package:campus_cart/pages/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data
  List<Map<String, dynamic>> items = [
    {
      'item_name': 'Laptop',
      'price': '\$30',
      // stock
      'image': "https://via.placeholder.com/150",
      'rating': 4.5,
    },
    {
      'item_name': 'T-Shirt - Size M',
      'price': '\$10',
      'image': "https://via.placeholder.com/150",
      'rating': 4.0,
    },
    {
      'item_name': 'Calculus Textbook',
      'price': '\$40',
      'image': "https://via.placeholder.com/150",
      'rating': 4.8,
    },
    {
      'item_name': 'Jacket - Size L',
      'price': '\$25',
      'image': "https://via.placeholder.com/150",
      'rating': 4.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Campus Cart',
              style: TextStyle(
                  fontSize: 22, color: Theme.of(context).primaryColor),
            ),
            IconButton(
              icon: Icon(LucideIcons.user,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildTags(),
            SizedBox(height: 16),
            Expanded(child: _buildItemList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(LucideIcons.search,
                color: Theme.of(context).iconTheme.color),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for items',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // TODO: Add filter functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTag('All'),
        SizedBox(width: 8),
        _buildTag('Textbooks'),
        SizedBox(width: 8),
        _buildTag('Clothes'),
      ],
    );
  }

  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Add tag filtering functionality
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.bodyMedium?.color),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item['item_name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Price: ${item['price']}',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${item['rating']}',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Save functionality
                    },
                    child: Text('Save'),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: Chat functionality
                    },
                    child: Text('Ping', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
