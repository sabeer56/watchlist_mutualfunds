// widgets/watchlist.dart
import 'package:flutter/material.dart';
import 'package:khazana/model/getDetails.dart';
import 'package:provider/provider.dart';

class WatchlistSection extends StatefulWidget {
  const WatchlistSection({super.key});

  @override
  State<WatchlistSection> createState() => _WatchlistSectionState();
}

class _WatchlistSectionState extends State<WatchlistSection> {
  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final watchlists = watchlistProvider.watchlists;

    return SingleChildScrollView(
      
      padding: const EdgeInsets.all(16.0),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Watchlists',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateWatchlistDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (watchlists.isEmpty)
            const Center(
              child: Text('No watchlists yet. Create one to get started!'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: watchlists.length,
              itemBuilder: (context, index) {
                final watchlist = watchlists[index];
                return _buildWatchlistCard(watchlist);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWatchlistCard(Watchlist watchlist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              watchlist.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showWatchlistOptions(watchlist);
              },
            ),
          ),
          if (watchlist.funds.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No funds in this watchlist'),
            )
          else
            Column(
              children: watchlist.funds.map((fund) {
                return _buildFundItem(fund, watchlist);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFundItem(Fund fund, Watchlist watchlist) {
    return ListTile(
      title: Text(fund.name),
      subtitle: Text(fund.category),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${fund.currentNav}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${fund.returns}%',
            style: TextStyle(
              color: fund.returns >= 0 ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to fund details
      },
    );
  }

  void _showCreateWatchlistDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Watchlist'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Watchlist Name',
              hintText: 'e.g., Top Performers',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<WatchlistProvider>(context, listen: false)
                      .addWatchlist(Watchlist(
                    name: nameController.text,
                    funds: [],
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showWatchlistOptions(Watchlist watchlist) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _showRenameWatchlistDialog(watchlist);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Provider.of<WatchlistProvider>(context, listen: false)
                    .removeWatchlist(watchlist);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Funds'),
              onTap: () {
                Navigator.pop(context);
                _showAddFundsDialog(watchlist);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRenameWatchlistDialog(Watchlist watchlist) {
    final TextEditingController nameController = 
        TextEditingController(text: watchlist.name);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Watchlist'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'New Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<WatchlistProvider>(context, listen: false)
                      .renameWatchlist(watchlist, nameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddFundsDialog(Watchlist watchlist) {
    // In a real app, you would fetch available funds from an API
    final availableFunds = [
      Fund(name: 'Motilal Oswal Midcap', category: 'Equity', currentNav: 1280, returns: -14.7),
      Fund(name: 'Axis Bluechip', category: 'Large Cap', currentNav: 45.2, returns: 12.3),
      Fund(name: 'Mirae Asset Emerging', category: 'Equity', currentNav: 85.6, returns: 18.5),
    ];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Funds to Watchlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableFunds.length,
              itemBuilder: (context, index) {
                final fund = availableFunds[index];
                return CheckboxListTile(
                  title: Text(fund.name),
                  subtitle: Text(fund.category),
                  value: watchlist.funds.contains(fund),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        Provider.of<WatchlistProvider>(context, listen: false)
                            .addFundToWatchlist(watchlist, fund);
                      } else {
                        Provider.of<WatchlistProvider>(context, listen: false)
                            .removeFundFromWatchlist(watchlist, fund);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}