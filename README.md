<div align="center">

  <img src="devart_app/lib/assets/images/devart-logo.png" alt="DevArt Logo" width="120" />

  # 🎨 DevArt — Artisan E-Commerce Platform

  **A modern, production-grade Flutter e-commerce application & UI/UX showcase for handcrafted artisan products.**

  <p align="center">
    <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-3.35+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-3.9+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
    <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" /></a>
    <a href="https://www.figma.com/proto/S5bQWaqh9je6CCEzaqppYL/DevArt-Flutter-App?node-id=2-273&p=f&t=6NYSDUl090e1h4K4-0&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=2%3A273&device-frame=0"><img src="https://img.shields.io/badge/Figma-Interactive%20Prototype-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma Prototype" /></a>
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50?style=for-the-badge" alt="Platforms" />
  </p>

  <p align="center">
    <a href="#-key-features">Key Features</a> •
    <a href="#-interactive-figma-prototype">Figma Prototype</a> •
    <a href="#-ui-design-showcase">Design Showcase</a> •
    <a href="#%EF%B8%8F-system-architecture">Architecture</a> •
    <a href="#-getting-started">Getting Started</a> •
    <a href="#-design-system">Design System</a>
  </p>

</div>

---

## 📖 Overview

**DevArt** is an end-to-end mobile commerce solution designed to connect lovers of handmade craftsmanship with authentic artisan creations. Built with Flutter and backed by Google Firebase, DevArt delivers a responsive, visually immersive shopping experience for customers alongside a powerful, real-time administrative command center for store owners.

The project embodies **Tactile Minimalism** and **Warm Organicism**, emphasizing earth tones, subtle drop shadows, smooth page transitions, and responsive typography.

---

## 🌟 Key Features

### 🛍️ Customer Shopping Experience (`/user_panel`)
* **Authentication Suite**: Secure email/password login, registration, OTP verification, and reset password flows.
* **Curated Dashboard**: Dynamic promotional banners, category sliders, search bar, and curated product showcase.
* **Category Exploration**: Filter and browse by collections (e.g., Handwoven Cotton, Pottery, Woodcraft, Textiles).
* **Interactive Product Details**: High-resolution imagery, artisan descriptions, pricing discounts, and quick actions.
* **Cart & Order Flow**: Dynamic real-time calculation of subtotal, tax, and shipping with quantity controls and promo vouchers.
* **Checkout & Payments**: Saved multi-address selector, new address manager, multiple mock payment gateways, and order receipt breakdown.
* **Personal Space**: User profile management, wishlist items tracker, past order history, coupons, and customer help desk.

### 💼 Admin Management Suite (`/admin`)
* **Executive Dashboard**: Store performance KPIs, revenue metrics, active inventory status, and pending order counts.
* **Inventory Control**: Real-time product inventory list, instant stock adjustments, dynamic creation of new items, and full catalog editing.
* **Order Fulfillment**: Track orders across states (`Pending` ➔ `Shipped` ➔ `Delivered` ➔ `Cancelled`) with live customer details.
* **Offer & Voucher Manager**: Configure discount campaigns and promotional vouchers.
* **Customer Directory**: Centralized view of registered store customers and contact channels.

---

## 🔗 Interactive Figma Prototype

Experience the live interactive prototype directly in Figma:

> 🚀 **[Launch DevArt Interactive Figma Prototype](https://www.figma.com/proto/S5bQWaqh9je6CCEzaqppYL/DevArt-Flutter-App?node-id=2-273&p=f&t=6NYSDUl090e1h4K4-0&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=2%3A273&device-frame=0)**

---

## 📱 UI Design Showcase

### 1. Customer Shopping Interface
The customer flow highlights product discoverability, intuitive category navigation, fluid cart operations, and streamlined checkout.

<p align="center">
  <img src="figma/assets/customer_section.png" alt="DevArt Customer Section" width="95%" />
</p>

---

### 2. Admin Management Interface
The store management system provides live visibility over product catalogs, real-time inventory updates, and order workflows.

<p align="center">
  <img src="figma/assets/admin_section.png" alt="DevArt Admin Section" width="95%" />
</p>

---

### 3. Customer Navigation Flow
Comprehensive mapping of user journeys from onboarding and catalogue browsing to checkout and order tracking.

<p align="center">
  <img src="figma/assets/customer_navigation.png" alt="Customer Journey Map" width="95%" />
</p>

---

### 4. Admin Navigation Flow
Architectural route map detailing transitions across administrative control nodes.

<p align="center">
  <img src="figma/assets/admin_navigation.png" alt="Admin Navigation Routes" width="95%" />
</p>

---

## 🏗️ System Architecture

```plaintext
devart/
├── devart_app/                     # Flutter Application Workspace
│   ├── lib/
│   │   ├── admin/                  # Admin portal views & features
│   │   │   ├── customers/          # Customer directory screen
│   │   │   ├── dashboard/          # Store performance metrics
│   │   │   ├── inventory/          # Add, edit, manage product inventory
│   │   │   ├── offers/             # Discounts & coupon management
│   │   │   ├── orders/             # Order fulfillment management
│   │   │   └── profile/            # Store administrator profile
│   │   ├── assets/                 # App icons, vectors, and background images
│   │   ├── common/                 # Reusable UI shells, navigation bars & dialogs
│   │   ├── models/                 # Strongly-typed data models (Product, Order, User)
│   │   ├── services/               # Firebase integration (Auth, Firestore, Storage)
│   │   ├── user_panel/             # Customer shop screens & checkout funnel
│   │   ├── firebase_options.dart   # Firebase multi-platform configuration
│   │   └── main.dart               # Application entry point
│   ├── pubspec.yaml                # App dependencies & asset declarations
│   └── analysis_options.yaml       # Dart linter & code quality rules
├── figma/                          # High-resolution design assets & flow diagrams
└── README.md                       # Project documentation
```

---

## 🎨 Design System

| Element | Specification | Description |
| :--- | :--- | :--- |
| **Primary Accent** | `#8B5E3C` / `#A06D42` | Warm terracotta brown symbolizing raw craftsmanship |
| **Secondary Accent** | `#BFD5FA` / `#C4D9FF` | Soft powder blue for contrasting action items & shells |
| **Background Tint** | `#F8F9FA` / `#F5E9E5` | Off-white canvas providing a clean, uncluttered reading surface |
| **Typography** | `DM Sans` & `Work Sans` | High-legibility modern sans-serif fonts |
| **Corner Radii** | `14px` – `28px` | Soft, friendly curvature on interactive cards and modal sheets |
| **Elevation** | Soft Ambient Blur (3–30px) | Organic depth without harsh drop-shadow boundaries |

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.35.0` or higher)
* [Dart SDK](https://dart.dev/get-dart) (version `3.9.0` or higher)
* An active Android Emulator, iOS Simulator, or physical device
* Configured [Firebase Project](https://firebase.google.com/)

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Prem-Agravat/DevArt_Flutter.git
   cd DevArt_Flutter/devart_app
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Verify analyzer status**:
   ```bash
   flutter analyze
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🛠️ Tech Stack & Libraries

* **Framework**: [Flutter](https://flutter.dev/) (Channel Stable)
* **Language**: [Dart](https://dart.dev/)
* **Authentication**: `firebase_auth`
* **Cloud Database**: `cloud_firestore`
* **Core Utilities**: `firebase_core`, `cupertino_icons`, `http`
* **Design & Prototyping**: [Figma](https://figma.com/)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to open an issue or submit a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

<div align="center">
  <sub>Crafted with passion for authentic art & mobile engineering.</sub>
</div>
