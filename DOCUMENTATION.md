# 🚗 AutoHub - Complete Application Documentation

**Version:** 1.0.0  
**Platform:** Flutter (Cross-Platform - Android, iOS, Web)  
**Theme:** Car Buying & Selling Marketplace  
**Date:** November 11, 2025

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [App Architecture](#app-architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Screen Documentation](#screen-documentation)
6. [Widget Catalog](#widget-catalog)
7. [Database Schema](#database-schema)
8. [Navigation Flow](#navigation-flow)
9. [State Management](#state-management)
10. [Assets & Resources](#assets--resources)
11. [Dependencies](#dependencies)
12. [Code Conventions](#code-conventions)

---

## 1. Project Overview

### 1.1 Introduction

**AutoHub** is a comprehensive car marketplace mobile application built with Flutter. It allows users to browse, search, buy, and sell cars with a modern, intuitive interface. The app provides a seamless experience for both buyers and sellers with features like advanced search, real-time chat, and detailed car listings.

### 1.2 Key Features

- ✅ **50 Fully Functional Screens**
- ✅ **User Authentication System** (Login, Registration, OTP Verification)
- ✅ **Onboarding Experience** (3 Screens + Splash)
- ✅ **Advanced Search & Filtering**
- ✅ **Real-time Chat System**
- ✅ **Multi-step Car Listing Creation**
- ✅ **Profile Management**
- ✅ **SQLite Database Integration**
- ✅ **Modern Dashboard UI**
- ✅ **Bottom Navigation Bar**
- ✅ **Form Validation**
- ✅ **Alert Dialogs & Toasts**
- ✅ **Price Alerts**
- ✅ **Car Comparison**
- ✅ **Review System**

### 1.3 Target Users

- Individual car buyers
- Individual car sellers
- Car dealerships
- Auto enthusiasts

---

## 2. App Architecture

### 2.1 Architecture Pattern

The app follows a **Feature-Based Architecture** with the following layers:

```
lib/
├── main.dart                 # Entry point
├── screens/                  # UI Layer (50 screens)
│   ├── auth/                # Authentication
│   ├── onboarding/          # Onboarding flow
│   ├── home/                # Home & Browse
│   ├── profile/             # User Profile
│   ├── sell/                # Selling features
│   ├── chat/                # Messaging
│   ├── notifications/       # Notifications
│   ├── settings/            # Settings
│   └── reviews/             # Reviews
└── helper/                   # Business Logic Layer
    └── db_helper.dart       # Database operations
```

### 2.2 Design Patterns Used

- **Singleton Pattern**: Database helper (`DbHelper.getInstance`)
- **StatefulWidget Pattern**: For dynamic UI components
- **Provider Pattern**: For state management (via StatefulWidget)
- **Builder Pattern**: Custom widget builders
- **Navigator Pattern**: For routing and navigation

---

## 3. Technology Stack

### 3.1 Core Framework

- **Flutter SDK**: ^3.9.0
- **Dart**: ^3.9.0

### 3.2 Key Packages

| Package                 | Version | Purpose                      |
| ----------------------- | ------- | ---------------------------- |
| `sqflite`               | ^2.4.2  | Local database (SQLite)      |
| `path_provider`         | ^2.1.5  | Access file system paths     |
| `shared_preferences`    | ^2.2.2  | Simple data persistence      |
| `pin_code_fields`       | ^8.0.1  | OTP input fields             |
| `curved_navigation_bar` | ^1.0.3  | Bottom navigation (optional) |
| `path`                  | ^1.9.1  | Path manipulation            |

### 3.3 Design System

- **Color Scheme**:

  - Primary: `#FFB347` (Orange)
  - Background Dark: `#1A1A1A`
  - Card Background: `#2C2C2C`
  - Text: `#FFFFFF` (White)
  - Success: `#4CAF50`
  - Error: `#F44336`

- **Typography**:
  - Archivo (SemiBold, Condensed, ExtraCondensed)
  - Hegarty (Regular)
  - Roboto (Regular, Bold, Light)

---

## 4. Project Structure

### 4.1 Complete Screen Hierarchy

```
📱 AutoHub App (50 Screens)
│
├── 🔐 Authentication Module (7 screens)
│   ├── splash.dart                    # Splash screen with routing logic
│   ├── Login.dart                     # User login
│   ├── createAccount.dart             # Registration
│   ├── forgotPassword.dart            # Password recovery
│   ├── verifyOTP.dart                 # OTP verification
│   ├── changePassword.dart            # Password change
│   └── profilesetup.dart              # Initial profile setup
│
├── 📖 Onboarding Module (3 screens)
│   ├── onboarding1.dart               # First intro screen
│   ├── onboarding2.dart               # Second intro screen
│   └── onboarding3.dart               # Third intro screen
│
├── 🏠 Home & Browse Module (13 screens)
│   ├── navbar.dart                    # Bottom navigation controller
│   ├── homeScreen.dart                # Welcome dashboard
│   ├── startpage.dart                 # Main home with categories
│   ├── searchpage.dart                # Search interface
│   ├── search_result_page.dart        # Search results
│   ├── car_detail_page.dart           # Individual car details
│   ├── browse/
│   │   ├── brand_browse.dart          # Browse by brand
│   │   ├── category_browse.dart       # Browse by category
│   │   ├── recommended_cars.dart      # Recommended listings
│   │   ├── recently_viewed.dart       # Recently viewed cars
│   │   ├── compare_cars.dart          # Car comparison tool
│   │   └── comparison_results_screen.dart  # Comparison results
│   └── filter/
│       └── advanced_filter_screen.dart     # Advanced filtering
│
├── 💼 Sell Module (8 screens)
│   ├── sellpage.dart                  # Main sell page
│   ├── my_listings_page.dart          # View my listings
│   ├── price_alert_setup.dart         # Price alert configuration
│   └── create_listing/
│       ├── sell_car_step1.dart        # Step 1: Basic info
│       ├── sell_car_step2.dart        # Step 2: Photos
│       ├── sell_car_step3.dart        # Step 3: Price & details
│       ├── preview_listing.dart       # Preview before publishing
│       └── listing_success_screen.dart # Success confirmation
│
├── 👤 Profile Module (4 screens)
│   ├── profilepage.dart               # Main profile page
│   ├── edit_profile_page.dart         # Edit profile info
│   ├── saved_cars_page.dart           # Saved/favorited cars
│   ├── purchase_history_page.dart     # Purchase history
│   └── dealer_profile_screen.dart     # Dealer profile view
│
├── 💬 Chat Module (4 screens)
│   ├── chatpage.dart                  # Main chat interface
│   ├── chat_settings.dart             # Chat settings
│   ├── chat_media_gallery.dart        # Media gallery
│   └── blocked_users_page.dart        # Blocked users management
│
├── 🔔 Notifications Module (3 screens)
│   ├── notifications_center.dart      # Notification center
│   ├── notification_details.dart      # Notification details
│   └── notification_settings.dart     # Notification preferences
│
├── ⚙️ Settings Module (6 screens)
│   ├── privacy_security_page.dart     # Privacy & security
│   ├── language_selection_page.dart   # Language options
│   ├── help_center_page.dart          # Help and support
│   ├── send_feedback_page.dart        # Feedback form
│   ├── about_autohub_page.dart        # About page
│   └── terms_conditions_page.dart     # Terms & conditions
│
└── ⭐ Reviews Module (1 screen)
    └── reviews_screen.dart            # Reviews and ratings
```

---

## 5. Screen Documentation

### 5.1 Authentication Screens

#### 5.1.1 Splash Screen (`splash.dart`)

**Purpose**: Initial loading screen with navigation logic

**Key Features**:

- Auto-navigation after 2 seconds
- Checks first launch status using `SharedPreferences`
- Routes to onboarding (first launch) or login/home (returning user)
- Displays app logo and branding

**Widgets Used**:

- `Container` with gradient background
- `Text` for logo
- `SharedPreferences` for state management
- `Future.delayed()` for timer

**Navigation Logic**:

```dart
1. Check isFirstLaunch → Navigate to Onboarding
2. Check isLoggedIn → Navigate to Home
3. Default → Navigate to Login
```

---

#### 5.1.2 Login Page (`Login.dart`)

**Purpose**: User authentication

**Key Features**:

- Email and password input fields
- Form validation
- "Forgot Password" link
- "Create Account" navigation
- Session persistence with `SharedPreferences`

**Widgets Used**:

- `TextField` with custom styling
- `ElevatedButton` for submission
- `Stack` for background image with gradient overlay
- `GestureDetector` for navigation links

**State Management**:

```dart
- Login status stored in SharedPreferences
- Navigation to HomeScreen on success
```

---

#### 5.1.3 Create Account (`createAccount.dart`)

**Purpose**: New user registration

**Key Features**:

- Email, phone, password, and confirm password fields
- Input validation
- Password obscuring
- Navigation to profile setup

**Widgets Used**:

- Multiple `TextField` widgets
- `ElevatedButton` for account creation
- Background image with gradient
- Custom border styling

---

#### 5.1.4 Forgot Password (`forgotPassword.dart`)

**Purpose**: Password recovery flow

**Key Features**:

- Email input for password reset
- Validation for email format
- Navigation to OTP verification

**Widgets Used**:

- `TextField` for email input
- `ElevatedButton` for submission
- `AlertDialog` for confirmation

---

#### 5.1.5 Verify OTP (`verifyOTP.dart`)

**Purpose**: OTP verification

**Key Features**:

- PIN code input fields (using `pin_code_fields` package)
- Auto-focus and auto-submit
- Resend OTP functionality
- Timer countdown

**Widgets Used**:

- `PinCodeTextField` from package
- `Timer` for countdown
- `ElevatedButton` for verification

---

#### 5.1.6 Change Password (`changepassword.dart`)

**Purpose**: Password change functionality

**Key Features**:

- Current password verification
- New password input
- Password strength indicator
- Confirmation field

**Widgets Used**:

- `TextField` with `obscureText`
- Form validation
- `ElevatedButton` for submission

---

#### 5.1.7 Profile Setup (`profilesetup.dart`)

**Purpose**: Initial profile configuration

**Key Features**:

- Name, location, and bio input
- Profile picture upload
- User type selection (Buyer/Seller/Dealer)

**Widgets Used**:

- `TextField` for text input
- `CircleAvatar` for profile picture
- `DropdownButton` for selections
- Image picker integration

---

### 5.2 Onboarding Screens

#### 5.2.1 Onboarding 1, 2, 3 (`onboarding1.dart`, `onboarding2.dart`, `onboarding3.dart`)

**Purpose**: Introduce app features to new users

**Key Features**:

- Full-screen image backgrounds
- Feature descriptions
- "Next" and "Skip" buttons
- Gradient overlays for text readability

**Widgets Used**:

- `Stack` for layered UI
- `Image.asset()` for backgrounds
- `Container` with `LinearGradient`
- `ElevatedButton` and `TextButton`

**Navigation**:

- Onboarding1 → Onboarding2 → Onboarding3 → Login
- Skip button available on all screens

---

### 5.3 Home & Browse Screens

#### 5.3.1 Navigation Bar (`navbar.dart`)

**Purpose**: Bottom navigation controller

**Key Features**:

- 5 main sections (Home, Search, Sell, Chat, Profile)
- Active state indicators
- Custom styling with orange accent color

**Widgets Used**:

- `BottomNavigationBar` with 5 items
- `Scaffold` body with page switching
- `Icon` widgets for navigation items

**Navigation Structure**:

```dart
Index 0: StartPage (Home)
Index 1: SearchPage
Index 2: SellPage
Index 3: ChatPage
Index 4: ProfilePage
```

---

#### 5.3.2 Home Screen (`homeScreen.dart`)

**Purpose**: Welcome dashboard after login

**Key Features**:

- Welcome message
- Quick action cards (Explore, Chat, Profile)
- "Sell Your Car" CTA button
- Grid layout design

**Widgets Used**:

- `GridView.count` for action cards
- `CircleAvatar` for icons
- `ElevatedButton` for CTA
- `Container` with shadows

---

#### 5.3.3 Start Page (`startpage.dart`)

**Purpose**: Main home page with car listings

**Key Features**:

- Search bar with filter icon
- Quick filter chips (New, Price Drop, Top Rated, Electric)
- Category grid (SUV, Sedan, Hatchback, Truck)
- Featured car cards with images
- Notification bell icon

**Widgets Used**:

- `TextField` for search
- `SingleChildScrollView` for horizontal filters
- `GridView.count` for categories
- Custom `carCard()` widget
- `Stack` for image overlays
- `GestureDetector` for navigation

**Helper Methods**:

```dart
- _buildFilterChip(): Creates filter chips
- _buildCategoryCard(): Category grid items
- carCard(): Featured car cards
```

---

#### 5.3.4 Search Page (`searchpage.dart`)

**Purpose**: Advanced car search interface

**Key Features**:

- Search input with submit functionality
- Category filter chips (All, SUV, Sedan, etc.)
- Price range slider
- Fuel type and transmission filters
- Search results preview list
- Navigation to advanced filters and car comparison

**Widgets Used**:

- `TextField` with `onSubmitted` callback
- `FilterChip` for categories
- `ListView.builder` for results
- `ElevatedButton` for search action
- Custom search result cards

**State Variables**:

```dart
- TextEditingController _searchController
- String selectedCategory = 'All'
- RangeValues priceRange
- String selectedFuel
- String selectedTransmission
```

---

#### 5.3.5 Search Result Page (`search_result_page.dart`)

**Purpose**: Display search results

**Key Features**:

- Results count display
- Sort and filter options
- Grid/List view toggle
- Car cards with quick actions

**Widgets Used**:

- `ListView` or `GridView` for results
- `DropdownButton` for sorting
- `IconButton` for view toggle

---

#### 5.3.6 Car Detail Page (`car_detail_page.dart`)

**Purpose**: Detailed view of individual car

**Key Features**:

- Image gallery/slider
- Car specifications
- Price and location
- Seller information
- Contact buttons (Call, Message)
- Save/Favorite button
- Share functionality

**Widgets Used**:

- `PageView` for image gallery
- `ListView` for specifications
- `ElevatedButton` for actions
- `IconButton` for favorite/share
- `Container` with custom styling

---

#### 5.3.7 Advanced Filter Screen (`advanced_filter_screen.dart`)

**Purpose**: Comprehensive filtering options

**Key Features**:

- Price range slider
- Year range selector
- Mileage filter
- Body type selection
- Fuel type options
- Transmission type
- Color picker
- Features checklist
- "Apply Filters" button

**Widgets Used**:

- `RangeSlider` for price/mileage
- `Checkbox` for features
- `Radio` buttons for single selections
- `DropdownButton` for options
- Form controls

---

#### 5.3.8 Category Browse (`category_browse.dart`)

**Purpose**: Browse cars by category

**Key Features**:

- Category selection tabs
- Filtered car listings
- Sort options
- Quick view cards

**Widgets Used**:

- `TabBar` for categories
- `ListView` for cars
- Filter chips

---

#### 5.3.9 Brand Browse (`brand_browse.dart`)

**Purpose**: Browse by car brand

**Key Features**:

- Brand logos grid
- Popular brands section
- Brand-specific listings

**Widgets Used**:

- `GridView` for brand logos
- `Image.asset()` for logos

---

#### 5.3.10 Recommended Cars (`recommended_cars.dart`)

**Purpose**: AI/algorithm recommended listings

**Key Features**:

- Personalized recommendations
- "Why recommended" tags
- Quick action buttons

---

#### 5.3.11 Recently Viewed (`recently_viewed.dart`)

**Purpose**: Show browsing history

**Key Features**:

- Chronological list
- Quick re-access
- Clear history option

---

#### 5.3.12 Compare Cars (`compare_cars.dart`)

**Purpose**: Car comparison tool

**Key Features**:

- Select multiple cars (2-4)
- Side-by-side comparison
- Spec comparison table

**Widgets Used**:

- `Checkbox` for selection
- `DataTable` for comparison
- Custom comparison cards

---

#### 5.3.13 Comparison Results (`comparison_results_screen.dart`)

**Purpose**: Display comparison data

**Key Features**:

- Detailed spec comparison
- Highlight differences
- Winner indicators
- Export/Share comparison

---

### 5.4 Sell Module Screens

#### 5.4.1 Sell Page (`sellpage.dart`)

**Purpose**: Main selling hub

**Key Features**:

- "How It Works" guide (4 steps)
- Benefits section
- "Start Listing" button
- "My Listings" quick access
- Database integration for saving listings

**Widgets Used**:

- Custom `_buildStepCard()` widgets
- `_buildBenefitItem()` rows
- `ElevatedButton` and `OutlinedButton`
- `DbHelper` for database operations
- Multi-step navigation flow

**Step Flow**:

```dart
1. SellCarStep1 (Basic Info)
2. SellCarStep2 (Photos)
3. SellCarStep3 (Price & Details)
4. PreviewListing
5. ListingSuccessScreen
```

**Database Operations**:

```dart
await DbHelper.getInstance.addCar(
  title, price, desc, year, mileage,
  category, fuel, transmission, condition, images
)
```

---

#### 5.4.2 Sell Car Step 1 (`sell_car_step1.dart`)

**Purpose**: Collect basic car information

**Key Features**:

- Form with validation (`GlobalKey<FormState>`)
- Text input fields (Title, Brand, Model, Year, Mileage)
- Dropdown selections (Category, Fuel, Transmission, Condition, Color)
- Data persistence across steps

**Widgets Used**:

- `Form` widget with `_formKey`
- `TextFormField` with validators
- `DropdownButtonFormField`
- `ElevatedButton` for "Next"

**Validation Logic**:

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter required field';
  }
  return null;
}
```

**Data Structure**:

```dart
Map<String, dynamic> {
  'title': String,
  'brand': String,
  'model': String,
  'year': int,
  'mileage': int,
  'category': String,
  'fuelType': String,
  'transmission': String,
  'condition': String,
  'color': String
}
```

---

#### 5.4.3 Sell Car Step 2 (`sell_car_step2.dart`)

**Purpose**: Upload car photos

**Key Features**:

- Multiple image selection
- Image preview grid
- Image deletion
- Camera/Gallery options
- Minimum photo requirement

**Widgets Used**:

- `GridView` for image preview
- `ImagePicker` for photo selection
- `Image.file()` for display
- `IconButton` for delete

---

#### 5.4.4 Sell Car Step 3 (`sell_car_step3.dart`)

**Purpose**: Price and additional details

**Key Features**:

- Price input with validation
- Description textarea
- Location selection
- Contact information
- Negotiability toggle
- Features checklist

**Widgets Used**:

- `TextFormField` with number input
- `TextField` with `maxLines` for description
- `Switch` for negotiability
- `Checkbox` for features
- Form validation

---

#### 5.4.5 Preview Listing (`preview_listing.dart`)

**Purpose**: Final review before publishing

**Key Features**:

- Complete listing preview
- Image carousel
- All details display
- Edit buttons for each section
- "Publish" confirmation

**Widgets Used**:

- `PageView` for images
- `ListView` for details
- `AlertDialog` for confirmation
- `ElevatedButton` for publish

---

#### 5.4.6 Listing Success Screen (`listing_success_screen.dart`)

**Purpose**: Confirmation after successful listing

**Key Features**:

- Success animation/icon
- Listing ID display
- Quick actions (View Listing, Share, Home)
- Next steps guidance

**Widgets Used**:

- `Icon` with success indicator
- `ElevatedButton` for actions
- Navigation buttons

---

#### 5.4.7 My Listings Page (`my_listings_page.dart`)

**Purpose**: Manage user's car listings

**Key Features**:

- Active listings display
- Edit/Delete actions
- Status indicators (Active, Sold, Expired)
- Performance stats
- Database retrieval

**Widgets Used**:

- `FutureBuilder` for async data loading
- `ListView.builder` for listings
- `ModalBottomSheet` for actions
- `AlertDialog` for delete confirmation
- `SnackBar` for feedback

**Database Operations**:

```dart
Future<void> _loadCars() async {
  final cars = await DbHelper.getInstance.getCars();
  setState(() { ... });
}
```

**Actions Available**:

- View details
- Edit listing
- Mark as sold
- Delete listing
- Share listing

---

#### 5.4.8 Price Alert Setup (`price_alert_setup.dart`)

**Purpose**: Set up price drop alerts

**Key Features**:

- Target price input
- Alert frequency selection
- Notification preferences
- Save alert confirmation

**Widgets Used**:

- `Slider` for target price
- `DropdownButton` for frequency
- `Switch` for notifications
- `SnackBar` for confirmation

---

### 5.5 Profile Module Screens

#### 5.5.1 Profile Page (`profilepage.dart`)

**Purpose**: User profile and settings hub

**Key Features**:

- Profile header (avatar, name, email, verified badge)
- Stats cards (Cars Listed, Cars Sold, Reviews)
- Menu sections (Account, Settings, Support)
- Settings quick access dialog
- Logout functionality

**Widgets Used**:

- `CircleAvatar` with editable profile picture
- `ListTile` for menu items
- `Switch` for toggle settings
- `AlertDialog` for logout confirmation
- Custom `_buildStatCard()` and `_buildMenuItem()` methods

**Menu Structure**:

```
Account:
- Edit Profile
- My Listings
- Saved Cars
- Purchase History
- Recently Viewed

Settings:
- Notifications
- Location Services
- Privacy & Security
- Language

Support:
- Help Center
- Send Feedback
- About AutoHub
- Terms & Conditions
```

**State Variables**:

```dart
bool isDarkMode = true
bool notificationsEnabled = true
bool locationEnabled = false
```

---

#### 5.5.2 Edit Profile Page (`edit_profile_page.dart`)

**Purpose**: Modify user information

**Key Features**:

- Form validation
- Profile picture update
- Name, email, phone, location, bio fields
- Save changes with validation

**Widgets Used**:

- `Form` with `GlobalKey<FormState>`
- `TextFormField` with validators
- `ElevatedButton` for save
- Image picker for avatar

**Validation Examples**:

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}
```

---

#### 5.5.3 Saved Cars Page (`saved_cars_page.dart`)

**Purpose**: View favorited cars

**Key Features**:

- Grid/List view toggle
- Remove from favorites
- Quick navigation to car details
- Empty state message

---

#### 5.5.4 Purchase History Page (`purchase_history_page.dart`)

**Purpose**: Transaction history

**Key Features**:

- Chronological purchase list
- Receipt download
- Reorder/Review options
- Filter by date range

---

#### 5.5.5 Dealer Profile Screen (`dealer_profile_screen.dart`)

**Purpose**: View dealer information

**Key Features**:

- Dealer stats and ratings
- Active listings
- Contact information
- Reviews section

---

### 5.6 Chat Module Screens

#### 5.6.1 Chat Page (`chatpage.dart`)

**Purpose**: Messaging interface

**Key Features**:

- Conversation list with unread badges
- Individual chat interface
- Online status indicators
- Message input with attachment support
- Search conversations
- Media gallery access
- Blocked users management

**Widgets Used**:

- `ListView.builder` for conversations
- `TextField` for message input
- `Container` with custom chat bubbles
- `Stack` for online status indicators
- `IconButton` for attachments and send
- `PopupMenuButton` for chat settings

**Data Structure**:

```dart
List<Map<String, dynamic>> conversations = [
  {
    'name': 'Ahmed Ali',
    'lastMessage': 'Is the BMW still available?',
    'time': '2:30 PM',
    'unread': 2,
    'avatar': 'A',
    'carTitle': 'BMW X5 2023',
    'isOnline': true,
  },
  ...
]
```

**UI Components**:

- `_buildConversationList()`: Shows all conversations
- `_buildConversationTile()`: Individual conversation item
- `_buildChatInterface()`: Full chat screen
- `_buildMessage()`: Individual message bubble

**State Management**:

```dart
String? selectedConversation  // Switches between list and chat view
```

---

#### 5.6.2 Chat Settings (`chat_settings.dart`)

**Purpose**: Conversation-specific settings

**Key Features**:

- Mute notifications
- Block user
- Clear chat history
- Report user
- Media auto-download settings

---

#### 5.6.3 Chat Media Gallery (`chat_media_gallery.dart`)

**Purpose**: View shared media

**Key Features**:

- Photo grid view
- Video thumbnails
- Document list
- Links shared
- Download options

---

#### 5.6.4 Blocked Users Page (`blocked_users_page.dart`)

**Purpose**: Manage blocked contacts

**Key Features**:

- Blocked users list
- Unblock option
- Block reason display

---

### 5.7 Notifications Module Screens

#### 5.7.1 Notifications Center (`notifications_center.dart`)

**Purpose**: View all notifications

**Key Features**:

- Categorized notifications (Messages, Listings, System)
- Unread badges
- Mark as read/unread
- Delete notifications
- Clear all option

**Widgets Used**:

- `ListView` for notifications
- `Dismissible` for swipe actions
- Badge indicators
- Custom notification cards

---

#### 5.7.2 Notification Details (`notification_details.dart`)

**Purpose**: Detailed notification view

**Key Features**:

- Full notification content
- Action buttons
- Related navigation
- Timestamp

---

#### 5.7.3 Notification Settings (`notification_settings.dart`)

**Purpose**: Configure notification preferences

**Key Features**:

- Toggle notification types
- Sound/Vibration settings
- Notification schedule
- Do Not Disturb mode

**Widgets Used**:

- `Switch` widgets
- `TimeOfDay` picker
- `ListTile` for options

---

### 5.8 Settings Module Screens

#### 5.8.1 Privacy & Security Page (`privacy_security_page.dart`)

**Purpose**: Security and privacy controls

**Key Features**:

- Change password
- Two-factor authentication
- Login activity
- Blocked accounts
- Data privacy settings
- Account deletion
- Multiple `AlertDialog` confirmations
- Extensive `SnackBar` feedback

**Widgets Used**:

- `ListTile` for menu items
- `Switch` for toggles
- `AlertDialog` for confirmations (8+ instances)
- `SnackBar` for feedback (10+ instances)
- `ElevatedButton` for actions

**Security Options**:

```dart
- Change Password
- Enable 2FA
- View Login Activity
- Manage Blocked Accounts
- Privacy Settings
- Account Visibility
- Data Download
- Delete Account
```

---

#### 5.8.2 Language Selection Page (`language_selection_page.dart`)

**Purpose**: App language settings

**Key Features**:

- Language list with flags
- Current language indicator
- Apply changes confirmation
- Localization support

**Widgets Used**:

- `ListView` for languages
- `Radio` buttons for selection
- `AlertDialog` for confirmation
- `SnackBar` for success message

**Supported Languages** (Example):

- English
- Urdu
- Arabic
- Spanish
- French

---

#### 5.8.3 Help Center Page (`help_center_page.dart`)

**Purpose**: Help and support resources

**Key Features**:

- FAQ accordion
- Search help topics
- Contact support
- Video tutorials
- Live chat option

**Widgets Used**:

- `ExpansionTile` for FAQs
- `TextField` for search
- `ListView` for topics

---

#### 5.8.4 Send Feedback Page (`send_feedback_page.dart`)

**Purpose**: User feedback submission

**Key Features**:

- Feedback type selection
- Text input area
- Rating system
- Screenshot attachment
- Submit with confirmation dialog

**Widgets Used**:

- `TextField` with `maxLines`
- `DropdownButton` for category
- `RatingBar` or star icons
- `AlertDialog` for submission confirmation

---

#### 5.8.5 About AutoHub Page (`about_autohub_page.dart`)

**Purpose**: App information

**Key Features**:

- App version display
- Company information
- Credits
- Social media links
- Open source licenses

---

#### 5.8.6 Terms & Conditions Page (`terms_conditions_page.dart`)

**Purpose**: Legal documentation

**Key Features**:

- Scrollable terms text
- Accept/Decline buttons
- Last updated date
- Section navigation

---

### 5.9 Reviews Module

#### 5.9.1 Reviews Screen (`reviews_screen.dart`)

**Purpose**: View and submit reviews

**Key Features**:

- Review list for cars/sellers
- Star rating input
- Review text area
- Photo attachments
- Sort by rating/date
- Helpful/Report buttons

**Widgets Used**:

- `ListView` for reviews
- Rating input widgets
- `TextField` for review text
- Image picker for photos

---

## 6. Widget Catalog

### 6.1 Common Custom Widgets

#### 6.1.1 Car Card Widget

**Usage**: Featured car display cards

**Properties**:

```dart
- String image: Car image path
- String title: Car name
- String price: Car price
- String location: Car location
- bool favorite: Favorite status
- String specs: Car specifications
```

**Features**:

- Image with gradient overlay
- Favorite button
- "FEATURED" badge
- Specs icons
- Price display
- Location indicator
- Navigation arrow

---

#### 6.1.2 Filter Chip Widget

**Usage**: Quick filter selection

**Properties**:

```dart
- IconData icon
- String label
- bool selected
```

**Styling**:

- Gradient background when selected
- Border color changes
- Icon color changes

---

#### 6.1.3 Category Card Widget

**Usage**: Browse categories

**Properties**:

```dart
- IconData icon
- String title
- VoidCallback onTap
```

**Styling**:

- Circular icon background
- Card shadow
- Border with accent color

---

#### 6.1.4 Conversation Tile Widget

**Usage**: Chat conversation item

**Properties**:

```dart
- String name
- String lastMessage
- String time
- int unread
- String avatar
- bool isOnline
- String carTitle
```

**Features**:

- Avatar with online indicator
- Unread badge
- Car title reference
- Timestamp

---

#### 6.1.5 Message Bubble Widget

**Usage**: Chat message display

**Properties**:

```dart
- String message
- bool isMe
- String time
```

**Styling**:

- Different colors for sent/received
- Rounded corners
- Timestamp

---

### 6.2 Common Flutter Widgets Used

| Widget                        | Usage Count | Purpose            |
| ----------------------------- | ----------- | ------------------ |
| `Scaffold`                    | 50+         | Screen structure   |
| `AppBar`                      | 50+         | Top navigation bar |
| `Container`                   | 500+        | Layout and styling |
| `Text`                        | 1000+       | Display text       |
| `ElevatedButton`              | 200+        | Primary actions    |
| `TextField` / `TextFormField` | 150+        | User input         |
| `ListView`                    | 100+        | Scrollable lists   |
| `Column` / `Row`              | 800+        | Layout             |
| `Icon`                        | 300+        | Icons              |
| `IconButton`                  | 200+        | Icon actions       |
| `Stack`                       | 50+         | Overlays           |
| `Image.asset()`               | 100+        | Display images     |
| `CircleAvatar`                | 50+         | Profile pictures   |
| `AlertDialog`                 | 50+         | Confirmations      |
| `SnackBar`                    | 30+         | Toast messages     |
| `GridView`                    | 20+         | Grid layouts       |
| `Form`                        | 10+         | Form validation    |
| `Navigator`                   | 200+        | Navigation         |
| `SingleChildScrollView`       | 100+        | Scrolling          |
| `Expanded` / `Flexible`       | 300+        | Responsive layout  |

---

### 6.3 Material Design Components

- **Bottom Navigation Bar**: Main app navigation
- **Filter Chips**: Quick selections
- **Cards**: Content containers
- **Dialogs**: Alerts and confirmations
- **Snackbars**: Feedback messages
- **Progress Indicators**: Loading states
- **Switches**: Toggle settings
- **Radio Buttons**: Single selections
- **Checkboxes**: Multiple selections
- **Sliders**: Range inputs
- **Dropdown Menus**: Select options
- **Text Fields**: User input
- **Buttons**: Actions (Elevated, Outlined, Text)

---

## 7. Database Schema

### 7.1 SQLite Database Structure

**Database Name**: `sellDB.db`

**Table**: `cars`

| Column         | Type    | Constraints               | Description                           |
| -------------- | ------- | ------------------------- | ------------------------------------- |
| `id`           | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique car ID                         |
| `title`        | TEXT    | -                         | Car listing title                     |
| `price`        | INTEGER | -                         | Car price (in rupees)                 |
| `desc`         | TEXT    | -                         | Car description                       |
| `year`         | INTEGER | -                         | Manufacturing year                    |
| `mileage`      | INTEGER | -                         | Mileage (in km)                       |
| `category`     | TEXT    | -                         | Car category (SUV, Sedan, etc.)       |
| `fuel`         | TEXT    | -                         | Fuel type (Petrol, Diesel, etc.)      |
| `transmission` | TEXT    | -                         | Transmission type (Manual, Automatic) |
| `condition`    | TEXT    | -                         | Car condition (New, Used)             |
| `images`       | TEXT    | -                         | JSON array of image paths             |

### 7.2 Database Helper Class (`db_helper.dart`)

**Pattern**: Singleton

**Key Methods**:

```dart
// Get database instance
Future<Database> getDB()

// Open/Create database
Future<Database> openDB()

// Insert car
Future<bool> addCar({
  required String title,
  required int price,
  required String desc,
  required int year,
  required int mileage,
  required String category,
  required String fuel,
  required String transmission,
  required String condition,
  List<String>? images,
})

// Retrieve all cars
Future<List<Map<String, dynamic>>> getCars()
```

**Usage Example**:

```dart
// Add a car
final success = await DbHelper.getInstance.addCar(
  title: 'BMW X5 2023',
  price: 12500000,
  desc: 'Excellent condition',
  year: 2023,
  mileage: 15000,
  category: 'SUV',
  fuel: 'Petrol',
  transmission: 'Automatic',
  condition: 'Used - Excellent',
  images: ['path1.jpg', 'path2.jpg'],
);

// Get all cars
final cars = await DbHelper.getInstance.getCars();
```

---

## 8. Navigation Flow

### 8.1 App Navigation Graph

```
┌─────────────┐
│   Splash    │
└──────┬──────┘
       │
       ├─── First Launch? ──→ Onboarding1 ──→ Onboarding2 ──→ Onboarding3 ──→ Login
       │
       ├─── Logged In? ─────→ Navbar (Home)
       │
       └─── Not Logged In ──→ Login
                               │
                               ├─→ Forgot Password ──→ OTP ──→ Change Password
                               │
                               └─→ Create Account ──→ Profile Setup ──→ Login
```

### 8.2 Main Navigation Structure

```
Navbar (Bottom Navigation)
│
├─ [0] Home (StartPage)
│   ├─→ Search Page
│   ├─→ Car Detail
│   ├─→ Category Browse
│   ├─→ Brand Browse
│   ├─→ Advanced Filters
│   ├─→ Compare Cars
│   └─→ Notifications
│
├─ [1] Search (SearchPage)
│   ├─→ Search Results
│   ├─→ Car Detail
│   ├─→ Advanced Filters
│   └─→ Compare Cars
│
├─ [2] Sell (SellPage)
│   ├─→ Create Listing
│   │   ├─→ Step 1 (Basic Info)
│   │   ├─→ Step 2 (Photos)
│   │   ├─→ Step 3 (Price & Details)
│   │   ├─→ Preview
│   │   └─→ Success Screen
│   ├─→ My Listings
│   └─→ Price Alert Setup
│
├─ [3] Chat (ChatPage)
│   ├─→ Chat Interface
│   ├─→ Chat Settings
│   ├─→ Media Gallery
│   └─→ Blocked Users
│
└─ [4] Profile (ProfilePage)
    ├─→ Edit Profile
    ├─→ Saved Cars
    ├─→ Purchase History
    ├─→ My Listings
    ├─→ Recently Viewed
    ├─→ Notifications
    ├─→ Privacy & Security
    ├─→ Language Selection
    ├─→ Help Center
    ├─→ Send Feedback
    ├─→ About AutoHub
    └─→ Terms & Conditions
```

### 8.3 Navigation Methods Used

```dart
// Push new screen
Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));

// Push and replace
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewScreen()));

// Pop current screen
Navigator.pop(context);

// Pop with data
Navigator.pop(context, data);

// Push with await for result
final result = await Navigator.push<bool>(context, MaterialPageRoute(...));
```

---

## 9. State Management

### 9.1 State Management Approach

**Primary Method**: **StatefulWidget** with `setState()`

**Why StatefulWidget?**:

- Simple and straightforward
- Suitable for app size and complexity
- No external dependencies needed
- Easy to understand and maintain

### 9.2 State Examples

#### Local State (Widget-level)

```dart
class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(0, 10000000);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
```

#### Persistent State (App-level)

```dart
// Using SharedPreferences
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setBool('Login', true);
bool isLoggedIn = prefs.getBool('Login') ?? false;
```

#### Database State

```dart
// Using FutureBuilder
FutureBuilder<List<Map<String, dynamic>>>(
  future: DbHelper.getInstance.getCars(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // Display data
    }
    return CircularProgressIndicator();
  },
)
```

### 9.3 Form State Management

```dart
class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save data
    }
  }
}
```

---

## 10. Assets & Resources

### 10.1 Image Assets

**Location**: `assets/images/`

| File                               | Purpose             | Screens Used                |
| ---------------------------------- | ------------------- | --------------------------- |
| `autohub.png`                      | App icon            | Splash                      |
| `AUTOHUB1.png`                     | Logo variant        | Various                     |
| `Cover.png`                        | Background image    | Login, Register, Onboarding |
| `logo.png`                         | Logo                | AppBar                      |
| `Profile.jpg`                      | Default profile     | Profile                     |
| `onboarding1.jpg`                  | Onboarding screen 1 | Onboarding1                 |
| `onboarding2.jpg`                  | Onboarding screen 2 | Onboarding2                 |
| `onboarding3.jpg`                  | Onboarding screen 3 | Onboarding3                 |
| `car1.jpg`, `car2.jpg`, `car3.jpg` | Featured cars       | Home, Search                |
| `bmw.jpg`                          | BMW sample          | Search results              |
| `merc.jpg`                         | Mercedes sample     | Search results              |
| `ford.jpg`                         | Ford sample         | Search results              |
| `Car.png`                          | Placeholder         | Various                     |
| `Selection.png`                    | UI element          | Select screens              |
| `meter.png`                        | Speedometer icon    | Car details                 |
| `steering-wheel.png`               | Steering icon       | Categories                  |

### 10.2 Font Assets

**Location**: `assets/fonts/`

| Font Family            | Files                                                       | Weight        | Usage            |
| ---------------------- | ----------------------------------------------------------- | ------------- | ---------------- |
| **Archivo**            | `Archivo-SemiBold.ttf`, `Archivo-SemiBoldItalic.ttf`        | 700           | Headers, titles  |
| **Archivo_Condensed**  | `Archivo_Condensed-ExtraBold.ttf`                           | Extra Bold    | Section headers  |
| **Archivo_ECondensed** | `Archivo_ExtraCondensed-Black.ttf`                          | Black         | Emphasized text  |
| **Roboto**             | `roboto_regular.ttf`, `roboto_bold.ttf`, `roboto_light.ttf` | 400, 700, 300 | Body text        |
| **Hegarty**            | `hegarty_regular.ttf`                                       | Regular       | Logo, brand text |

### 10.3 Asset Configuration (`pubspec.yaml`)

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/

  fonts:
    - family: Archivo
      fonts:
        - asset: assets/fonts/Archivo-SemiBoldItalic.ttf
          weight: 700

    - family: Archivo_Condensed
      fonts:
        - asset: assets/fonts/Archivo-SemiBold.ttf

    - family: Archivo_ECondensed
      fonts:
        - asset: assets/fonts/Archivo_ExtraCondensed-Black.ttf

    - family: Roboto
      fonts:
        - asset: assets/fonts/roboto_regular.ttf

    - family: Hegarty
      fonts:
        - asset: assets/fonts/hegarty_regular.ttf
```

---

## 11. Dependencies

### 11.1 Package Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8 # iOS-style icons
  pin_code_fields: ^8.0.1 # OTP input fields
  curved_navigation_bar: ^1.0.3 # Curved bottom navigation
  shared_preferences: ^2.2.2 # Key-value storage
  sqflite: ^2.4.2 # SQLite database
  path_provider: ^2.1.5 # File system paths
  path: ^1.9.1 # Path manipulation

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0 # Linting rules
```

### 11.2 Package Usage Details

#### 11.2.1 shared_preferences (^2.2.2)

**Purpose**: Simple persistent storage

**Usage**:

```dart
// Save data
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setBool('Login', true);
await prefs.setString('username', 'John');

// Retrieve data
bool isLoggedIn = prefs.getBool('Login') ?? false;
String? username = prefs.getString('username');
```

**Used In**:

- Login status
- First launch detection
- User preferences
- Settings

---

#### 11.2.2 sqflite (^2.4.2)

**Purpose**: Local SQL database

**Usage**:

```dart
// See Database Helper section
```

**Used In**:

- Car listings storage
- User data caching
- Offline functionality

---

#### 11.2.3 path_provider (^2.1.5)

**Purpose**: Access to file system directories

**Usage**:

```dart
Directory appDir = await getApplicationDocumentsDirectory();
String dbPath = join(appDir.path, 'sellDB.db');
```

**Used In**:

- Database file location
- Image storage paths

---

#### 11.2.4 pin_code_fields (^8.0.1)

**Purpose**: OTP input UI

**Usage**:

```dart
PinCodeTextField(
  length: 6,
  onCompleted: (code) {
    // Verify OTP
  },
)
```

**Used In**:

- OTP verification screen

---

#### 11.2.5 curved_navigation_bar (^1.0.3)

**Purpose**: Alternative bottom navigation style

**Usage**:

```dart
CurvedNavigationBar(
  items: [...],
  onTap: (index) { ... },
)
```

**Status**: Optional (not currently implemented in navbar.dart)

---

## 12. Code Conventions

### 12.1 Naming Conventions

#### Files and Directories

- **Screens**: `lowercase_with_underscores.dart` (e.g., `search_page.dart`)
- **Classes**: `PascalCase` (e.g., `SearchPage`, `DbHelper`)
- **Variables**: `camelCase` (e.g., `selectedCategory`, `priceRange`)
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` (e.g., `TABLE_CAR`)
- **Private members**: Prefix with `_` (e.g., `_searchController`, `_buildCard()`)

#### Widget Naming

- **Stateful Widget**: `WidgetName` (e.g., `SearchPage`)
- **State Class**: `_WidgetNameState` (e.g., `_SearchPageState`)
- **Helper Methods**: `_buildComponentName()` (e.g., `_buildCarCard()`)

### 12.2 Project Organization

```
lib/
├── main.dart                      # App entry point
├── screens/                       # All UI screens
│   ├── auth/                     # Feature grouping
│   ├── home/
│   │   ├── browse/               # Sub-feature grouping
│   │   └── filter/
│   └── ...
└── helper/                        # Business logic
    └── db_helper.dart
```

### 12.3 Code Style

#### Import Order

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:shared_preferences/shared_preferences.dart';

// 4. Relative imports
import '../../helper/db_helper.dart';
```

#### Widget Structure

```dart
class ScreenName extends StatefulWidget {
  const ScreenName({super.key});

  @override
  State<ScreenName> createState() => _ScreenNameState();
}

class _ScreenNameState extends State<ScreenName> {
  // 1. State variables
  // 2. Controllers
  // 3. Lifecycle methods
  // 4. Build method
  // 5. Helper methods
  // 6. Dispose
}
```

### 12.4 Color Constants

```dart
// Primary Colors
const Color primaryOrange = Color(0xFFFFB347);
const Color backgroundDark = Color(0xFF1A1A1A);
const Color cardDark = Color(0xFF2C2C2C);
const Color textWhite = Colors.white;

// Usage
backgroundColor: const Color(0xFF1A1A1A)
```

### 12.5 Responsive Design

```dart
// Use MediaQuery for responsive sizes
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

// Percentage-based sizing
width: screenWidth * 0.9
height: screenHeight * 0.3
```

### 12.6 Error Handling

```dart
// Try-catch blocks for async operations
try {
  final result = await DbHelper.getInstance.getCars();
} catch (e) {
  print('Error: $e');
  _showErrorDialog('An error occurred');
}

// FutureBuilder error handling
FutureBuilder(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    return DisplayWidget(data: snapshot.data);
  },
)
```

### 12.7 Form Validation

```dart
// Use GlobalKey for forms
final _formKey = GlobalKey<FormState>();

// Validation in TextFormField
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  },
)

// Check validation
if (_formKey.currentState!.validate()) {
  // Proceed with valid data
}
```

### 12.8 Navigation Patterns

```dart
// Simple navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Navigation with data passing
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      carName: 'BMW X5',
      price: 'Rs 12,500,000',
    ),
  ),
);

// Navigation with result
final result = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(builder: (context) => InputScreen()),
);
if (result != null) {
  // Handle returned data
}

// Replace navigation
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
);
```

### 12.9 Async/Await Best Practices

```dart
// Always await async operations
Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  final data = await DbHelper.getInstance.getCars();
  setState(() {
    // Update UI
  });
}

// Use try-finally for cleanup
Future<void> saveData() async {
  showLoadingDialog();
  try {
    await DbHelper.getInstance.addCar(...);
  } finally {
    hideLoadingDialog();
  }
}
```

### 12.10 Widget Lifecycle

```dart
@override
void initState() {
  super.initState();
  // Initialize data, listeners
  _loadInitialData();
}

@override
void dispose() {
  // Clean up controllers, listeners
  _searchController.dispose();
  super.dispose();
}
```

---

## 13. Future Enhancements

### Potential Features to Add:

1. ✨ **Side Navigation Drawer**
2. 🌐 **API Integration** (RESTful backend)
3. 📊 **Analytics Dashboard**
4. 🔔 **Push Notifications** (Firebase Cloud Messaging)
5. 🎥 **Video Uploads** for car listings
6. 🗺️ **Google Maps Integration**
7. 💳 **Payment Gateway** Integration
8. ⭐ **Advanced Review System**
9. 🤖 **AI-based Car Recommendations**
10. 🔒 **Biometric Authentication**
11. 🌍 **Multi-language Support** (i18n)
12. 📤 **Social Media Sharing**
13. 📈 **Price Prediction ML Model**
14. 🚗 **Virtual Car Tours** (360° view)
15. 📞 **In-app Calling**

---

## 14. Testing Guidelines

### 14.1 Manual Testing Checklist

#### Authentication Flow

- [ ] Splash screen displays correctly
- [ ] First launch navigates to onboarding
- [ ] Onboarding screens flow properly
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Password recovery flow
- [ ] OTP verification
- [ ] Account creation
- [ ] Session persistence

#### Navigation

- [ ] Bottom navigation switches correctly
- [ ] Back button functionality
- [ ] Deep navigation and back stack
- [ ] Data passing between screens

#### Forms

- [ ] All validation rules work
- [ ] Error messages display correctly
- [ ] Form submission with valid data
- [ ] Form submission with invalid data

#### Database

- [ ] Car listings save correctly
- [ ] Car listings retrieve correctly
- [ ] Images stored properly

#### UI/UX

- [ ] All images load
- [ ] No overflow errors
- [ ] Responsive on different screen sizes
- [ ] Dark theme consistency
- [ ] Touch targets adequate

---

## 15. Deployment

### 15.1 Android Deployment

**Build APK**:

```bash
flutter build apk --release
```

**Build App Bundle**:

```bash
flutter build appbundle --release
```

### 15.2 iOS Deployment

**Build iOS**:

```bash
flutter build ios --release
```

### 15.3 Pre-deployment Checklist

- [ ] Remove debug banners
- [ ] Update version number in `pubspec.yaml`
- [ ] Test on real devices
- [ ] Check permissions in AndroidManifest.xml
- [ ] Configure app icons
- [ ] Set up splash screen
- [ ] Review privacy policies
- [ ] Test all payment flows
- [ ] Verify all API endpoints

---

## 16. Maintenance & Support

### 16.1 Known Issues

- No side drawer implemented (only bottom navigation)
- Community module empty (no screens)
- Dummy data used (needs backend integration)

### 16.2 Performance Considerations

- Image optimization needed for faster loading
- Database queries could be optimized with indexes
- Consider pagination for large lists
- Implement caching for frequently accessed data

### 16.3 Security Considerations

- Passwords stored in plain text (implement hashing)
- No token-based authentication (implement JWT)
- API calls not secured (implement SSL pinning)
- Input sanitization needed for database operations

---

## 17. Contact & Credits

**Developer**: [Your Name]  
**Project**: AutoHub - Car Marketplace  
**Framework**: Flutter 3.9.0  
**Date**: November 11, 2025

**Design Inspiration**:

- Material Design 3
- Modern car marketplace UIs
- iOS and Android design patterns

**Assets Credits**:

- Custom fonts: Archivo, Hegarty, Roboto
- Images: Placeholder and sample images

---

## Appendix A: Quick Reference

### Common Commands

```bash
# Run app
flutter run

# Build APK
flutter build apk

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Database Queries

```dart
// Add car
await DbHelper.getInstance.addCar(...)

// Get all cars
await DbHelper.getInstance.getCars()
```

### SharedPreferences

```dart
// Save
await prefs.setBool('key', value)
await prefs.setString('key', value)

// Retrieve
prefs.getBool('key') ?? defaultValue
prefs.getString('key')
```

---

## Appendix B: Screen Metrics

**Total Screens**: 50  
**Authentication**: 7  
**Onboarding**: 3  
**Home/Browse**: 13  
**Sell**: 8  
**Profile**: 4  
**Chat**: 4  
**Notifications**: 3  
**Settings**: 6  
**Reviews**: 1  
**Community**: 0

**Total Lines of Code**: ~15,000+ (estimated)  
**Widgets Used**: 50+ unique types  
**Forms**: 10+ with validation  
**Navigation Screens**: 50  
**Database Tables**: 1

---

## Document Version History

| Version | Date         | Changes               |
| ------- | ------------ | --------------------- |
| 1.0.0   | Nov 11, 2025 | Initial documentation |

---

**End of Documentation**

_This documentation is maintained as part of the AutoHub project. For updates and contributions, please refer to the repository._
