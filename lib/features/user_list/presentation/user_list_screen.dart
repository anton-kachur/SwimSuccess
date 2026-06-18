import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'user_detail_screen.dart';

/// Presentation layer view displaying a searchable directory list of fetched user accounts.
/// 
/// This screen actively listens to state transitions from [UserProvider], displaying tailored
/// states for active background loading, systemic networking errors, and empty query results.
class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Actively monitor real-time reactive state parameters from UserProvider
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Directory'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search input section dispatching string lookup variables to the provider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                onChanged: (value) => provider.searchUsers(value),
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Flexible layout tree switching component bodies depending on background state flags
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                  : provider.errorMessage != null
                      ? _buildErrorWidget(context, provider.errorMessage!, provider.loadUsers)
                      : provider.users.isEmpty
                          ? const Center(child: Text('No users found.'))
                          : RefreshIndicator(
                              onRefresh: () => provider.loadUsers(),
                              color: Colors.blueAccent,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: provider.users.length,
                                itemBuilder: (context, index) {
                                  final user = provider.users[index];
                                  return Card(
                                    color: Theme.of(context).colorScheme.surface,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      title: Text(
                                        user.name,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.email, size: 16, color: Colors.grey),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(user.email)),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                                              const SizedBox(width: 8),
                                              Text(user.phone),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                      onTap: () {
                                        // Forward the fully parsed, immutable type directly to the detail route
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserDetailScreen(user: user),
                                          ),
                                        );
                                      },
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

  // Helper UI component delivering isolated warning cards with built-in action fallback callbacks
  Widget _buildErrorWidget(BuildContext context, String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: onRetry,
              child: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

