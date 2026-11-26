import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/common/app_shell.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/services/order_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Widget _buildProductImage(String imagePath) {
    final path =
        imagePath.isNotEmpty ? imagePath : AppResources.placeholderProduct;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AppResources.placeholderProduct,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        AppResources.placeholderProduct,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return AppShell(
      selectedIndex: 2,
      selectedDrawerItem: "Orders",
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppResources.bgImageHome,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              _buildTitle(),
              Expanded(
                child: StreamBuilder<List<OrderModel>>(
                  stream: OrderService.instance.getOrdersStream(
                    userId: auth.currentUserId,
                    userEmail: auth.currentUser.email,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppResources.primaryColor,
                        ),
                      );
                    }

                    final orders = snapshot.data ?? [];

                    if (orders.isEmpty) {
                      return const Center(
                        child: Text(
                          "You have not placed any orders yet.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }

                    final activeOrders = orders
                        .where((o) =>
                            o.status.toLowerCase() == "pending" ||
                            o.status.toLowerCase() == "processing" ||
                            o.status.toLowerCase() == "shipped")
                        .toList();

                    final historyOrders = orders
                        .where((o) =>
                            o.status.toLowerCase() == "delivered" ||
                            o.status.toLowerCase() == "cancelled" ||
                            o.status.toLowerCase() == "confirmed")
                        .toList();

                    final firstActive = activeOrders.isNotEmpty
                        ? activeOrders.first
                        : orders.first;

                    final remainingOrders = orders.where((o) => o != firstActive).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(17, 0, 17, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActiveOrder(firstActive),
                          const SizedBox(height: 28),
                          _buildHistoryTitle(),
                          const SizedBox(height: 10),
                          if (remainingOrders.isEmpty && historyOrders.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Text(
                                "No prior order history.",
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                          else
                            ...List.generate(
                              remainingOrders.isNotEmpty
                                  ? remainingOrders.length
                                  : historyOrders.length,
                              (index) {
                                final ord = remainingOrders.isNotEmpty
                                    ? remainingOrders[index]
                                    : historyOrders[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildHistoryOrder(ord),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      alignment: Alignment.center,
      child: const Text(
        "Orders",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
        ),
      ),
    );
  }

  Widget _buildActiveOrder(OrderModel order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final itemName = firstItem?.name ?? "Handcrafted Decor";
    final itemImg = firstItem?.image ?? AppResources.placeholderProduct;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Orders",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
              Text(
                order.orderId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFE4E4E4),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.black,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: _buildProductImage(itemImg),
              ),

              const SizedBox(width: 28),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Date: ${order.date}\nTotal: ₹${order.totalAmount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              _statusBadge(order.status.toUpperCase()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        "OrdersHistory",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildHistoryOrder(OrderModel order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final itemName = firstItem?.name ?? "Artisan Item";
    final itemImg = firstItem?.image ?? AppResources.placeholderProduct;

    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: _buildProductImage(itemImg),
          ),
          const SizedBox(width: 28),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${order.date} - ₹${order.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
              ],
            ),
          ),
          _statusBadge(order.status.toUpperCase()),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool processing = status == "PROCESSING" || status == "PENDING";
    final bool delivered = status == "DELIVERED";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: delivered
            ? const Color(0xFFC8E6C9)
            : (processing ? const Color(0xFFFFDCCB) : const Color(0xFFB9D8FF)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
