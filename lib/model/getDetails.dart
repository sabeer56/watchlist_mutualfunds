// models/fund.dart
import 'package:flutter/material.dart';

class Fund {
  final String name;
  final String category;
  final double currentNav;
  final double returns;

  Fund({
    required this.name,
    required this.category,
    required this.currentNav,
    required this.returns,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fund &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ category.hashCode;
}

// models/watchlist.dart
class Watchlist {
  String name;
  List<Fund> funds;

  Watchlist({
    required this.name,
    required this.funds,
  });
}



class WatchlistProvider with ChangeNotifier {
  List<Watchlist> _watchlists = [];

  List<Watchlist> get watchlists => _watchlists;

  void addWatchlist(Watchlist watchlist) {
    _watchlists.add(watchlist);
    notifyListeners();
    // Save to local storage
  }

  void removeWatchlist(Watchlist watchlist) {
    _watchlists.remove(watchlist);
    notifyListeners();
    // Update local storage
  }

  void renameWatchlist(Watchlist watchlist, String newName) {
    watchlist.name = newName;
    notifyListeners();
    // Update local storage
  }

  void addFundToWatchlist(Watchlist watchlist, Fund fund) {
    if (!watchlist.funds.contains(fund)) {
      watchlist.funds.add(fund);
      notifyListeners();
      // Update local storage
    }
  }

  void removeFundFromWatchlist(Watchlist watchlist, Fund fund) {
    watchlist.funds.remove(fund);
    notifyListeners();
    // Update local storage
  }

  // Load from local storage
  Future<void> loadWatchlists() async {
    // Implement loading from Hive or SharedPreferences
    notifyListeners();
  }
}


class FundProvider with ChangeNotifier {
  Fund? _selectedFund;

  Fund? get selectedFund => _selectedFund;

  void selectFund(Fund fund) {
    _selectedFund = fund;
    notifyListeners();
  }

  void clearSelection() {
    _selectedFund = null;
    notifyListeners();
  }
}