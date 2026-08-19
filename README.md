# 🎨 DevArt UI/UX Mobile Design Showcase

Welcome to the design showcase and code repository for **DevArt**, a premium, high-fidelity mobile application UI/UX concept and Flutter implementation. This repository contains the interactive Figma prototype and design specifications for both the **Customer Shopping Experience** and the **Store Admin Panel**, along with the full codebase of the Flutter application.

---

## 📱 Flutter Implementation (Market Ready)

We are building a full-featured, high-fidelity Flutter application based on this design. It is developed to be a production-ready mobile application, fully optimized and ready to run in the market.

To run the application, navigate to the `devart_app` directory:
```bash
cd devart_app
flutter pub get
flutter run
```

---

## 🔗 Interactive Prototype & Design Links

* **⚡ Live Interactive Prototype**: [Launch Figma Prototype](https://www.figma.com/proto/S5bQWaqh9je6CCEzaqppYL/DevArt-Flutter-App?node-id=2-273&p=f&t=6NYSDUl090e1h4K4-0&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=2%3A273&device-frame=0)

---

## 📁 Repository Layout

To maintain a clean repository structure, the repository is organized as follows:

```plaintext
├── devart_app/            # Market-ready Flutter application code
├── figma/
│   └── assets/            # Figma exported screens & user journey diagrams
└── README.md              # Project documentation and design spec guide
```

---

## 🗺️ Design Architecture & Flow Layers

Here is the breakdown of the application design, structured across four primary layers representing the mobile interface and the interactive user flows:

### 🛍️ Layer 1: Customer Section
This layer showcases the end-user shopping application. It features clean authentication screens, product grids with categories, detailed product view screens, a shopping cart manager, checkout stages, and account tabs (wishlist, orders list, support, and active coupons).

![Customer Section](figma/assets/customer_section.png)

---

### 💼 Layer 2: Admin Section
This layer contains the administrative control screens for shop owners. It features the admin dashboard, real-time product inventory control lists, product editing tools, and an interface for adding new items.

![Admin Section](figma/assets/admin_section.png)

---

### 🗺️ Layer 3: Customer Navigation
This layer diagrams the interactive flow and screen transition routes designed for the customer's shopping journey. It maps how a user moves from browsing the homepage to selecting items, adding them to the cart, and completing a mock checkout.

![Customer Navigation](figma/assets/customer_navigation.png)

---

### ⚙️ Layer 4: Admin Navigation
This layer diagrams the administrative flow routes. It details the connection pathways between the owner dashboard, editing products, modifying inventory stocks, and managing store settings.

![Admin Navigation](figma/assets/admin_navigation.png)

---

## 🎨 Design System & Styling Details

The app uses **Tactile Minimalism** and **Soft Organicism** to evoke warmth and premium craft.

* **Palette**: 
  - Primary Earthy Brown: `#8B5E3C` (buttons, brand-heavy highlights)
  - Secondary Soft Blue: `#A9C7EB` (chips, soft backgrounds)
  - Scaffold Background: Off-white (`#F8F9FA`)
* **Typography**:
  - Geometric Headlines: `DM Sans`
  - High-readability Body/UI Text: `Work Sans`
* **Spacing**: 8px baseline rhythm with 20px screen margins.
* **Shapes**: Safe, soft 12px–20px corner radius on cards, panels, and buttons.
