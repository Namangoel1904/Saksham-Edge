import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/retailer_repository.dart';
import '../models/retailer.dart';
import 'route_map_screen.dart';
import 'retailer_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Retailer>> _retailersFuture;

  @override
  void initState() {
    super.initState();
    final repo = context.read<RetailerRepository>();
    _retailersFuture = repo.getAssignedRetailers();
  }

  Color _getInventoryColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saksham Edge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RouteMapScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              setState(() {
                final repo = context.read<RetailerRepository>();
                _retailersFuture = repo.getAssignedRetailers();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Retailer>>(
        future: _retailersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading retailers: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assigned retailers found.'));
          }

          final retailers = snapshot.data!;
          return ListView.builder(
            itemCount: retailers.length,
            itemBuilder: (context, index) {
              final retailer = retailers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      retailer.priorityScore.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    retailer.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.inventory, size: 16, color: _getInventoryColor(retailer.inventoryLevel)),
                          const SizedBox(width: 4),
                          Text('Inventory: \${retailer.inventoryLevel}'),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Last visited: \${retailer.lastVisited.toLocal().toString().split(' ')[0]}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RetailerDetailScreen(retailer: retailer),
                      ),
                    );
                    // Refresh if priority changed
                    setState(() {
                      final repo = context.read<RetailerRepository>();
                      _retailersFuture = repo.getAssignedRetailers();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVoiceAssistant(context, "Kisan Krishi Kendra"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  void _showVoiceAssistant(BuildContext context, String retailerName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.graphic_eq, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                "Listening... (Bhashini API Mock)",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Text(
                '"Why am I visiting \$retailerName?"',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade20),
                ),
                child: const Text(
                  "System: Satellite NDVI shows crop stress in a 5km radius, and store inventory for Voliam Targo is critically low.",
                  style: TextStyle(color: Color(0xFF0F2F6C), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
