import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lifelink/providers/medicine_provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:lifelink/constants/medicine_constants.dart'; // ADD THIS IMPORT

// Remove these constants, now use MedicineConstants
// const Color medicineColor = Color(0xFF8E44AD);
// const Color medicineLightColor = Color(0xFFF3E5F5);
// const Color medicineForegroundColor = Colors.white;

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: const _MedicineScreenBody(),
    );
  }
}

class _MedicineScreenBody extends StatelessWidget {
  const _MedicineScreenBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MedicineConstants.medicineColor,
                  Colors.purple.shade700,
                ],
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
                        color: MedicineConstants.medicineForegroundColor
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.medication,
                        color: MedicineConstants.medicineForegroundColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medicine Hub',
                          style: GoogleFonts.poppins(
                            color: MedicineConstants.medicineForegroundColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Share & find essential medicines',
                          style: GoogleFonts.poppins(
                            color: MedicineConstants.medicineForegroundColor
                                .withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search medicines...',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          const _MedicineTabs(),

          // Categories - Now optimized to only listen to selectedCategory
          const _MedicineCategories(),

          const SizedBox(height: 16),

          // Content based on active tab
          Expanded(
            child: Consumer<MedicineProvider>(
              builder: (context, provider, child) {
                return provider.activeTab == 'find'
                    ? const _FindMedicineContent()
                    : const _DonateMedicineContent();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineTabs extends StatelessWidget {
  const _MedicineTabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Find Medicine Tab
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Provider.of<MedicineProvider>(
                    context,
                    listen: false,
                  ).selectFindTab();
                },
                child: Consumer<MedicineProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: provider.activeTab == 'find'
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: provider.activeTab == 'find'
                            ? [
                                BoxShadow(
                                  color: MedicineConstants.medicineColor
                                      .withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Find Medicine',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: provider.activeTab == 'find'
                                ? MedicineConstants.medicineColor
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Donate Medicine Tab
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Provider.of<MedicineProvider>(
                    context,
                    listen: false,
                  ).selectDonateTab();
                },
                child: Consumer<MedicineProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: provider.activeTab == 'donate'
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: provider.activeTab == 'donate'
                            ? [
                                BoxShadow(
                                  color: MedicineConstants.medicineColor
                                      .withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Donate Medicine',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: provider.activeTab == 'donate'
                                ? MedicineConstants.medicineColor
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineCategories extends StatelessWidget {
  const _MedicineCategories();

  @override
  Widget build(BuildContext context) {
    // Get static categories list ONCE (no listener)
    final categories = MedicineConstants.categories;

    return Consumer<MedicineProvider>(
      // Only listen to selectedCategory changes
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = provider.selectedCategory == category['id'];
                return Container(
                  margin: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : 8,
                  ),
                  child: GestureDetector(
                    onTap: () => provider.selectCategory(category['id']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? MedicineConstants.medicineColor
                            : MedicineConstants.medicineLightColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: MedicineConstants.medicineColor
                                      .withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        category['label'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isSelected
                              ? MedicineConstants.medicineForegroundColor
                              : MedicineConstants.medicineColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FindMedicineContent extends StatelessWidget {
  const _FindMedicineContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: MedicineConstants.medicineColor,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading medicines...',
                  style: GoogleFonts.poppins(
                    color: MedicineConstants.medicineColor,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with count
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Medicines',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${provider.medicines.length} items',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Medicines List
              Expanded(
                child: provider.medicines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No medicines available',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Be the first to donate!',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = provider.medicines[index];
                          return _MedicineCard(medicine: medicine);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const _MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: MedicineConstants.medicineLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medication,
                color: MedicineConstants.medicineColor,
                size: 32,
              ),
            ),

            const SizedBox(width: 12),

            // Medicine Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Verification
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              medicine['generic'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (medicine['verified'])
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 16,
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.inventory,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${medicine['quantity']} units',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Exp: ${medicine['expiry']}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              medicine['distance'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Donor and Request Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'from ${medicine['donor']}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MedicineConstants.medicineColor,
                          foregroundColor:
                              MedicineConstants.medicineForegroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Request',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonateMedicineContent extends StatelessWidget {
  const _DonateMedicineContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Donate Medicine Card
            Container(
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Plus Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: MedicineConstants.medicineLightColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: MedicineConstants.medicineColor,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'Donate Medicine',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      'Have surplus or near-expiry medicine? Share it with those in need.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Add Medicine Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showDonateDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MedicineConstants.medicineColor,
                          foregroundColor:
                              MedicineConstants.medicineForegroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.medication),
                        label: Text(
                          'Add Medicine Donation',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Guidelines
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guidelines',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...MedicineConstants.donationGuidelines.map(
                            (guideline) => _buildGuidelineItem(guideline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 8),
            child: Text('•', style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDonateDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => DonateMedicineDialog());
  }
}

// Dialog widget remains the same but uses MedicineConstants
class DonateMedicineDialog extends StatefulWidget {
  const DonateMedicineDialog({super.key});

  @override
  State<DonateMedicineDialog> createState() => _DonateMedicineDialogState();
}

// In medicine_screen.dart, update the _DonateMedicineDialogState class
class _DonateMedicineDialogState extends State<DonateMedicineDialog> {
  late TextEditingController _medicineNameController;
  late TextEditingController _genericNameController;
  late TextEditingController _quantityController;
  late TextEditingController _expiryDateController;
  late TextEditingController _pickupAddressController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MedicineProvider>(context, listen: false);

    _medicineNameController = TextEditingController(
      text: provider.donationFormData['medicineName'],
    );
    _genericNameController = TextEditingController(
      text: provider.donationFormData['genericName'],
    );
    _quantityController = TextEditingController(
      text: provider.donationFormData['quantity'],
    );
    _expiryDateController = TextEditingController(
      text: provider.donationFormData['expiryDate'],
    );
    _pickupAddressController = TextEditingController(
      text: provider.donationFormData['pickupAddress'],
    );
    _descriptionController = TextEditingController(
      text: provider.donationFormData['description'],
    );
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _genericNameController.dispose();
    _quantityController.dispose();
    _expiryDateController.dispose();
    _pickupAddressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... static header content
              const SizedBox(height: 20),

              // Form Fields
              Column(
                children: [
                  // Medicine Name - ONLY listens to medicineName
                  Selector<MedicineProvider, String>(
                    selector: (context, provider) =>
                        provider.donationFormData['medicineName'] ?? '',
                    builder: (context, medicineName, child) {
                      return _buildFormField(
                        label: 'Medicine Name *',
                        hintText: 'e.g., Panadol Extra',
                        controller: _medicineNameController,
                        onChanged: (value) {
                          Provider.of<MedicineProvider>(
                            context,
                            listen: false,
                          ).updateDonationFormField('medicineName', value);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Generic Name - ONLY listens to genericName
                  Selector<MedicineProvider, String>(
                    selector: (context, provider) =>
                        provider.donationFormData['genericName'] ?? '',
                    builder: (context, genericName, child) {
                      return _buildFormField(
                        label: 'Generic Name',
                        hintText: 'e.g., Paracetamol 500mg',
                        controller: _genericNameController,
                        onChanged: (value) {
                          Provider.of<MedicineProvider>(
                            context,
                            listen: false,
                          ).updateDonationFormField('genericName', value);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Category Dropdown - ONLY listens to category
                  Selector<MedicineProvider, String>(
                    selector: (context, provider) =>
                        provider.donationFormData['category'] ?? 'other',
                    builder: (context, category, child) {
                      return _buildCategoryDropdown(context, category);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Quantity and Expiry Date Row
                  Row(
                    children: [
                      // Quantity - ONLY listens to quantity
                      Expanded(
                        child: Selector<MedicineProvider, String>(
                          selector: (context, provider) =>
                              provider.donationFormData['quantity'] ?? '',
                          builder: (context, quantity, child) {
                            return _buildFormField(
                              label: 'Quantity *',
                              hintText: 'e.g., 20',
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                Provider.of<MedicineProvider>(
                                  context,
                                  listen: false,
                                ).updateDonationFormField('quantity', value);
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Expiry Date - ONLY listens to expiryDate
                      Expanded(
                        child: Selector<MedicineProvider, String>(
                          selector: (context, provider) =>
                              provider.donationFormData['expiryDate'] ?? '',
                          builder: (context, expiryDate, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date *',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _expiryDateController,
                                  decoration: InputDecoration(
                                    hintText: 'MM/YYYY',
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey.shade500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: MedicineConstants.medicineColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    Provider.of<MedicineProvider>(
                                      context,
                                      listen: false,
                                    ).updateDonationFormField(
                                      'expiryDate',
                                      value,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Pickup Address - ONLY listens to pickupAddress
                  Selector<MedicineProvider, String>(
                    selector: (context, provider) =>
                        provider.donationFormData['pickupAddress'] ?? '',
                    builder: (context, pickupAddress, child) {
                      return _buildFormField(
                        label: 'Pickup Address',
                        hintText: 'e.g., 123 Main St, Lahore',
                        controller: _pickupAddressController,
                        onChanged: (value) {
                          Provider.of<MedicineProvider>(
                            context,
                            listen: false,
                          ).updateDonationFormField('pickupAddress', value);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Additional Notes - ONLY listens to description
                  Selector<MedicineProvider, String>(
                    selector: (context, provider) =>
                        provider.donationFormData['description'] ?? '',
                    builder: (context, description, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Notes',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Any additional information about the medicine...',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              onChanged: (value) {
                                Provider.of<MedicineProvider>(
                                  context,
                                  listen: false,
                                ).updateDonationFormField('description', value);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Footer Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Provider.of<MedicineProvider>(
                        context,
                        listen: false,
                      ).closeDonateDialog();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Submit button doesn't need to listen to anything
                  ElevatedButton(
                    onPressed: () {
                      // Validate before submitting
                      if (_medicineNameController.text.isEmpty ||
                          _quantityController.text.isEmpty ||
                          _expiryDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all required fields',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Provider.of<MedicineProvider>(
                        context,
                        listen: false,
                      ).submitDonation();
                      Navigator.of(context).pop();

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Thank you for donating ${_medicineNameController.text}!',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedicineConstants.medicineColor,
                      foregroundColor:
                          MedicineConstants.medicineForegroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Submit Donation',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } // Category Dropdown Widget

  Widget _buildCategoryDropdown(BuildContext context, String currentCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentCategory,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              onChanged: (String? newValue) {
                Provider.of<MedicineProvider>(
                  context,
                  listen: false,
                ).updateDonationFormField('category', newValue ?? 'other');
              },
              items: MedicineConstants.donationCategories
                  .map<DropdownMenuItem<String>>((
                    Map<String, dynamic> category,
                  ) {
                    return DropdownMenuItem<String>(
                      value: category['id'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(category['label']),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: MedicineConstants.medicineColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
