import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data
  List<Map<String, String>> items = [
    {'item_name': 'Laptop', 'price': '\$30'},
    {'item_name': 'T-Shirt - Size M', 'price': '\$10'},
    {'item_name': 'Calculus Textbook', 'price': '\$40'},
    {'item_name': 'Jacket - Size L', 'price': '\$25'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back arrow on this screen
        backgroundColor: Colors.white,
        elevation: 0, // No shadow for flat look
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Campus Card on the left
            Text(
              'Campus Cart',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),

            // Search bar in the center
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearchBar(),
              ),
            ),

            // Account icon on the right
            Icon(Icons.account_circle, size: 28, color: Colors.grey),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row of tags
            _buildTags(),

            SizedBox(height: 16), // Space between tags and item list

            // List of items with price and action buttons
            Expanded(child: _buildItemList()),
          ],
        ),
      ),
    );
  }

  // Build search bar with search icon, text field, and filter button
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: Colors.grey),
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
            icon: Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {
              // TODO: Add filter functionality
            },
          ),
        ],
      ),
    );
  }

  // Build tags for categories
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

  // Build each tag (category) as a flat button
  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Add tag filtering functionality
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  // Build the list of items (dummy data)
  Widget _buildItemList() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add blank image as the first item in the column
              Container(
                width: double.infinity, // Full width of the card
                height: 150, // Height for the image placeholder
                color: Colors.grey[200], // Placeholder color
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 8), // Space between image and item name

              // Item name
              Text(
                item['item_name']!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Item price
              Text(
                'Price: ${item['price']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),

              // Save and Chat buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Save functionality
                    },
                    child: Text('Save'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: Chat functionality
                    },
                    child: Text('Chat', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
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
