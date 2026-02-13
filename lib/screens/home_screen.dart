import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/screens/chatbot_screen.dart';
import 'package:lifelink/screens/medicine_screen.dart';
import 'package:lifelink/screens/organ_screen.dart';

import 'blood_donation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Quick Actions'),
                    const SizedBox(height: 16),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildUrgentRequestCard(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Community Impact'),
                    const SizedBox(height: 16),
                    _buildCommunityImpact(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Recent Activity'),
                    const SizedBox(height: 16),
                    _buildRecentActivity(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [const Color(0xFF00A89D), Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Muhammad Abdal',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your contributions have helped save 12 lives this month',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BloodDonationScreen(),
              ),
            );
          },
          child: _buildActionCard(
            context,
            'Blood',
            Icons.bloodtype,
            const Color(0xFFFFE5E5),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MedicineScreen(),
              ),
            );
          },
          child: _buildActionCard(
            context,
            'Medicine',
            Icons.medication,
            const Color(0xFFE5E5FF),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrganScreen(),
              ),
            );
          },
          child: _buildActionCard(
            context,
            'Organ',
            Icons.favorite_outline,
            const Color(0xFFE5F9FF),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatbotScreen(),
              ),
            );
          },
          child: _buildActionCard(
            context,
            'AI Chat',
            Icons.smart_toy_outlined,
            const Color(0xFFE0F2F1),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _getActionIconColor(title), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getActionIconColor(title),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionIconColor(String title) {
    switch (title) {
      case 'Blood':
        return Colors.red;
      case 'Medicine':
        return Colors.purple;
      case 'Organ':
        return Colors.blue;
      case 'AI Chat':
        return const Color(0xFF00A89D);
      case 'Emergency':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Widget _buildUrgentRequestCard(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.red.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFE53935),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'URGENT REQUEST',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'O- Blood Needed',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.history, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  '2 hrs ago',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.local_hospital_outlined,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Jinnah Hospital, Lahore',
                    style: GoogleFonts.poppins(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text('Respond Now', style: GoogleFonts.poppins()),
                ),
                Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityImpact(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildImpactCard(
          context,
          '12,450',
          'Active Donors',
          Icons.people,
          const Color(0xFFE0F2F1),
          '+245',
        ),
        _buildImpactCard(
          context,
          '8,234',
          'Lives Saved',
          Icons.favorite,
          const Color(0xFFFFF3E0),
          '+89',
        ),
        _buildImpactCard(
          context,
          '3,567',
          'Medicines Shared',
          Icons.medication,
          const Color(0xFFEDE7F6),
          '+156',
        ),
        _buildImpactCard(
          context,
          '127',
          'Active Requests',
          Icons.show_chart,
          const Color(0xFFE3F2FD),
          'Now',
          isChipGreen: false,
        ),
      ],
    );
  }

  Widget _buildImpactCard(
    BuildContext context,
    String count,
    String label,
    IconData icon,
    Color color,
    String chipText, {
    bool isChipGreen = true,
  }) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 28),
                Chip(
                  label: Text(
                    chipText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: isChipGreen ? Colors.green : Colors.orange,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bottom content anchored safely
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      children: [
        _buildActivityItem(
          context,
          'Blood Donation Completed',
          'You donated 1 unit of A+ blood',
          'Services Hospital • 2 days ago',
          Icons.bloodtype,
          const Color(0xFFFFE5E5),
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          context,
          'Medicine Request Fulfilled',
          'Paracetamol 500mg delivered',
          'Mayo Hospital • 5 days ago',
          Icons.medication,
          const Color(0xFFE5E5FF),
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          context,
          'Organ Pledge Updated',
          'You updated your consent form',
          '1 week ago',
          Icons.favorite_outline,
          const Color(0xFFE5F9FF),
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle1,
    String subtitle2,
    IconData icon,
    Color iconBgColor,
    Color statusColor,
  ) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(icon, color: _getActionIconColorFromBg(iconBgColor)),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle1,
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle2,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(
          statusColor == Colors.green
              ? Icons.check_circle
              : Icons.hourglass_top,
          color: statusColor,
        ),
      ),
    );
  }

  Color _getActionIconColorFromBg(Color bgColor) {
    if (bgColor == const Color(0xFFFFE5E5)) return Colors.red;
    if (bgColor == const Color(0xFFE5E5FF)) return Colors.purple;
    if (bgColor == const Color(0xFFE5F9FF)) return Colors.blue;
    return Colors.black;
  }
}
