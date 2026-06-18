import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/user_repository.dart';

/// Presentation state controller managing lifecycle operations and offline lookup filters for the User Directory.
/// 
/// This class orchestrates asynchronous network payloads from [UserRepository], translates 
/// runtime errors into visible feedback channels, and implements optimized client-side searching.
class UserProvider extends ChangeNotifier {
  // Encapsulated concrete repository subsystem handling dataset transactions
  final UserRepository _repository = UserRepository();

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  /// Exposes the reactive collection of users matching the current search parameters.
  List<UserModel> get users => _filteredUsers;

  /// Tracks background API transactions to update global platform progress indicators.
  bool get isLoading => _isLoading;

  /// Holds current connection exception details or server status failure messages.
  String? get errorMessage => _errorMessage;

  /// Holds the current string lookup configuration value.
  String get searchQuery => _searchQuery;

  /// Triggers a background remote query sequence to reload the data collection.
  /// 
  /// Manages loading states transparently, resolves exceptions, and falls back to 
  /// local filtering rules once payload segments are pulled successfully.
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _repository.fetchUsers();
      // Instantly populate the visible array using the base fetched results
      _applyFilter();
    } catch (e) {
      // Expose the absolute raw technical layout description directly to the UI panel
      _errorMessage = e.toString().replaceAll('Exception: ', ''); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new string search parameter and updates visible list collections.
  void searchUsers(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  // Performs atomic client-side lookups across cached fields without issuing redundant API steps
  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      // Create an isolated reference copy of the source array to prevent mutating core state layers
      _filteredUsers = List.from(_users);
    } else {
      // Filter memory snapshots cleanly based on dynamic low-case character mapping metrics
      _filteredUsers = _users
          .where((user) => user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

