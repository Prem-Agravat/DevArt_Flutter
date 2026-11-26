import 'package:devart/models/product_model.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/models/customer_model.dart';

class LocalData {
  static List<ProductModel> sampleProducts = getInitialProducts();
  static List<OrderModel> sampleOrders = getInitialOrders();
  static List<OfferModel> sampleOffers = getInitialOffers();
  static List<CustomerModel> sampleCustomers = getInitialCustomers();
  static List<Map<String, String>> sampleAddresses = getInitialAddresses();

  static List<ProductModel> getInitialProducts() {
    return [
      ProductModel(
        id: 'prod_cushion_01',
        name: 'Indigo Embroidered Cushion Cover',
        category: 'Cushion Covers',
        price: 899.0,
        oldPrice: 1099.0,
        stock: 18,
        description:
            'Hand-dyed indigo pure cotton cushion cover with exquisite geometric embroidery. Woven by master artisan weavers using organic vegetable dyes.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ProductModel(
        id: 'prod_toran_01',
        name: 'Handcrafted Mirror-Work Toran',
        category: 'Toran',
        price: 1299.0,
        oldPrice: 1599.0,
        stock: 12,
        description:
            'Traditional Gujarati doorway hanging toran crafted with vibrant silk thread embroidery, brass bells, and authentic mirror embellishments.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ProductModel(
        id: 'prod_sofa_01',
        name: 'Artisan Velvet 5-Seater Sofa Cover',
        category: 'Sofa Covers',
        price: 2499.0,
        oldPrice: 2999.0,
        stock: 8,
        description:
            'Luxurious quilted sofa cover set with anti-slip backing. Protects living room furniture with rich royal texture and elegant craftsmanship.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ProductModel(
        id: 'prod_bedsheet_01',
        name: 'Floral Handloom Pure Cotton Bedsheet',
        category: 'Bedsheet',
        price: 1199.0,
        oldPrice: 1499.0,
        stock: 15,
        description:
            'Breathable 300-thread-count Jaipur hand-block printed queen-size bedsheet with two matching pillow covers.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      ProductModel(
        id: 'prod_cushion_02',
        name: 'Boho Tufted Geometric Cushion Set',
        category: 'Cushion Covers',
        price: 1499.0,
        oldPrice: 1899.0,
        stock: 10,
        description:
            'Set of 2 textured bohemian tufted cushion covers with soft fringe tassels. Ideal for modern living spaces and cozy corners.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ProductModel(
        id: 'prod_toran_02',
        name: 'Royal Marigold & Pearl Hanging Toran',
        category: 'Toran',
        price: 699.0,
        oldPrice: 899.0,
        stock: 20,
        description:
            'Festive floral doorway bandhanwar handcrafted with golden beads, artificial marigold buds, and auspicious motif hangings.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      ProductModel(
        id: 'prod_sofa_02',
        name: 'Jacquard Fitted L-Shape Sofa Cover',
        category: 'Sofa Covers',
        price: 3299.0,
        oldPrice: 3999.0,
        stock: 6,
        description:
            'Highly stretchable jacquard knitted universal slipcover designed specifically for sectional and corner L-shaped sofa setups.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ProductModel(
        id: 'prod_pottery_01',
        name: 'Terracotta Handpainted Ceramic Vase',
        category: 'Pottery',
        price: 749.0,
        oldPrice: 999.0,
        stock: 14,
        description:
            'Rustic natural clay pot fired in wood kilns and hand-painted by rural pottery artisans with tribal mandala motifs.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ProductModel(
        id: 'prod_cushion_03',
        name: 'Rajasthani Block Print Cushion Cover',
        category: 'Cushion Covers',
        price: 599.0,
        oldPrice: 799.0,
        stock: 25,
        description:
            'Pure cotton ethnic cushion cover featuring authentic Sanganeri wooden block print designs and neat zip closure.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
      ProductModel(
        id: 'prod_handicraft_01',
        name: 'Handmade Wooden Carved Wall Jharokha',
        category: 'Handicrafts',
        price: 1899.0,
        oldPrice: 2299.0,
        stock: 7,
        description:
            'Vintage antique finish Sheesham wooden arched wall hanging with miniature hand-painted floral panels.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      ProductModel(
        id: 'prod_toran_03',
        name: 'Traditional Shubh Labh Beads Toran',
        category: 'Toran',
        price: 499.0,
        oldPrice: 649.0,
        stock: 22,
        description:
            'Auspicious festive doorway entrance toran with handcrafted embroidery, pearls, and sacred traditional blessings.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
      ),
      ProductModel(
        id: 'prod_sofa_03',
        name: 'Quilted 3-Seater Reversible Sofa Slipcover',
        category: 'Sofa Covers',
        price: 1899.0,
        oldPrice: 2299.0,
        stock: 9,
        description:
            'Double-sided water-resistant protective sofa cover designed with convenient side storage pockets for TV remotes and books.',
        image: 'lib/assets/images/devart_product_1.webp',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
  }

  static List<Map<String, String>> getCategories() {
    return [
      {
        "name": "Cushion Covers",
        "count": "28",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Premium handmade cushion covers with timeless craftsmanship and comfort.",
      },
      {
        "name": "Toran",
        "count": "18",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Beautiful handmade doorway torans designed to add festive elegance to your home.",
      },
      {
        "name": "Sofa Covers",
        "count": "24",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Elegant and durable sofa covers crafted for comfort, style, and furniture protection.",
      },
      {
        "name": "Bedsheet",
        "count": "15",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Pure cotton breathable handloom bedsheets with traditional block printed patterns.",
      },
      {
        "name": "Pottery",
        "count": "12",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Authentic terracotta and ceramic pottery vases fired with natural rustic glazes.",
      },
      {
        "name": "Handicrafts",
        "count": "16",
        "image": "lib/assets/images/devart_product_1.webp",
        "description":
            "Timeless artisan woodwork, heritage wall panels, and authentic Indian folk collectibles.",
      },
    ];
  }

  static List<OfferModel> getInitialOffers() {
    final now = DateTime.now();
    return [
      OfferModel(
        id: 'offer_1',
        title: 'Festive Special 20% Off',
        code: 'FESTIVE20',
        discount: 20.0,
        discountType: 'Percentage',
        validFrom: DateTime(now.year, 1, 1),
        validUntil: DateTime(now.year + 1, 12, 31),
        status: 'Active',
        description:
            'Get 20% discount on all festive handcrafted home decor & torans.',
        minSpend: 999.0,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      OfferModel(
        id: 'offer_2',
        title: 'New Shopper Welcome Discount',
        code: 'WELCOME10',
        discount: 10.0,
        discountType: 'Percentage',
        validFrom: DateTime(now.year, 1, 1),
        validUntil: DateTime(now.year + 1, 12, 31),
        status: 'Active',
        description: 'Exclusive 10% discount on your first artisan purchase.',
        minSpend: 499.0,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      OfferModel(
        id: 'offer_3',
        title: 'DevArt Brand Special Offer',
        code: 'DEVART10',
        discount: 10.0,
        discountType: 'Percentage',
        validFrom: DateTime(now.year, 1, 1),
        validUntil: DateTime(now.year + 1, 12, 31),
        status: 'Active',
        description: 'Instant 10% discount across the complete store catalog.',
        minSpend: 0.0,
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      OfferModel(
        id: 'offer_4',
        title: 'Flat ₹500 Mega Savings',
        code: 'FLAT500',
        discount: 500.0,
        discountType: 'Fixed',
        validFrom: DateTime(now.year, 1, 1),
        validUntil: DateTime(now.year + 1, 12, 31),
        status: 'Active',
        description:
            'Flat ₹500 instant discount on high-value orders above ₹2000.',
        minSpend: 2000.0,
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      OfferModel(
        id: 'offer_5',
        title: 'Artisan Textile Privilege',
        code: 'ARTISAN20',
        discount: 20.0,
        discountType: 'Percentage',
        validFrom: DateTime(now.year, 1, 1),
        validUntil: DateTime(now.year + 1, 12, 31),
        status: 'Active',
        description:
            'Enjoy 20% off on all cushion covers and sofa cover collections.',
        minSpend: 1200.0,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      OfferModel(
        id: 'offer_6',
        title: 'Monsoon Clearance Offer',
        code: 'MONSOON50',
        discount: 50.0,
        discountType: 'Percentage',
        validFrom: DateTime(now.year, now.month - 2, 1),
        validUntil: DateTime(now.year, now.month - 1, 1),
        status: 'Expired',
        description: 'Seasonal end of monsoon collection discount.',
        minSpend: 3000.0,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
    ];
  }

  static List<OrderModel> getInitialOrders() {
    return [
      OrderModel(
        id: 'ord_1001',
        orderId: '#DVT-1001',
        customer: 'Rahul Patel',
        email: 'rahulpatel@gmail.com',
        phone: '+91 98765 12345',
        address: '402, Shivam Heights, Kalawad Road, Rajkot - 360005',
        date: '23 Aug 2026',
        items: [
          OrderItemModel(
            name: 'Indigo Embroidered Cushion Cover (16×16)',
            quantity: 2,
            price: 899.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          OrderItemModel(
            name: 'Handcrafted Mirror-Work Toran',
            quantity: 1,
            price: 1299.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ],
        deliveryFee: 0.0,
        discount: 200.0,
        status: 'Pending',
        paymentMethod: 'Cash on Delivery (COD)',
        paymentStatus: 'Pending (COD)',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      OrderModel(
        id: 'ord_1002',
        orderId: '#DVT-1002',
        customer: 'Priya Shah',
        email: 'priyashah@gmail.com',
        phone: '+91 98765 67890',
        address: '12, Shanti Niketan Society, University Road, Rajkot - 360005',
        date: '22 Aug 2026',
        items: [
          OrderItemModel(
            name: 'Artisan Velvet 5-Seater Sofa Cover',
            quantity: 1,
            price: 2499.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          OrderItemModel(
            name: 'Boho Tufted Geometric Cushion Set',
            quantity: 1,
            price: 1499.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ],
        deliveryFee: 36.0,
        discount: 500.0,
        status: 'Shipped',
        paymentMethod: 'Cash on Delivery (COD)',
        paymentStatus: 'Pending (COD)',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      OrderModel(
        id: 'ord_1003',
        orderId: '#DVT-1003',
        customer: 'Amit Joshi',
        email: 'amitjoshi@gmail.com',
        phone: '+91 98765 24680',
        address: 'B-304, Royal Palms, 150 Feet Ring Road, Rajkot - 360004',
        date: '21 Aug 2026',
        items: [
          OrderItemModel(
            name: 'Royal Marigold & Pearl Hanging Toran',
            quantity: 2,
            price: 699.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          OrderItemModel(
            name: 'Terracotta Handpainted Ceramic Vase',
            quantity: 1,
            price: 749.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ],
        deliveryFee: 0.0,
        discount: 100.0,
        status: 'Delivered',
        paymentMethod: 'Cash on Delivery (COD)',
        paymentStatus: 'Paid',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      OrderModel(
        id: 'ord_1004',
        orderId: '#DVT-1004',
        customer: 'Neha Mehta',
        email: 'nehamehta@gmail.com',
        phone: '+91 98765 13579',
        address: '78, Golden Park, Amin Marg, Rajkot - 360001',
        date: '20 Aug 2026',
        items: [
          OrderItemModel(
            name: 'Floral Handloom Pure Cotton Bedsheet',
            quantity: 1,
            price: 1199.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          OrderItemModel(
            name: 'Rajasthani Block Print Cushion Cover',
            quantity: 2,
            price: 599.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ],
        deliveryFee: 0.0,
        discount: 239.0,
        status: 'Delivered',
        paymentMethod: 'Cash on Delivery (COD)',
        paymentStatus: 'Paid',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      OrderModel(
        id: 'ord_1005',
        orderId: '#DVT-1005',
        customer: 'Dev Chauhan',
        email: 'devchauhan@gmail.com',
        phone: '+91 98765 43210',
        address: '501, Silver Crest, Nana Mava Road, Rajkot - 360005',
        date: '19 Aug 2026',
        items: [
          OrderItemModel(
            name: 'Jacquard Fitted L-Shape Sofa Cover',
            quantity: 1,
            price: 3299.0,
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ],
        deliveryFee: 0.0,
        discount: 0.0,
        status: 'Cancelled',
        paymentMethod: 'Cash on Delivery (COD)',
        paymentStatus: 'Refunded / Cancelled',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static List<CustomerModel> getInitialCustomers() {
    return [
      CustomerModel(
        id: 'cust_1',
        name: 'Dev Chauhan',
        email: 'devchauhan@gmail.com',
        phone: '+91 98765 43210',
        orders: 14,
        spent: '₹28,499',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      CustomerModel(
        id: 'cust_2',
        name: 'Rahul Patel',
        email: 'rahulpatel@gmail.com',
        phone: '+91 98765 12345',
        orders: 8,
        spent: '₹14,799',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
      ),
      CustomerModel(
        id: 'cust_3',
        name: 'Priya Shah',
        email: 'priyashah@gmail.com',
        phone: '+91 98765 67890',
        orders: 19,
        spent: '₹34,899',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 28)),
      ),
      CustomerModel(
        id: 'cust_4',
        name: 'Amit Joshi',
        email: 'amitjoshi@gmail.com',
        phone: '+91 98765 24680',
        orders: 5,
        spent: '₹7,299',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      CustomerModel(
        id: 'cust_5',
        name: 'Neha Mehta',
        email: 'nehamehta@gmail.com',
        phone: '+91 98765 13579',
        orders: 22,
        spent: '₹41,599',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      CustomerModel(
        id: 'cust_6',
        name: 'Prem Agravat (Admin)',
        email: 'admin@devart.com',
        phone: '+91 98277 14260',
        orders: 31,
        spent: '₹68,900',
        role: 'admin',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];
  }

  static List<Map<String, String>> getInitialAddresses() {
    return [
      {
        "type": "Home",
        "name": "Dev Chauhan",
        "phone": "+91 98765 43210",
        "address":
            "Dev Chauhan, 501 Silver Crest, Nana Mava Road, Rajkot, Gujarat - 360005",
      },
      {
        "type": "Office",
        "name": "Dev Chauhan",
        "phone": "+91 98765 43210",
        "address":
            "Dev Chauhan, 402 Heritage Complex, Kalawad Road, Rajkot, Gujarat - 360005",
      },
    ];
  }

  static List<Map<String, String>> getFaqs() {
    return [
      {
        "question": "How can I track my home decor order?",
        "answer":
            "Open the 'Orders' tab from the bottom navigation to track the real-time status of your active and past orders.",
      },
      {
        "question": "What is the return and replacement policy?",
        "answer":
            "All handmade cushion covers, torans, and sofa covers can be returned or exchanged within 7 days of delivery in their original condition.",
      },
      {
        "question": "Are all cushion and sofa covers machine washable?",
        "answer":
            "Most pure cotton and jacquard covers are gentle-cycle machine washable. Embroidered mirror-work items are recommended for dry cleaning.",
      },
      {
        "question": "Do you accept custom size orders for sofa covers?",
        "answer":
            "Yes! Contact our support team via WhatsApp or Email with your furniture dimensions for customized artisan stitching.",
      },
      {
        "question": "How do I apply coupon codes during checkout?",
        "answer":
            "Enter your coupon code (e.g., FESTIVE20 or DEVART10) in the promo code field on the Cart screen and click Apply.",
      },
    ];
  }
}
