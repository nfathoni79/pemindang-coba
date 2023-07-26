import 'package:flutter/material.dart';
import 'package:pemindang_coba/utils/my_utils.dart';
import 'package:pemindang_coba/viewmodels/home_view_model.dart';
import 'package:pemindang_coba/views/auction_detail_view.dart';
import 'package:pemindang_coba/views/profile_view.dart';
import 'package:pemindang_coba/views/transactions_view.dart';
import 'package:pemindang_coba/views/widgets/auction_card.dart';
import 'package:pemindang_coba/views/widgets/menu_button.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Perindo Pemindang'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ProfileView())),
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return viewModel.initialise();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildBalanceCard(context, viewModel),
                const SizedBox(height: 16),
                const Text(
                  'Lelang Terkini',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                _buildAuctionSection(context, viewModel),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  Widget _buildBalanceCard(BuildContext context, HomeViewModel viewModel) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Wallet',
            ),
            viewModel.seaseedBusy
                ? const CircularProgressIndicator()
                : Text(
                    '${MyUtils.formatNumber(viewModel.seaseed.balance)} IDR',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuButton(
                  iconData: Icons.add_circle_outline,
                  label: 'Setor',
                  color: Colors.blue.shade900,
                  onTap: () => MyUtils.showSnackbar(context, 'Unavailable'),
                ),
                MenuButton(
                  iconData: Icons.arrow_circle_right_outlined,
                  label: 'Kirim',
                  color: Colors.blue.shade900,
                  onTap: () => MyUtils.showSnackbar(context, 'Unavailable'),
                ),
                MenuButton(
                  iconData: Icons.arrow_circle_down_outlined,
                  label: 'Tarik',
                  color: Colors.blue.shade900,
                  onTap: () => MyUtils.showSnackbar(context, 'Unavailable'),
                ),
                MenuButton(
                  iconData: Icons.history,
                  label: 'Riwayat',
                  color: Colors.blue.shade900,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const TransactionsView())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionSection(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.auctionsBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.auctions.isEmpty) {
      return const Text('Belum ada lelang');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: viewModel.auctions
          .map((auction) => AuctionCard(
                auction: auction,
                onDetailPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AuctionDetailView(auctionId: auction.id),
                )),
              ))
          .toList(),
    );
  }
}
