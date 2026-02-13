import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/donor_model.dart';
import '../providers/blood_donation_provider.dart';
import '../repositories/blood_repository.dart';

class BloodDonationScreen extends StatelessWidget {
  const BloodDonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // Provider is scoped as DEEP as possible, only wrapping the interactive content.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChangeNotifierProvider<BloodDonationProvider>(
            create: (_) => BloodDonationProvider(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Main Title
              Text(
                'Find Donors',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Active Requests',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // Toggle Buttons (Find Donors / Active Requests)
              _buildToggleButtons(context),

              const SizedBox(height: 24),

              // Blood Type Filters - ALWAYS VISIBLE
              _buildBloodTypeFilters(context),

              const SizedBox(height: 16),

              // Conditional titles based on selection
              Selector<BloodDonationProvider, int>(
                selector: (_, p) => p.selectedSegment,
                builder: (context, selectedSegment, _) {
                  if (selectedSegment == 0) {
                    return _buildDonorsHeader();
                  } else {
                    return _buildActiveRequestsHeader();
                  }
                },
              ),

              const SizedBox(height: 16),

              // Content based on selection
              Selector<BloodDonationProvider, int>(
                selector: (_, p) => p.selectedSegment,
                builder: (context, selectedSegment, _) {
                  return Expanded(
                    child: selectedSegment == 0
                        ? _buildDonorsList(context)
                        : _buildActiveRequestsList(context),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Register Button (only for Find Donors)
              Selector<BloodDonationProvider, int>(
                selector: (_, p) => p.selectedSegment,
                builder: (context, selectedSegment, _) {
                  if (selectedSegment == 0) {
                    return _buildRegisterButton(context);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      ));
  }

  Widget _buildDonorsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Nearby Donors',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Text(
                'View All',
                style: GoogleFonts.poppins(color: const Color(0xFF00A89D)),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFF00A89D),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveRequestsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Blood Requests',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Consumer<BloodDonationProvider>(
          builder: (context, provider, child) {
            if (provider.selectedBloodType != null) {
              return Text(
                'Showing requests for ${provider.selectedBloodType}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Find Donors Button
          Expanded(
            child: Selector<BloodDonationProvider, int>(
              selector: (_, p) => p.selectedSegment,
              builder: (context, selectedSegment, child) {
                return GestureDetector(
                  onTap: () => context.read<BloodDonationProvider>().selectFindDonors(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedSegment == 0
                          ? const Color(0xFF00A89D)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Find Donors',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: selectedSegment == 0
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Active Requests Button
          Expanded(
            child: Selector<BloodDonationProvider, int>(
              selector: (_, p) => p.selectedSegment,
              builder: (context, selectedSegment, child) {
                return GestureDetector(
                  onTap: () => context.read<BloodDonationProvider>().selectActiveRequests(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedSegment == 1
                          ? const Color(0xFFE53935)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Active Requests',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: selectedSegment == 1
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeFilters(BuildContext context) {
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Blood Type',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: Selector<BloodDonationProvider, String?>(
            selector: (_, p) => p.selectedBloodType,
            builder: (context, selectedBloodType, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloodTypes.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedBloodType == bloodTypes[index];
                  return Container(
                    margin: EdgeInsets.only(
                      right: index == bloodTypes.length - 1 ? 0 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () => context.read<BloodDonationProvider>().selectBloodType(bloodTypes[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00A89D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF00A89D)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          bloodTypes[index],
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      hintText: 'Search donors or hospitals...',
      hintStyle: WidgetStatePropertyAll(
        GoogleFonts.poppins(color: Colors.grey),
      ),
      leading: const Icon(Icons.search, color: Colors.grey),
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(2),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      side: const WidgetStatePropertyAll<BorderSide?>(BorderSide.none),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }


Widget _buildDonorsList(BuildContext context) {
  return Selector<BloodDonationProvider, String?>(
    selector: (_, p) => p.selectedBloodType,
    builder: (context, selectedBloodType, child) {
      return StreamBuilder<List<DonorModel>>(
        stream: BloodRepository().getDonors(), // Firestore stream
        builder: (context, snapshot) {
          // Hardcoded fallback donors
          List<Map<String, dynamic>> fallbackDonors = [
            {
              'bloodType': 'A+',
              'name': 'Ahmed Khan',
              'isVerified': true,
              'distance': '2.3 km',
              'lastDonated': '3 months ago',
            },
            {
              'bloodType': 'O-',
              'name': 'Sara Ali',
              'isVerified': true,
              'distance': '4.1 km',
              'lastDonated': '45 days ago',
            },
            {
              'bloodType': 'B+',
              'name': 'Bilal Hussain',
              'isVerified': false,
              'distance': '5.8 km',
              'lastDonated': '2 months ago',
            },
            {
              'bloodType': 'A+',
              'name': 'Ali Raza',
              'isVerified': true,
              'distance': '1.5 km',
              'lastDonated': '1 month ago',
            },
            {
              'bloodType': 'O-',
              'name': 'Fatima Khan',
              'isVerified': false,
              'distance': '3.2 km',
              'lastDonated': '2 weeks ago',
            },
          ];

          // If Firestore has data, map it; else use fallback
          List<Map<String, dynamic>> donorsList;
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            donorsList = snapshot.data!
                .map((donor) => {
                      'bloodType': donor.bloodType,
                      'name': donor.fullName,
                      'isVerified': donor.status == DonorStatus.verified,
                      'distance': 'N/A', // You can calculate based on location later
                      'lastDonated': 'Recently', // Placeholder
                    })
                .toList();
          } else {
            donorsList = fallbackDonors;
          }

          // Apply filter
          final filteredDonors = selectedBloodType == null
              ? donorsList
              : donorsList
                  .where((donor) => donor['bloodType'] == selectedBloodType)
                  .toList();

          if (filteredDonors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No donors found for $selectedBloodType',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredDonors.length,
            itemBuilder: (context, index) {
              final donor = filteredDonors[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index == filteredDonors.length - 1 ? 0 : 12),
                child: _buildDonorCard(
                  bloodType: donor['bloodType'],
                  name: donor['name'],
                  isVerified: donor['isVerified'],
                  distance: donor['distance'],
                  lastDonated: donor['lastDonated'],
                ),
              );
            },
          );
        },
      );
    },
  );
}


  Widget _buildActiveRequestsList(BuildContext context) {
    return Selector<BloodDonationProvider, String?>(
      selector: (_, p) => p.selectedBloodType,
      builder: (context, selectedBloodType, child) {
        // Filter active requests based on selected blood type
        List<Map<String, dynamic>> allRequests = [
          {
            'units': '2 Units Needed',
            'hospital': 'Jinnah Hospital',
            'priority': 'Critical',
            'timeAgo': '2 hrs ago',
            'bloodType': 'O-',
          },
          {
            'units': '1 Unit Needed',
            'hospital': 'Mayo Hospital',
            'priority': 'High',
            'timeAgo': '4 hrs ago',
            'bloodType': 'AB+',
          },
          {
            'units': '3 Units Needed',
            'hospital': 'Services Hospital',
            'priority': 'Medium',
            'timeAgo': '6 hrs ago',
            'bloodType': 'B+',
          },
          {
            'units': '2 Units Needed',
            'hospital': 'Shaukat Khanum',
            'priority': 'Critical',
            'timeAgo': '1 hr ago',
            'bloodType': 'O-',
          },
          {
            'units': '1 Unit Needed',
            'hospital': 'Aga Khan Hospital',
            'priority': 'High',
            'timeAgo': '3 hrs ago',
            'bloodType': 'A+',
          },
        ];

        // Apply filter if a blood type is selected
        final filteredRequests = selectedBloodType == null
            ? allRequests
            : allRequests
                  .where(
                    (request) =>
                        request['bloodType'] == selectedBloodType,
                  )
                  .toList();

        if (filteredRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No requests found for $selectedBloodType',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredRequests.length,
          itemBuilder: (context, index) {
            final request = filteredRequests[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == filteredRequests.length - 1 ? 0 : 12,
              ),
              child: _buildActiveRequestCard(
                units: request['units'],
                hospital: request['hospital'],
                priority: request['priority'],
                timeAgo: request['timeAgo'],
                bloodType: request['bloodType'],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDonorCard({
    required String bloodType,
    required String name,
    required bool isVerified,
    required String distance,
    required String lastDonated,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Blood Type and Info
            Row(
              children: [
                // Blood Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getBloodTypeColor(bloodType),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bloodType,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and Verification
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (isVerified)
                            Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Distance and Last Donated
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.history,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lastDonated,
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
              ],
            ),

            const SizedBox(height: 16),

            // Contact Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A89D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Contact',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRequestCard({
    required String units,
    required String hospital,
    required String priority,
    required String timeAgo,
    required String bloodType,
  }) {
    Color priorityColor = Colors.grey;
    switch (priority.toLowerCase()) {
      case 'critical':
        priorityColor = const Color(0xFFE53935);
        break;
      case 'high':
        priorityColor = Colors.orange;
        break;
      case 'medium':
        priorityColor = Colors.blue;
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE53935), width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blood Type Badge and Units
            Row(
              children: [
                // Blood Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bloodType,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    units,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Hospital and Priority
            Row(
              children: [
                Icon(
                  Icons.local_hospital,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hospital,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: priorityColor),
                  ),
                  child: Text(
                    priority,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Time and Respond Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(
                    'Respond',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF00A89D),
          side: const BorderSide(color: Color(0xFF00A89D)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: const Color(0xFF00A89D)),
            const SizedBox(width: 8),
            Text(
              'Register as Blood Donor',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBloodTypeColor(String bloodType) {
    return const Color(0xFFE53935); // Red color for all blood types
  }
}
