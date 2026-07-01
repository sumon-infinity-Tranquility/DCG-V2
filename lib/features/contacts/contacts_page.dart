import 'package:flutter/material.dart';

import '../../core/theme/dcg_theme.dart';
import '../../data/emergency_data.dart';
import '../../widgets/shared_widgets.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Emergency contacts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Tap a card action for immediate feedback. Phone integration can be enabled with url_launcher later.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        for (final contact in contacts)
          AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: contact.online ? const Color(0xFFE7F8F1) : const Color(0xFFEFF2F7),
                  child: Icon(Icons.call_rounded, color: contact.online ? DcgTheme.green : DcgTheme.muted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(contact.name, style: Theme.of(context).textTheme.titleMedium)),
                          LiveBadge(text: contact.online ? 'online' : 'standby', muted: !contact.online),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(contact.role, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text(contact.phone, style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$value ${contact.phone}')),
                  ),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'Calling', child: Text('Call')),
                    PopupMenuItem(value: 'Copied', child: Text('Copy number')),
                    PopupMenuItem(value: 'Shared', child: Text('Share case')),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
