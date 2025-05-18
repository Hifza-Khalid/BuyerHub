<h1 align="center">🛍️ BuyerHub</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Firebase-Cloud-orange?logo=firebase" />
  <img src="https://img.shields.io/badge/Stripe-Payments-purple?logo=stripe" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow" />
</p>

<p align="center">
  <b>📲 A clean, modern Flutter shopping app for buyers - complete with authentication, cart, profile & Stripe payments.</b>
</p>

---

## 🌟 Overview

**BuyerHub** is a full-featured Flutter mobile application that simulates the **buyer journey in an e-commerce app**. It’s built with scalability, performance, and aesthetics in mind.

It allows users to:
- 🔐 Log in / Sign up securely
- 🛒 Browse and search products
- ➕ Add items to cart
- 💸 Checkout using Stripe
- 👤 Edit their profile

---

## ✨ Features

| Category          | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| 🔐 Authentication | Email & Password login/signup via Firebase Auth                            |
| 📦 Product List   | Grid & categorized product listing from Firestore                          |
| 🔍 Search & Filter | Search bar and category filtering support                                 |
| 🛒 Cart & Checkout| Dynamic cart system with quantity control                                  |
| 💳 Payment        | Stripe Payment Integration (test keys setup)                              |
| 🧑 Profile         | Editable user profile, profile image upload, password update              |
| 📱 Responsive UI  | Pixel-perfect design using Flutter widgets and VelocityX styling           |
| 🧠 State Management| Reactive GetX-based architecture                                           |

---

## 📲 Demo

Coming soon...  
<!-- You can embed video or screen-recording here once ready -->

---

## 🧰 Tech Stack

| Layer          | Technology        |
|----------------|-------------------|
| 💻 Frontend     | Flutter (Dart)     |
| 🔙 Backend      | Firebase (Auth + Firestore) |
| 💼 Payments     | Stripe (REST API) |
| 🎨 UI Toolkit   | VelocityX, Custom Widgets |
| ⚙️ State Mgmt    | GetX              |

---

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter SDK installed → [Install Guide](https://flutter.dev/docs/get-started/install)
- Firebase project with Firestore & Auth enabled
- Stripe developer account (for test keys)

### 📦 Installation

```bash
git clone https://github.com/Hifza-Khalid/BuyerHub.git
cd BuyerHub
flutter pub get
````

### 🔧 Firebase Setup

1. Create Firebase project.
2. Enable **Email/Password** authentication.
3. Create a Firestore DB with collections:

   * `users`
   * `products`
4. Download `google-services.json` and place in:

```
android/app/google-services.json
```

### 💳 Stripe Setup

> Add your test keys in `lib/services/payment_service.dart`

```dart
static const String stripePublishableKey = 'pk_test_...';
static const String stripeSecretKey = 'sk_test_...';
```

---

## 🗂️ Project Structure

```
lib/
│
├── consts/             # Constants (Colors, Strings, Images)
├── controllers/        # GetX Controllers for Auth, Profile, Home
├── models/             # Data Models (e.g. Category)
├── services/           # Payment and Firestore integrations
├── views/              # UI Screens (Home, Auth, Cart, Profile, etc.)
├── widgets_common/     # Custom reusable widgets
└── main.dart           # App entry point
```

---

## 📷 Screenshots

| 🟢 Login                                           | 🛒 Home                                           | 🧾 Product Details                                   |
| -------------------------------------------------- | ------------------------------------------------- | ---------------------------------------------------- |
| <img src="assets/screens/login.png" width="200" /> | <img src="assets/screens/home.png" width="200" /> | <img src="assets/screens/details.png" width="200" /> |

---

## 💡 Upcoming Features

* ❤️ Wishlist & Favorites
* 🔔 Push Notifications (via Firebase Cloud Messaging)
* 📦 Seller Module
* 🧾 Order History & Invoice Download
* 🌐 Multi-language support

---

## 🤝 Contributing

Want to contribute? Here’s how:

1. 🍴 Fork the repo
2. 🔧 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. ✅ Commit your changes (`git commit -m 'Add awesome feature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🔃 Open a Pull Request

---

## 🧑‍💻 Authors

* 👩‍💻 **Hifza Khalid** — [GitHub](https://github.com/Hifza-Khalid) | [su92-bssem-f22-202@superior.edu.pk](mailto:su92-bssem-f22-202@superior.edu.pk)
* 👨‍💻 **Baqir Sultan** — [su92-bssem-f22-201@superior.edu.pk](mailto:su92-bssem-f22-201@superior.edu.pk)
* 👨‍💻 **Hafiz Muhammad Zubair** — [su92-bssem-f22-196@superior.edu.pk](mailto:su92-bssem-f22-196@superior.edu.pk)

🎓 *BS Software Engineering (2022-2026)*
🎓 *Superior University, Lahore*

---

## 📚 Resources & Credits

* [Flutter Docs](https://docs.flutter.dev)
* [Firebase Docs](https://firebase.google.com/docs/flutter/setup)
* [Stripe API](https://stripe.com/docs)
* [VelocityX](https://velocityx.dev)
* Icons & UI inspiration from [Dribbble](https://dribbble.com/)

---

## 📜 License

📌 This project is licensed under academic use only — not intended for commercial deployment.
