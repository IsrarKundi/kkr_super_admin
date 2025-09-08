import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaabd_web/models/models/users_models/get_users_model.dart';
import '../api_services/user_apis.dart';
import '../../models/utils/snackbars.dart';

class UserController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var isAddingUser = false.obs;
  var isUpdatingUser = false.obs;
  var isDeletingUser = false.obs;
  var users = <User>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasNext = false.obs;
  var hasPrev = false.obs;
  var total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load users when controller is initialized
    getAllUsers();
  }

  /// Add new user
  Future<void> addNewUser({
    required String username,
    required String role,
    required String password,
    required String email,
    required BuildContext context,
  }) async {
    try {
      isAddingUser.value = true;

      final result = await UserService.addNewUser(
        username: username,
        role: role,
        password: password,
        email: email,
      );

      if (result['success']) {
        final userData = result['data']['data'];
        
        // Create a new User object from the response
        final newUser = User(
          id: userData['id'] ?? '', // API might not return ID immediately
          username: userData['username'],
          role: userData['role'],
          email: userData['email'],
          createdAt: DateTime.parse(userData['createdAt']),
          lastActive: userData['lastActive'],
        );

        // Add the new user to the beginning of the list
        users.insert(0, newUser);
        total.value = total.value + 1;

        // Show success message
        showNativeSuccessSnackbar(context, result['data']['message'] ?? 'User created successfully');
        
        // Refresh the users list to get updated data from server
        await getAllUsers();
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Add user error: $e');
    } finally {
      isAddingUser.value = false;
    }
  }

  /// Get all users with pagination
  Future<void> getAllUsers({
    int page = 1,
    int limit = 9,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoading.value = true;
      }

      final result = await UserService.getAllUsers(
        page: page,
        limit: limit,
      );

      if (result['success']) {
        final getUsersModel = GetUsersModel.fromJson(result['data']);
        
        // Update observable variables
        users.value = getUsersModel.data.users;
        currentPage.value = getUsersModel.data.pagination.page;
        totalPages.value = getUsersModel.data.pagination.totalPages;
        hasNext.value = getUsersModel.data.pagination.hasNext;
        hasPrev.value = getUsersModel.data.pagination.hasPrev;
        total.value = getUsersModel.data.pagination.total;
        
        print('Users loaded successfully: ${users.length} users');
      } else {
        print('Failed to load users: ${result['data']['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Get users error: $e');
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Load next page of users
  Future<void> loadNextPage() async {
    if (hasNext.value && !isLoading.value) {
      await getAllUsers(
        page: currentPage.value + 1,
        showLoading: false,
      );
    }
  }

  /// Load previous page of users
  Future<void> loadPreviousPage() async {
    if (hasPrev.value && !isLoading.value && currentPage.value > 1) {
      await getAllUsers(
        page: currentPage.value - 1,
        showLoading: false,
      );
    }
  }

  /// Refresh users list
  Future<void> refreshUsers() async {
    await getAllUsers(page: 1);
  }

  /// Search users by username (local search)
  List<User> searchUsers(String query) {
    if (query.isEmpty) {
      return users;
    }
    return users.where((user) => 
      user.username.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Get users by role (local filter)
  List<User> getUsersByRole(String role) {
    if (role.isEmpty || role.toLowerCase() == 'all') {
      return users;
    }
    return users.where((user) => 
      user.role.toLowerCase() == role.toLowerCase()
    ).toList();
  }

  /// Get user by ID
  User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update user
  Future<void> updateUser({
    required String userId,
    required String username,
    required String role,
    required String password,
    required String email,
    required BuildContext context,
  }) async {
    try {
      isUpdatingUser.value = true;

      final result = await UserService.updateUser(
        userId: userId,
        username: username,
        role: role,
        password: password,
        email: email,
      );

      if (result['success']) {
        // Show success message
        showNativeSuccessSnackbar(context, result['data']['message'] ?? 'User updated successfully');
        
        // Refresh the users list to get updated data from server
        await getAllUsers();
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Update user error: $e');
    } finally {
      isUpdatingUser.value = false;
    }
  }

  /// Delete user
  Future<void> deleteUser({
    required String userId,
    required BuildContext context,
  }) async {
    try {
      isDeletingUser.value = true;

      final result = await UserService.deleteUser(userId: userId);

      if (result['success']) {
        // Remove user from local list
        users.removeWhere((user) => user.id == userId);
        total.value = total.value - 1;

        // Show success message
        showNativeSuccessSnackbar(context, result['data']['message'] ?? 'User deleted successfully');
        
        // Refresh the users list to get updated data from server
        await getAllUsers();
      } else {
        // Show error message from server
        showNativeErrorSnackbar(context, result['data']['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      showNativeErrorSnackbar(context, 'An unexpected error occurred');
      print('Delete user error: $e');
    } finally {
      isDeletingUser.value = false;
    }
  }

  /// Clear all data
  void clearData() {
    users.clear();
    currentPage.value = 1;
    totalPages.value = 1;
    hasNext.value = false;
    hasPrev.value = false;
    total.value = 0;
  }
}