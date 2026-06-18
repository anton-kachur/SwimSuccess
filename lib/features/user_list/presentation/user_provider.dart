import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<UserModel> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Fetch users from repository and manage screen states
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _repository.fetchUsers();
      _applyFilter();
    } catch (e) {
      // Change this line to see the full technical error details
      _errorMessage = e.toString(); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update search query and re-filter the user list
  void searchUsers(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  // Local filter logic without making additional API calls
  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users
          .where((user) => user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
