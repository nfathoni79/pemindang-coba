import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/auction.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/models/store.dart';
import 'package:pemindang_coba/models/transaction.dart';
import 'package:pemindang_coba/models/user.dart';
import 'package:pemindang_coba/models/user_token.dart';
import 'package:pemindang_coba/services/prefs_service.dart';

class LioService {
  // static const String baseUrl = 'http://10.0.2.2:8011';
  // static const String clientId = 'OsICEuPxJeliGMUUgD4QWdLrScABZ6iYNlufK0HS';
  // static const String clientSecret =
  //     'PcNgOsWkSNEanccbitKRwe0shukYpElWgmPl0dk8rYDEraiQT6DKRAb2ejUhlvuDI6MgDav0tnIgsE0BF5N024RDkbDy3OAYUlLooQalQjaLEtQkqWu6SFyPmFo8ZdtC';

  static const String baseUrl = 'https://tpi-staging.perindo.id';
  static const String clientId = 'UzWRvKhifLEqElHhcvjY1udlMbTRIigfINfJtdSg';
  static const String clientSecret =
      '5ZC4GNcSXjyjNtjHgPzi6WghJPTGTXWUr8hE8n9rKCtZh3hSk1KYWY7OEHupRPuYwGEdBylx88lKcTKh0qWzVqRv9ABMvk21AAS9ZpnhJv8a1z3LY70Jc16EOU9npf0P';

  final _prefsService = locator<PrefsService>();

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

  /// Login. Get token to access other APIs.
  Future<UserToken> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: {
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      await _prefsService.setTokens(token.accessToken, token.refreshToken);

      return token;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get token.';
    throw Exception(message);
  }

  /// Get a new token if old token is expired.
  Future<UserToken> refreshToken() async {
    String? refreshToken = await _prefsService.getRefreshToken();

    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );

    if (response.statusCode == 200) {
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      await _prefsService.setTokens(token.accessToken, token.refreshToken);

      return token;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get a new token.';
    throw Exception(message);
  }

  /// Register a new user.
  Future<bool> createUser(String username, String fullName, String phone,
      String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/v2/register/'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'email': email,
        'phone': phone,
        'full_name': fullName,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to register.';
    throw Exception(message);
  }

  /// Get current user.
  Future<User> getUser() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/user/v2/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return User.fromJson(body['user']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get user.';
    throw Exception(message);
  }

  /// Create a new Seaseed User.
  Future<bool> createSeaseedUser() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/seaseed/users/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createSeaseedUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create Seaseed user';
    throw Exception(message);
  }

  /// Get current Seaseed user.
  Future<SeaseedUser> getSeaseedUser() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return SeaseedUser.fromJson(body['user']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getSeaseedUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get Seaseed user.';
    throw Exception(message);
  }

  /// Get user's Seaseed transaction list.
  Future<List<Transaction>> getTransactions() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/seaseed/transactions/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List transactions = body['transactions'];

      return transactions
          .map((trx) => Transaction.fromJson(trx))
          .toList()
          .reversed
          .toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getTransactions();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get transactions.';
    throw Exception(message);
  }

  /// Get store/location list.
  Future<List<Store>> getStores() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/stores/?prefix=PI'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List stores = body['stores'];

      return stores.map((store) => Store.fromJsonAlter(store)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getStores();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get stores';
    throw Exception(message);
  }

  /// Get auction list filtered by store.
  Future<List<Auction>> getAuctionsByStore(String slug) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/?store=$slug'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getAuctionsByStore(slug);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions.';
    throw Exception(message);
  }

  /// Get your auction list filtered by store.
  Future<List<Auction>> getYourAuctionsByStore(String slug) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/?store=$slug&own=1'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getYourAuctionsByStore(slug);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions';
    throw Exception(message);
  }

  /// Get recent auction list.
  Future<List<Auction>> getRecentAuctions() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/recent/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List auctions = body['auctions'];

      return auctions.map((auction) => Auction.fromJson(auction)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getRecentAuctions();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auctions.';
    throw Exception(message);
  }

  /// Get a single auction by ID.
  Future<Auction> getAuctionById(int id) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/lelang/v2/auctions/detail/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Auction.fromJson(jsonDecode(response.body)['auction']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getAuctionById(id);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get auction.';
    throw Exception(message);
  }

  /// Make a bid to a certain auction.
  Future<bool> createBid(int auctionId, int price) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/lelang/v2/bids/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'auction_id': '$auctionId',
        'price': '$price',
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createBid(auctionId, price);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create bid.';
    throw Exception(message);
  }
}
