import 'package:flutter/material.dart';
import '../data/models/user_model.dart';

/// A presentation screen displaying full structured profile insights for a specific user.
/// 
/// This view extracts metadata nested deep within the immutable [UserModel], splitting
/// information into discrete logical sections: contact points, address locations, and corporate roles.
class UserDetailScreen extends StatelessWidget {
  /// The immutable model payload containing targeted user information parameters.
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Core demographic metadata and contact information
              _buildSectionHeader('General Info'),
              _buildDetailCard(
                context,
                children: [
                  _buildDetailTile(Icons.person, 'Username', user.username),
                  _buildDetailTile(Icons.email, 'Email', user.email),
                  _buildDetailTile(Icons.phone, 'Phone', user.phone),
                  _buildDetailTile(Icons.web, 'Website', user.website),
                ],
              ),
              const SizedBox(height: 24),

              // Section 2: Residential geolocation layout details
              _buildSectionHeader('Address Details'),
              _buildDetailCard(
                context,
                children: [
                  _buildDetailTile(Icons.location_city, 'City', user.address.city),
                  _buildDetailTile(
                    Icons.home,
                    'Street',
                    '${user.address.street}, ${user.address.suite}',
                  ),
                  _buildDetailTile(Icons.local_post_office, 'Zip Code', user.address.zipcode),
                ],
              ),
              const SizedBox(height: 24),

              // Section 3: B2B company assignments and corporate catchphrases
              _buildSectionHeader('Company Info'),
              _buildDetailCard(
                context,
                children: [
                  _buildDetailTile(Icons.business, 'Company Name', user.company.name),
                  _buildDetailTile(Icons.format_quote, 'Catch Phrase', '"${user.company.catchPhrase}"'),
                  _buildDetailTile(Icons.work, 'Business Target', user.company.bs),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper UI component generating stylized category labels for block headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Helper UI component wrapping sets of data tiles into bounded Surface container blocks
  Widget _buildDetailCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  // Helper UI component aligning single properties cleanly alongside descriptive metadata icons
  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
