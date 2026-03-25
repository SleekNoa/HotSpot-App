// lib/screens/alerts_screen.dart
// Tabbed notifications screen (All / Connections / Events).

import 'package:flutter/material.dart';

enum AlertType { connection, event }

class AlertItem {
  final String id;
  final AlertType type;
  final String title;
  final String subtitle;
  final String timeLabel;

  const AlertItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final Set<String> _readIds = {};

  @override
  Widget build(BuildContext context) {
    final alerts = _mockAlerts();
    final connectionAlerts =
        alerts.where((a) => a.type == AlertType.connection).toList();
    final eventAlerts = alerts.where((a) => a.type == AlertType.event).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAlertList(context, alerts),
                    _buildAlertList(context, connectionAlerts),
                    _buildAlertList(context, eventAlerts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Hot',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2563EB),
                  ),
                ),
                TextSpan(
                  text: 'Spot',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            color: const Color(0xFF374151),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 22),
            color: const Color(0xFF374151),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        labelColor: const Color(0xFF2563EB),
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: const Color(0xFF2563EB),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Connections'),
          Tab(text: 'Events'),
        ],
      ),
    );
  }

  Widget _buildAlertList(BuildContext context, List<AlertItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No alerts yet',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _alertCard(context, items[index]),
    );
  }

  Widget _alertCard(BuildContext context, AlertItem item) {
    final isConnection = item.type == AlertType.connection;
    final accent = isConnection ? const Color(0xFF2563EB) : const Color(0xFF10B981);
    final isRead = _readIds.contains(item.id);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? const Color(0xFFF3F4F6) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.15),
            ),
            child: Icon(
              isConnection ? Icons.person_add_alt_1 : Icons.event_available,
              color: accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _buildActions(context, item),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.timeLabel,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, AlertItem item) {
    if (item.type == AlertType.connection) {
      return [
        _actionButton(
          label: 'Accept',
          color: const Color(0xFF2563EB),
          onTap: () => _markRead(context, item, 'Connection accepted'),
        ),
        _actionButton(
          label: 'Decline',
          color: Colors.grey.shade600,
          outlined: true,
          onTap: () => _markRead(context, item, 'Connection declined'),
        ),
      ];
    }

    return [
      _actionButton(
        label: 'Going',
        color: const Color(0xFF10B981),
        onTap: () => _markRead(context, item, 'RSVP set to going'),
      ),
      _actionButton(
        label: 'Dismiss',
        color: Colors.grey.shade600,
        outlined: true,
        onTap: () => _markRead(context, item, 'Alert dismissed'),
      ),
    ];
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: outlined ? color : color,
          ),
        ),
      ),
    );
  }

  void _markRead(BuildContext context, AlertItem item, String message) {
    if (!_readIds.contains(item.id)) {
      setState(() => _readIds.add(item.id));
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  List<AlertItem> _mockAlerts() {
    return const [
      AlertItem(
        id: 'a1',
        type: AlertType.connection,
        title: 'Lena Parker sent a connection request',
        subtitle: '3 mutual interests · Live Music, Food Trucks',
        timeLabel: '2m',
      ),
      AlertItem(
        id: 'a2',
        type: AlertType.event,
        title: 'Trivia Night at Parlor City starts soon',
        subtitle: 'Starts at 7:30 PM · 2.1 miles away',
        timeLabel: '20m',
      ),
      AlertItem(
        id: 'a3',
        type: AlertType.connection,
        title: 'Jordan Lee accepted your request',
        subtitle: 'Say hi and invite them to your next event',
        timeLabel: '1h',
      ),
      AlertItem(
        id: 'a4',
        type: AlertType.event,
        title: 'Cedar Rapids Farmers Market is tomorrow',
        subtitle: 'Reminder set · 8:00 AM',
        timeLabel: '3h',
      ),
      AlertItem(
        id: 'a5',
        type: AlertType.event,
        title: 'Live Music at NewBo Market updated',
        subtitle: 'Venue changed · NewBo City Market',
        timeLabel: '1d',
      ),
    ];
  }
}
