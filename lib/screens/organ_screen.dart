import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lifelink/providers/organ_provider.dart';

// Organ-themed colors
const Color organColor = Color(0xFF00A89D); // Teal color from LifeLink
const Color organForegroundColor = Colors.white;
const Color organLightColor = Color(0xFFE0F2F1);

class OrganScreen extends StatelessWidget {
  const OrganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: const _OrganScreenBody(),
    );
  }
}

class _OrganScreenBody extends StatelessWidget {
  const _OrganScreenBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [organColor, Colors.teal.shade700],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Title
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: organForegroundColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: organForegroundColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organ Donation',
                            style: GoogleFonts.poppins(
                              color: organForegroundColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Give the gift of life',
                            style: GoogleFonts.poppins(
                              color: organForegroundColor.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Stats Banner
                  Consumer<OrganProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          // Registered Donors
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: organForegroundColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    provider.registeredDonors.toString(),
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Registered Donors',
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor.withOpacity(
                                        0.8,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Transplants Done
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: organForegroundColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    provider.transplantsDone.toString(),
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Transplants Done',
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor.withOpacity(
                                        0.8,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // On Waitlist
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: organForegroundColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${provider.onWaitlist}+',
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'On Waitlist',
                                    style: GoogleFonts.poppins(
                                      color: organForegroundColor.withOpacity(
                                        0.8,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Pledge Status
            const _PledgeStatusSection(),

            // Organ Statistics
            const _OrganStatisticsSection(),

            // Info Cards
            const _InfoCardsSection(),

            // CTA Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to pledge form
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: organColor,
                    foregroundColor: organForegroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.favorite),
                  label: Text(
                    'Pledge to Donate Organs',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PledgeStatusSection extends StatelessWidget {
  const _PledgeStatusSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Pledge Status',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Consumer<OrganProvider>(
            builder: (context, provider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Progress Steps
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: provider.pledgeSteps.map((step) {
                          final isCompleted = step['completed'] as bool;
                          final isLast =
                              step['step'] == provider.pledgeSteps.length;

                          return Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Step Number/Circle
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Colors.green
                                            : Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: isCompleted
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : Text(
                                                step['step'].toString(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),

                                    // Connector Line (except for last step)
                                    if (!isLast)
                                      Positioned(
                                        left: 32,
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  provider.pledgeSteps.length -
                                              32,
                                          height: 2,
                                          color: isCompleted
                                              ? Colors.green
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Step Title
                                Text(
                                  step['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Complete Consent Form Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            provider.completeConsentForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: organColor,
                            foregroundColor: organForegroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.description),
                          label: Text(
                            'Complete Consent Form',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrganStatisticsSection extends StatelessWidget {
  const _OrganStatisticsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organ Statistics',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Consumer<OrganProvider>(
            builder: (context, provider, child) {
              return Column(
                children: provider.organTypes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final organ = entry.value;

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: index == provider.organTypes.length - 1 ? 0 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Organ Icon (Using emoji)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: organLightColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                organ['icon'],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Organ Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  organ['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Text(
                                      '${organ['available']} available',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '${organ['waitlist'].toString()} on waitlist',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Chevron Icon
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoCardsSection extends StatelessWidget {
  const _InfoCardsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: provider.infoCards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;

              return Container(
                margin: EdgeInsets.only(
                  bottom: index == provider.infoCards.length - 1 ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (card['iconColor'] as Color).withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: card['backgroundColor'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          card['icon'],
                          color: card['iconColor'],
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              card['description'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chevron Icon
                      Icon(
                        Icons.chevron_right,
                        color: card['iconColor'],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
