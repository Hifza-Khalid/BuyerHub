<p align="center">
  <img src="https://github.com/Hifza-Khalid/BuyerHub/blob/main/assets/images/banner.gif" alt="Github Banner">
</p>

<h1 align="center">🛍️ BuyerHub</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Firebase-Cloud-orange?logo=firebase" />
  <img src="https://img.shields.io/badge/Stripe-Payments-purple?logo=stripe" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow" />
</p>

<p align="center">
  <b>📲 A clean, modern Flutter shopping app for buyers – complete with authentication, cart, profile & Stripe payments.</b>
</p>

---

## 🌟 Overview

**BuyerHub** is a full-featured Flutter mobile application that simulates the **buyer journey in an e-commerce app**. Built with scalability, performance, and aesthetics in mind, it allows users to:

- 🔐 Secure login/sign-up via Firebase
- 🛒 Browse and search for categorized products
- ➕ Add items to cart with quantity control
- 💳 Checkout using Stripe (test keys)
- 👤 Manage profile and update account info

---

## ✨ Features

| Feature              | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| 🔐 Authentication     | Secure login/signup with Firebase                                 |
| 📦 Product Listing    | Real-time product display using Firestore                         |
| 🔍 Search & Filter    | Search bar with category-based filtering                          |
| 🛒 Cart System        | Add to cart, quantity adjust, remove items                        |
| 💳 Stripe Checkout    | Online payments using test Stripe API                             |
| 👤 Profile Management | Edit user info, update password, profile image                    |
| 📱 Responsive UI      | Smooth UI built with Flutter + VelocityX                          |
| ⚙️ State Management    | Efficient navigation and data flow via GetX                      |

---

## 📊 Buyer Journey Diagram

```mermaid
graph TD;
    A[🔍 Browse Products] --> B[🛒 Add to Cart];
    B --> C[🧾 Checkout];
    C --> D[💳 Make Payment];
    D --> E[✅ Order Confirmation];
````

---

## 📈 Mobile Commerce Usage Graph

![Mobile Commerce Share](https://quickchart.io/chart?c=%7B%22type%22%3A%22pie%22%2C%22data%22%3A%7B%22labels%22%3A%5B%22Mobile%22%2C%22Desktop%22%2C%22Tablet%22%5D%2C%22datasets%22%3A%5B%7B%22data%22%3A%5B65%2C30%2C5%5D%2C%22backgroundColor%22%3A%5B%22%234caf50%22%2C%22%234482f4%22%2C%22%23ff9800%22%5D%7D%5D%7D%2C%22options%22%3A%7B%22plugins%22%3A%7B%22legend%22%3A%7B%22position%22%3A%22bottom%22%7D%2C%22datalabels%22%3A%7B%22display%22%3Atrue%2C%22color%22%3A%22white%22%2C%22font%22%3A%7B%22weight%22%3A%22bold%22%7D%7D%7D%2C%22title%22%3A%7B%22display%22%3Atrue%2C%22text%22%3A%22Mobile%20vs%20Desktop%20E-Commerce%20Usage%22%2C%22font%22%3A%7B%22size%22%3A18%7D%7D%7D%7D)

> 🧠 Insight: Over 65% of global e-commerce happens on **mobile** – validating BuyerHub’s mobile-first focus.


## 📦 Tech Stack

| Layer         | Technology                  |
| ------------- | --------------------------- |
| 💻 Frontend   | Flutter (Dart)              |
| 🔙 Backend    | Firebase (Auth + Firestore) |
| 💼 Payments   | Stripe (via REST API)       |
| 🎨 UI Toolkit | VelocityX, Custom Widgets   |
| ⚙️ State Mgmt | GetX                        |

---

## 🚀 Getting Started

### ✅ Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Firebase Project (Firestore + Auth enabled)
* Stripe Developer Account (test mode)

### 📦 Installation

```bash
git clone https://github.com/Hifza-Khalid/BuyerHub.git
cd BuyerHub
flutter pub get
```

### 🔧 Firebase Setup

1. Create Firebase project
2. Enable **Email/Password Authentication**
3. Add `google-services.json` to:

```
android/app/google-services.json
```

4. Create Firestore collections:

   * `users`
   * `products`

### 💳 Stripe Setup

Update the following in `lib/services/payment_service.dart`:

```dart
static const String stripePublishableKey = 'pk_test_...';
static const String stripeSecretKey = 'sk_test_...';
```

---

## 🗂️ Project Structure

```
lib/
├── consts/             # Constants (colors, images, strings)
├── controllers/        # Business logic (GetX)
├── models/             # Data models (e.g. Category)
├── services/           # Firestore + Payment services
├── views/              # UI Screens
├── widgets_common/     # Reusable components
└── main.dart           # Entry point

---

## 💡 Upcoming Features

* ❤️ Wishlist & Favorites
* 🔔 Push Notifications (via Firebase Cloud Messaging)
* 📦 Seller/Admin Module
* 🧾 Order History + Invoicing
* 🌐 Multi-language Support

---

## 🤝 Contributing

```bash
🍴 Fork the repo
🔧 Create your branch: git checkout -b feature/YourFeature
✅ Commit changes: git commit -m "Add feature"
📤 Push to GitHub: git push origin feature/YourFeature
🔃 Open a pull request
```

---

## 🧑‍💻 Authors

| Name                        | Email                                                                           | GitHub                                    |
| --------------------------- | ------------------------------------------------------------------------------- | ----------------------------------------- |
| 👩‍💻 Hifza Khalid          | [su92-bssem-f22-202@superior.edu.pk](mailto:su92-bssem-f22-202@superior.edu.pk) | [GitHub](https://github.com/Hifza-Khalid) |
| 👨‍💻 Baqir Sultan          | [su92-bssem-f22-201@superior.edu.pk](mailto:su92-bssem-f22-201@superior.edu.pk) | –                                         |
| 👨‍💻 Hafiz Muhammad Zubair | [su92-bssem-f22-196@superior.edu.pk](mailto:su92-bssem-f22-196@superior.edu.pk) | –                                         |

🎓 *BS Software Engineering (2022–2026), Superior University, Lahore*

---

## 📚 References

* [Flutter Docs](https://docs.flutter.dev)
* [Firebase Docs](https://firebase.google.com/docs)
* [Stripe Docs](https://stripe.com/docs)
* [VelocityX Docs](https://velocityx.dev)
* [Dribbble](https://dribbble.com) – UI Inspiration

---

## 📜 License

📌 **Academic Use Only** — This project is developed for educational purposes and not intended for commercial deployment.
