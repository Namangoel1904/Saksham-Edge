import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/retailer.dart';
import '../data/retailer_repository.dart';
import '../services/vision_service.dart';

class RetailerDetailScreen extends StatefulWidget {
  final Retailer retailer;

  const RetailerDetailScreen({Key? key, required this.retailer}) : super(key: key);

  @override
  State<RetailerDetailScreen> createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  final VisionService _visionService = VisionService();
  bool _isScanning = false;

  String _getNBA() {
    if (widget.retailer.inventoryLevel.toLowerCase() == 'low') {
      return "Pitch Syngenta Voliam Targo (Insecticide)";
    } else if (widget.retailer.priorityScore >= 80) {
      return "Discuss Bulk Discount on Amistar Top";
    }
    return "Conduct Routine Inventory Check";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.retailer.name),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Retailer Info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Retailer Details", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.inventory, "Inventory Level", widget.retailer.inventoryLevel),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.score, "Priority Score", widget.retailer.priorityScore.toString()),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.calendar_today, "Last Visited", widget.retailer.lastVisited.toLocal().toString().split(' ')[0]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Anomaly Scanner
            ElevatedButton.icon(
              onPressed: _isScanning ? null : () => _scanAnomaly(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isScanning 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.camera_alt),
              label: Text(_isScanning ? "Analyzing Edge ML Model..." : "Anomaly Scanner (Edge Vision)"),
            ),
            const SizedBox(height: 24),
            
            // Next Best Action (NBA) Card
            Card(
              color: theme.colorScheme.primary,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "Next Best Action",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getNBA(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Explainable AI (LIME) Expander
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const Icon(Icons.psychology, color: Colors.green),
                  title: const Text("AI Reasoning", style: TextStyle(fontWeight: FontWeight.bold)),
                  childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  children: [
                    _buildLimeFactor(context, "+60% Weight:", "Satellite NDVI shows crop stress in a 5km radius.", Colors.green),
                    const SizedBox(height: 12),
                    _buildLimeFactor(context, "+30% Weight:", "Store inventory for Voliam Targo is critically low.", Colors.orange),
                    const SizedBox(height: 12),
                    _buildLimeFactor(context, "+10% Weight:", "Routine visit overdue.", Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVoiceAssistant(context, widget.retailer.name),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Future<void> _scanAnomaly(BuildContext context) async {
    setState(() => _isScanning = true);
    
    final result = await _visionService.scanAnomaly();
    
    if (!mounted) return;
    setState(() => _isScanning = false);

    if (result != null) {
      // Show result
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anomaly Detected: $result\\nPriority Score +50'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );

      // Update Database
      final repo = context.read<RetailerRepository>();
      await repo.boostRetailerPriority(widget.retailer.id, 50);
    }
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text("$label:", style: TextStyle(color: Colors.grey[700])),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLimeFactor(BuildContext context, String weight, String reason, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            weight,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(reason, style: const TextStyle(fontSize: 14, height: 1.4)),
        ),
      ],
    );
  }
}
