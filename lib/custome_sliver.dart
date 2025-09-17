import 'dart:math';

import 'package:flutter/material.dart';

class CustomSliver extends StatefulWidget {
  const CustomSliver({super.key});

  @override
  State<CustomSliver> createState() => _CustomSliverState();
}

class _CustomSliverState extends State<CustomSliver>
    with SingleTickerProviderStateMixin {
  final List<String> _tabItems = ['All', 'Popular', 'New', 'Trending'];
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  int randomNumber = Random().nextInt(100000) + 7; // 0-99

  // Sample data for the list
  final List<Map<String, dynamic>> _items = List.generate(50, (index) {
    final color = Colors.primaries[index % Colors.primaries.length];
    return {
      'id': index,
      'title': 'Beautiful Item $index',
      'subtitle': 'This is an amazing description for item $index',
      'color': color,
      'price': '\$${(index + 2) * 10}.00',
      'rating': (index % 5) + 1.0,
      'imageUrl': 'https://picsum.photos/seed/$index/400/300',
    };
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabItems.length,
      vsync: this,
      initialIndex: _selectedTabIndex,
    );

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _tabController.animateTo(index);
    });
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (starIndex) {
        return Icon(
          starIndex < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              item['imageUrl'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: item['color'].withValues(alpha:0.3),
                  child: const Icon(Icons.error, color: Colors.grey),
                );
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['subtitle'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRatingStars(item['rating']),
                      Tooltip(
                        message: 'Price: ${item['price']}',

                        child: Text(
                          item['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabItems.length,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              title: _showSearchBar
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha:0.7),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => _searchController.clear(),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                    )
                  : const Text('Custom Sliver Demo'),
              backgroundColor: Colors.deepPurple,
              expandedHeight: 300,
              floating: false,
              pinned: true,
              snap: false,
              stretch: true,
              centerTitle: true,
              actions: [
                if (!_showSearchBar)
                  IconButton(
                    onPressed: _toggleSearch,
                    icon: const Icon(Icons.search),
                    tooltip: 'Search',
                  ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'Shopping Cart',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://picsum.photos/seed/$randomNumber/400/300',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.deepPurple.shade800,
                  child: TabBar(
                    controller: _tabController,
                    tabs: _tabItems.map((item) => Tab(text: item)).toList(),
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    onTap: _onTabSelected,
                  ),
                ),
              ),
            ),

            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_tabItems[_selectedTabIndex]} Items',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover amazing ${_tabItems[_selectedTabIndex].toLowerCase()} products',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            // Grid or List View
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, index),
                childCount: _items.length,
              ),
            ),

            // Load More Indicator
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

            // Footer
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[100],
                child: const Column(
                  children: [
                    Text(
                      '© 2024 Custom Sliver App',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Built with Flutter & ❤️',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.deepPurple,
        tooltip: 'Scroll to top',
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}
