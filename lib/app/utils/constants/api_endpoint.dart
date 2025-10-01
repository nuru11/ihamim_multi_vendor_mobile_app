// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'http://192.168.166.3:4000/api';

  /* Authentication */
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  /* vendor */
  static const String getSingleVendor = '$baseUrl/auth/getsinglevendor';

  /* categories */
  static const String getAllCategories = '$baseUrl/categories';

  /* products */
  static const String getAllProducts = '$baseUrl/products';


  // Messages
  static const sendMessage = "$baseUrl/messages";
  static const getConversation = "$baseUrl/messages";
  static const getInbox = "$baseUrl/messages/inbox";
  static const markAsRead = "$baseUrl/messages/read";
  
}