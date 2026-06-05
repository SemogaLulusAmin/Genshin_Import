# Genshin Import Project Documentation

## 1. Project Overview

**Genshin Import** is a Flutter-based mobile hybrid application created for the GachaMerch project case. The application is designed as a Teyvat-themed shop and inventory system where users can browse, buy, and manage Genshin-inspired weapons and artifacts.

The application follows the required project theme: **Genshin Import**, which provides numerous Teyvat weapons and artifacts that users can purchase. The system supports two main roles:

1. **User**
   - Can register and log in.
   - Can log in using Google OAuth.
   - Can view available weapons and artifacts.
   - Can buy weapons and artifacts.
   - Can view purchased items in the inventory.
   - Can edit their profile username.
   - Can switch between light and dark themes.

2. **Admin**
   - Can log in using a database account.
   - Can view weapons and artifacts.
   - Can create new weapons and artifacts.
   - Can update existing weapons and artifacts.
   - Can delete weapons and artifacts.
   - Can manage item data through admin-only pages.

The project is built using:

- **Flutter** for the frontend application.
- **Node.js and Express.js** for the backend API.
- **MySQL** for the database.
- **JWT Bearer Token** for authentication and protected requests.
- **Google Sign-In** for external OAuth authentication.

---

## 2. Application Theme

The application theme is based on a fantasy shop and inventory concept inspired by Genshin-style weapons, artifacts, Mora currency, rarity stars, and item detail sheets.

The main idea of the application is to let users experience a simple marketplace where they can:

- Explore weapons and artifacts.
- Check item details such as rarity, type, passive effect, stock, and price.
- Purchase items using Mora.
- View purchased items in their inventory.
- Manage account settings and theme preferences.

The project also extends the minimum case requirement. The case only requires weapons, but this project also includes **artifacts** as an additional feature. This makes the application more complete and closer to the Genshin-inspired theme.

---

## 3. Technology Stack

### 3.1 Frontend

The frontend is built with **Flutter**. It uses Dart and several dependencies to support UI, API communication, local storage, image picking, SVG icons, and Google authentication.

Main frontend technologies:

- Flutter
- Dart
- Material Design
- `http` for API requests
- `shared_preferences` for storing JWT token and user preferences
- `google_sign_in` for Google OAuth login
- `image_picker` for uploading weapon and artifact images
- `flutter_svg` for SVG navigation icons

### 3.2 Backend

The backend is built with **Node.js** and **Express.js**. It provides REST API endpoints for authentication, users, weapons, artifacts, transactions, and inventory data.

Main backend technologies:

- Node.js
- Express.js
- MySQL2
- JSON Web Token
- Bcrypt
- Multer
- Axios
- CORS
- Dotenv

### 3.3 Database

The database uses **MySQL**. It stores user accounts, weapons, artifacts, and purchase transactions.

The database is managed through backend migration and seed files.

---

## 4. Software Requirements

Based on the project case document, the recommended software environment is:

| Software | Version |
|---|---|
| Android SDK | API 35 |
| Android Studio | Meerkat Feature Drop 2024.3.2 Patch 1 |
| Flutter SDK | 3.32.2 |
| Node.js | 22.16.0 |
| XAMPP | 8.2.12 |

---

## 5. Project Structure

The project is divided into two main folders:

```text
Genshin_Import/
├── backend/
└── frontend/
```

### 5.1 Backend Folder

The backend contains the Express server, API routes, middleware, database connection, migration, and seed data.

Important backend folders and files:

```text
backend/
├── src/
│   ├── server.js
│   ├── db.js
│   ├── middleware/
│   │   └── authMiddleware.js
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── weaponRoutes.js
│   │   ├── ArtifactRoutes.js
│   │   ├── userWeaponRoutes.js
│   │   ├── userArtifactRoutes.js
│   │   └── userRoutes.js
│   └── migrates/
│       ├── migrate.js
│       └── seed.js
└── package.json
```

### 5.2 Frontend Folder

The frontend contains screens, widgets, services, models, view models, themes, icons, fonts, and image assets.

Important frontend folders and files:

```text
frontend/
├── lib/
│   ├── core/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── view_models/
│   └── widgets/
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
└── pubspec.yaml
```

---

## 6. Database Design

The application uses MySQL as the database. The database supports users, weapons, artifacts, and purchase transactions.

### 6.1 User Table

The `User` table stores account information.

| Field | Description |
|---|---|
| `userID` | Unique user identifier |
| `username` | User display name |
| `email` | User email address |
| `password` | Hashed password for local login |
| `provider` | Login provider, either `local` or `google` |
| `money` | User Mora balance |
| `roles` | User role, either `user` or `admin` |
| `createdAt` | Account creation timestamp |
| `updatedAt` | Last update timestamp |

This table supports both local authentication and Google authentication.

### 6.2 Weapon Table

The `Weapon` table stores weapon data.

| Field | Description |
|---|---|
| `weaponID` | Unique weapon identifier |
| `name` | Weapon name |
| `type` | Weapon type |
| `rarity` | Weapon rarity |
| `baseAttack` | Weapon base attack value |
| `subStat` | Weapon sub stat |
| `passiveName` | Weapon passive skill name |
| `passiveDesc` | Weapon passive skill description |
| `image_url` | Weapon image URL or uploaded image path |
| `price` | Weapon price in Mora |
| `stock` | Available weapon stock |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

This table satisfies the requirement that an item must have an ID, name, type, description, stock, image, and price. In this project, weapon description is represented by passive information such as passive name and passive description.

### 6.3 WeaponTransaction Table

The `WeaponTransaction` table stores weapon purchase history.

| Field | Description |
|---|---|
| `userID` | User who purchased the weapon |
| `weaponID` | Purchased weapon |
| `stock` | Quantity purchased |
| `createdAt` | Purchase timestamp |
| `updatedAt` | Last update timestamp |

This table is used to build the user's weapon inventory.

### 6.4 Artifact Table

The `Artifact` table stores artifact data.

| Field | Description |
|---|---|
| `artifactID` | Unique artifact identifier |
| `name` | Artifact name |
| `set_name` | Artifact set name |
| `max_rarity` | Maximum artifact rarity |
| `stock` | Available artifact stock |
| `image_url` | Artifact image URL or uploaded image path |
| `price` | Artifact price in Mora |
| `piece_bonus_2` | Two-piece set bonus |
| `piece_bonus_4` | Four-piece set bonus |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

Artifacts are an additional feature added to make the application richer and more aligned with the Genshin theme.

### 6.5 ArtifactTransaction Table

The `ArtifactTransaction` table stores artifact purchase history.

| Field | Description |
|---|---|
| `userID` | User who purchased the artifact |
| `artifactID` | Purchased artifact |
| `stock` | Quantity purchased |
| `createdAt` | Purchase timestamp |
| `updatedAt` | Last update timestamp |

This table is used to build the user's artifact inventory.

---

## 7. Database CRUD Requirement

The project satisfies the required database CRUD operations.

### 7.1 Create

Create operations are available in several features:

- User registration creates a new user account.
- Google login can create a new Google-based user account if the email is not registered yet.
- Admin can create a new weapon.
- Admin can create a new artifact.
- User purchase creates a weapon or artifact transaction.

Examples:

- `POST /auth/register`
- `POST /auth/register/google`
- `POST /weapon`
- `POST /artifact`
- `POST /userWeapon/buy/:weaponID`
- `POST /userArtifact/buy/:artifactID`

### 7.2 Retrieve

Retrieve operations are used to display data in the application.

Examples:

- Get all weapons.
- Get weapon detail by ID.
- Get all artifacts.
- Get artifact detail by ID.
- Get purchased weapons.
- Get purchased artifacts.
- Get user profile data.

Examples:

- `GET /weapon`
- `GET /weapon/:weaponID`
- `GET /artifact`
- `GET /artifact/:artifactID`
- `GET /userWeapon?status=purchased`
- `GET /userArtifact?status=purchased`
- `GET /auth/:userID`

### 7.3 Update

Update operations are used by admin and users.

Examples:

- Admin can update weapon data.
- Admin can update artifact data.
- User can edit their username.
- Purchase transaction updates user money and item stock.

Examples:

- `PUT /weapon/:weaponID`
- `PUT /artifact/:artifactID`
- `PATCH /users/edit-profile`

### 7.4 Delete

Delete operations are available for admin item management.

Examples:

- Admin can delete a weapon.
- Admin can delete an artifact.
- Related transactions are also deleted before the item is removed.

Examples:

- `DELETE /weapon/:weaponID`
- `DELETE /artifact/:artifactID`

---

## 8. Backend API Documentation

The backend uses Express.js and provides several route groups.

### 8.1 Authentication Routes

Base route:

```text
/auth
```

#### Register

```text
POST /auth/register
```

This endpoint registers a new user with a local account. The password is hashed using bcrypt before being stored in the database.

Request body example:

```json
{
  "username": "Player",
  "email": "player@example.com",
  "password": "password123"
}
```

#### Local Login

```text
POST /auth/login
```

This endpoint checks the user's email and password. If the credentials are valid, the backend generates a JWT bearer token.

Request body example:

```json
{
  "email": "player@example.com",
  "password": "password123"
}
```

Response example:

```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "username": "Player",
    "money": 10000,
    "roles": "user"
  }
}
```

#### Google Login

```text
POST /auth/register/google
```

This endpoint handles external OAuth login using Google. The frontend sends a Google access token to the backend. The backend verifies the Google user information and creates a new account if the email does not exist yet.

Request body example:

```json
{
  "accessToken": "google_access_token"
}
```

Response example:

```json
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "username": "Google User",
    "email": "googleuser@example.com"
  }
}
```

#### Get User Data

```text
GET /auth/:userID
```

This endpoint retrieves user profile data such as username, email, money, and role.

---

### 8.2 Weapon Routes

Base route:

```text
/weapon
```

#### Get All Weapons

```text
GET /weapon
```

This endpoint retrieves weapon data from the database. It supports optional query filters:

```text
GET /weapon?status=available
GET /weapon?status=not-available
```

#### Get Weapon by ID

```text
GET /weapon/:weaponID
```

This endpoint retrieves a specific weapon by ID.

#### Create Weapon

```text
POST /weapon
```

This endpoint allows an admin to create a new weapon. It requires authentication, admin role verification, and an uploaded image.

Weapon fields include:

- Name
- Type
- Rarity
- Base attack
- Sub stat
- Passive name
- Passive description
- Price
- Stock
- Image

#### Update Weapon

```text
PUT /weapon/:weaponID
```

This endpoint allows an admin to update an existing weapon.

#### Delete Weapon

```text
DELETE /weapon/:weaponID
```

This endpoint allows an admin to delete a weapon. The backend also removes related weapon transaction records and deletes the uploaded image file if it exists.

---

### 8.3 Artifact Routes

Base route:

```text
/artifact
```

#### Get All Artifacts

```text
GET /artifact
```

This endpoint retrieves artifact data from the database. It supports optional query filters:

```text
GET /artifact?status=available
GET /artifact?status=not-available
```

#### Get Artifact by ID

```text
GET /artifact/:artifactID
```

This endpoint retrieves a specific artifact by ID.

#### Create Artifact

```text
POST /artifact
```

This endpoint allows an admin to create a new artifact with an uploaded image.

Artifact fields include:

- Name
- Set name
- Maximum rarity
- Stock
- Price
- Two-piece bonus
- Four-piece bonus
- Image

#### Update Artifact

```text
PUT /artifact/:artifactID
```

This endpoint allows an admin to update an existing artifact.

#### Delete Artifact

```text
DELETE /artifact/:artifactID
```

This endpoint allows an admin to delete an artifact. The backend also removes related artifact transaction records and deletes the uploaded image file if it exists.

---

### 8.4 User Weapon Routes

Base route:

```text
/userWeapon
```

#### Buy Weapon

```text
POST /userWeapon/buy/:weaponID
```

This endpoint allows a user to buy a weapon. It checks:

- Whether the weapon exists.
- Whether the requested quantity is available.
- Whether the user has enough Mora.
- Then it decreases user money.
- Then it decreases weapon stock.
- Then it creates a weapon transaction record.

The operation uses a database transaction to keep the purchase process consistent.

#### Get Purchased Weapons

```text
GET /userWeapon?status=purchased
```

This endpoint retrieves all weapons purchased by the logged-in user.

---

### 8.5 User Artifact Routes

Base route:

```text
/userArtifact
```

#### Buy Artifact

```text
POST /userArtifact/buy/:artifactID
```

This endpoint allows a user to buy an artifact. It checks stock and user Mora balance before creating a transaction.

#### Get Purchased Artifacts

```text
GET /userArtifact?status=purchased
```

This endpoint retrieves all artifacts purchased by the logged-in user.

---

### 8.6 User Routes

Base route:

```text
/users
```

#### Edit Profile

```text
PATCH /users/edit-profile
```

This endpoint allows the logged-in user to update their username.

---

## 9. Authentication

The application supports two authentication methods:

1. Database login using email and password.
2. External OAuth login using Google.

### 9.1 Local Authentication

For local authentication, users register using username, email, and password. The backend hashes the password using bcrypt before saving it into the database.

During login, the backend compares the entered password with the hashed password in the database. If the credentials are valid, the backend generates a JWT token.

The frontend stores the JWT token locally using `shared_preferences` with the key:

```text
jwt_token
```

This token is later used for protected API requests.

### 9.2 Google OAuth Authentication

The application also supports Google login using the `google_sign_in` package.

The login flow is:

1. User taps the **Sign in with Google** button.
2. The frontend opens Google Sign-In.
3. After successful Google authentication, the frontend receives a Google access token.
4. The frontend sends the token to the backend.
5. The backend verifies the Google user information.
6. If the user does not exist yet, the backend creates a new Google account.
7. The backend generates a JWT token for the application session.
8. The frontend stores the JWT token locally.

This satisfies the external OAuth requirement.

### 9.3 Bearer Token

After login, the backend generates a JWT bearer token. The token is longer than 20 characters and is used to authorize protected requests.

The frontend sends the token in the request header:

```text
Authorization: Bearer <token>
```

### 9.4 Bearer Token Verification

The backend verifies bearer tokens using authentication middleware.

Protected routes include:

- Weapon routes
- Artifact routes
- User weapon routes
- User artifact routes
- Edit profile route

Admin-only routes also use role verification. If the user is not an admin, the backend returns a forbidden response.

This satisfies the requirement that at least one request must verify the bearer token.

---

## 10. User Roles

The application has two roles:

### 10.1 User Role

A normal user can:

- Log in or register.
- Log in using Google.
- View weapons and artifacts.
- Buy weapons and artifacts.
- View purchased items in the inventory.
- Edit username.
- Change theme.
- Log out.

The normal user navigation contains:

- Shop
- Inventory
- Profile

### 10.2 Admin Role

An admin can:

- Log in.
- View weapons and artifacts.
- Create new weapons and artifacts.
- Edit weapons and artifacts.
- Delete weapons and artifacts.
- Change theme.
- Log out.

The admin navigation contains:

- Shop
- Create
- Profile

The navigation is role-based, so the displayed pages are different depending on whether the logged-in account is a user or admin.

---

## 11. Frontend Pages

The application contains more than five pages or screen views.

### 11.1 Authentication Screen

The authentication screen contains both login and registration forms. It uses a tab-like switcher to move between:

- Sign-in form
- Register form

The screen includes:

- Application logo
- Sign-in tab
- Register tab
- Email field
- Password field
- Username field for registration
- Terms and Conditions checkbox
- Google sign-in button
- Error and success dialogs

### 11.2 Login Page

The login page allows users to log in using email and password. It also provides a Google sign-in option.

Login features:

- Email input
- Password input
- Password visibility toggle
- Google login button
- Loading indicator
- Success dialog
- Error dialog

### 11.3 Register Page

The register page allows users to create a new account.

Register features:

- Username input
- Email input
- Password input
- Terms and Conditions checkbox
- Registration validation
- Auto-login after successful registration
- Success and error dialogs

### 11.4 Shop Page

The shop page displays weapons and artifacts in a grid layout. It uses tabs to switch between weapon and artifact lists.

Shop features:

- Screen header
- Mora balance badge
- Weapons tab
- Artifacts tab
- Weapon cards
- Artifact cards
- Item rarity stars
- Item stock indicator
- Item price panel
- Item detail bottom sheet

### 11.5 Inventory Page

The inventory page displays items purchased by the logged-in user. It combines purchased weapons and artifacts into one inventory view.

Inventory features:

- Screen header
- Item filters
- All filter
- Weapon filter
- Artifact filter
- Inventory card grid
- Empty inventory message
- Item detail view without purchase action

### 11.6 Create Page

The create page is available for admin users. It allows admins to add new weapons and artifacts.

Create page features:

- Weapons tab
- Artifacts tab
- Image picker
- Weapon creation form
- Artifact creation form
- Submit button
- Loading indicator
- Validation messages

### 11.7 Edit Weapon Page

The edit weapon page allows an admin to update weapon data.

Editable weapon fields include:

- Weapon name
- Type
- Rarity
- Base attack
- Sub stat
- Passive name
- Passive description
- Price
- Stock
- Image

### 11.8 Edit Artifact Page

The edit artifact page allows an admin to update artifact data.

Editable artifact fields include:

- Artifact name
- Set name
- Maximum rarity
- Stock
- Price
- Two-piece bonus
- Four-piece bonus
- Image

### 11.9 Profile Page

The profile page displays user account information and settings.

Profile features:

- Profile background image
- Avatar
- Username
- Email
- Edit profile button
- Theme switch
- App information section
- Logout button

---

## 12. UI Components

The application uses more than five kinds of UI components.

### 12.1 Custom Form Field

The custom form field is used for login, registration, create item, edit item, and profile forms.

Features:

- Label
- Hint text
- Error text
- Password visibility toggle
- Custom fill color
- Custom focused border
- Light and dark mode support

### 12.2 Custom Button

The custom button is used for important actions such as saving, submitting, and confirming actions.

Features:

- Custom background color
- Custom foreground color
- Custom font
- Rounded corners
- Loading indicator support
- Optional icon or leading widget

### 12.3 Weapon Card

The weapon card displays weapon information in the shop.

It contains:

- Weapon image
- Rarity gradient
- Stock indicator
- Rarity stars
- Weapon name
- Weapon type
- Mora price panel

### 12.4 Artifact Card

The artifact card displays artifact information in the shop.

It contains:

- Artifact image
- Rarity gradient
- Stock indicator
- Rarity stars
- Artifact name
- Artifact set name
- Mora price panel

### 12.5 Inventory Card

The inventory card displays purchased weapons and artifacts in the inventory page.

It helps users quickly see owned items and open item details.

### 12.6 Main Navigation Bar

The bottom navigation bar allows users to move between main pages.

It includes:

- Custom SVG icons
- Active and inactive states
- Animated scale effect
- Role-based menu items

### 12.7 Screen Header

The screen header displays page titles such as Shop, Inventory, and Create. It also shows the Mora badge for normal users.

### 12.8 Money Badge

The money badge displays the user's Mora balance. It includes a Mora icon and refresh behavior.

### 12.9 App Message Dialog

The app message dialog is used for success, error, and information messages.

It includes:

- Custom icon
- Custom title
- Custom message
- Full-width confirmation button
- Different accent colors based on message type

### 12.10 Detail Bottom Sheets

Weapon and artifact detail sheets show detailed item information.

They include:

- Large item image
- Rarity stars
- Item description
- Price
- Stock
- Quantity selector
- Purchase button
- Edit and delete actions for admin users

### 12.11 Quantity Selector

The quantity selector allows users to choose how many items they want to buy.

It improves usability because users can buy more than one item at a time.

### 12.12 Image Picker

The image picker is used in the admin create and edit forms. It allows admins to upload item images from the device gallery.

---

## 13. Data Validation

The application implements several data validations. When validation fails, the application shows an error message using dialogs, field errors, or snackbars.

### 13.1 Login Email Validation

The login form validates the email field.

Validation rules:

- Email must not be empty.
- Email must follow a valid email format.

Error messages:

- `Email is required`
- `Invalid email`

### 13.2 Login Password Validation

The login form validates the password field.

Validation rule:

- Password must not be empty.

Error message:

- `Password is required`

### 13.3 Register Username Validation

The registration form validates the username field.

Validation rule:

- Username must not be empty.

Error message:

- `Username is required`

### 13.4 Register Email Validation

The registration form validates the email field.

Validation rule:

- Email must not be empty.

Error message:

- `Email is required`

### 13.5 Register Password Validation

The registration form validates the password field.

Validation rule:

- Password must not be empty.

Error message:

- `Password is required`

### 13.6 Terms and Conditions Validation

The registration form requires the user to agree to the terms before registering.

Validation rule:

- The checkbox must be selected.

Error message:

- `Please agree to the terms first`

### 13.7 Create Weapon Image Validation

The create weapon form requires an image.

Validation rule:

- Weapon image must be selected.

Error message:

- `Please select a weapon image`

### 13.8 Create Artifact Image Validation

The create artifact form requires an image.

Validation rule:

- Artifact image must be selected.

Error message:

- `Please select an artifact image`

### 13.9 Create Item Field Validation

The create forms validate several required fields.

Examples:

- Weapon name is required.
- Artifact name is required.
- Artifact set name is required.
- Artifact price is required.
- Artifact bonuses are required.

Example error messages:

- `Required`
- `Name is required`
- `Set name is required`
- `Price is required`
- `Bonus is required`

### 13.10 Edit Profile Validation

The profile edit dialog validates the new username.

Validation rule:

- Username must not be empty.

Error message:

- `Username cannot be null`

### 13.11 Backend Purchase Validation

The backend validates purchase requests.

Validation rules:

- Item must exist.
- Quantity must not exceed stock.
- User must have enough money.

Example error messages:

- `There's no such weapon!`
- `Quantity over stock!`
- `Not enough money!`
- `There's no such artifact!`
- `Artifact over stock!`

This ensures that invalid purchases do not update the database.

---

## 14. Main Features

### 14.1 User Registration

Users can register using username, email, and password. The password is hashed before being saved to the database.

After successful registration, the application automatically logs the user in.

### 14.2 User Login

Users can log in using their registered email and password. If the login succeeds, the backend returns a JWT token and user data.

The frontend stores the token locally and uses it for future API requests.

### 14.3 Google Sign-In

Users can also log in using Google. This supports the external OAuth requirement.

The Google login flow creates or retrieves a user account based on the Google email, then generates a JWT token for the application session.

### 14.4 Shop System

The shop displays weapons and artifacts in separate tabs. Users can browse all available items and open the detail sheet by tapping an item card.

Each item card displays:

- Image
- Name
- Type or set name
- Rarity
- Stock
- Price

### 14.5 Weapon Detail

The weapon detail sheet shows full weapon information, including:

- Weapon image
- Name
- Type
- Rarity
- Base attack
- Sub stat
- Passive name
- Passive description
- Stock
- Price
- Quantity selector
- Purchase button

For admins, it also provides edit and delete actions.

### 14.6 Artifact Detail

The artifact detail sheet shows full artifact information, including:

- Artifact image
- Artifact name
- Set name
- Maximum rarity
- Two-piece bonus
- Four-piece bonus
- Stock
- Price
- Quantity selector
- Purchase button

For admins, it also provides edit and delete actions.

### 14.7 Purchase System

Users can purchase weapons and artifacts. The purchase system checks stock and user Mora balance before completing the transaction.

When a purchase succeeds:

- User Mora decreases.
- Item stock decreases.
- A transaction record is created.
- Inventory data can be refreshed.

The backend uses a database transaction to make sure the purchase process is safe and consistent.

### 14.8 Inventory System

The inventory page shows purchased weapons and artifacts.

Users can filter inventory items by:

- All
- Weapon
- Artifact

The inventory is sorted by rarity, so higher rarity items are shown first.

### 14.9 Admin Create System

Admin users can create weapons and artifacts.

For weapons, the admin can input:

- Weapon name
- Type
- Rarity
- Base attack
- Sub stat
- Passive name
- Passive description
- Price
- Stock
- Image

For artifacts, the admin can input:

- Artifact name
- Set name
- Maximum rarity
- Stock
- Price
- Two-piece bonus
- Four-piece bonus
- Image

### 14.10 Admin Update System

Admin users can update existing weapons and artifacts. The edit screens are pre-filled with existing item data so the admin can modify only the needed fields.

### 14.11 Admin Delete System

Admin users can delete weapons and artifacts. Before deletion, the application shows a confirmation dialog. This prevents accidental item removal.

### 14.12 Profile Management

Users can view their profile data, including username and email. They can also edit their username from the profile page.

### 14.13 Theme Switcher

The profile page includes a theme switch. Users can switch between light mode and dark mode.

The selected theme is stored locally, so the application remembers the user's preference.

### 14.14 Logout

Users can log out from the profile page. Logging out removes the saved JWT token and returns the user to the authentication screen.

---

## 15. UI Design

The application uses a customized UI design that supports the Genshin-inspired shop and inventory theme. The design is consistent, readable, and usable.

### 15.1 Theme Customization

The application defines custom light and dark themes.

The theme customizes:

- Font family
- Font size
- Font color
- Background color
- Surface color
- Button color
- Input field color
- Dialog color
- Navigation bar color
- Icon color

The theme is applied globally through `MaterialApp`.

### 15.2 Color Palette

The application uses a custom color palette.

Main colors:

| Color Purpose | Value |
|---|---|
| Primary color | `#F0BB6A` |
| Secondary color | `#14698D` |
| Light background | `#F5F7FB` |
| Dark background | `#18191B` |
| Light surface | `#FFFFFF` |
| Dark surface | `#1B1D24` |
| Light primary text | `#252629` |
| Dark primary text | `#FFFFFF` |

The primary color is used for important actions, highlights, borders, selected states, and buttons.

The secondary color is used for supporting visual elements, especially in dark mode and theme controls.

### 15.3 Font Customization

The application uses two custom fonts:

- `Rubik`
- `HyWenhei`

`Rubik` is used as the general application font.  
`HyWenhei` is used for important Genshin-themed UI elements, such as:

- Screen titles
- Item names
- Button text
- Item prices
- Detail sheet information
- Money badge

This makes the application feel more unique and suitable for the theme.

### 15.4 Font Size and Font Weight

The application uses different font sizes and weights to create clear visual hierarchy.

Examples:

- Screen headers use large text.
- Authentication titles use bold text.
- Item names use bold text.
- Supporting details use smaller text.
- Button labels use semi-bold or bold text.
- Price text is clearly visible in the price panel.

This helps users quickly understand important information.

### 15.5 Background and Surface Colors

The application customizes backgrounds and surfaces.

Examples:

- Shop and inventory pages use custom background colors.
- Cards use separate surface colors.
- Bottom sheets use light or dark surface colors depending on the selected theme.
- Dialogs use rounded surfaces and custom backgrounds.
- Profile header uses background image assets.

These changes make the app look more polished and organized.

### 15.6 Rarity Gradient Design

Weapons and artifacts use rarity-based gradient backgrounds.

Examples:

- Five-star items use a gold-themed gradient.
- Four-star items use a purple-themed gradient.
- Three-star items use a blue-themed gradient.

This makes item rarity visually clear and improves the game-inspired feeling of the application.

### 15.7 Alpha and Tint Effects

The application uses alpha transparency in several areas.

Examples:

- Stock indicators use semi-transparent black backgrounds.
- Detail sheets use subtle overlays.
- Navigation bar shadows use low opacity.
- Secondary text uses reduced opacity.
- Money badge background uses transparent secondary color.
- Borders use transparent primary color.

These effects create depth without reducing readability.

### 15.8 Image Content Mode

The application customizes how images are displayed.

Examples:

- Item cards use image fitting so images fill the card area neatly.
- Detail sheets use larger item images with contained layout.
- Create forms preview uploaded images using contained display mode.
- Profile header uses cover mode for background images.

This prevents images from appearing broken or visually inconsistent.

### 15.9 Button Design

Buttons are customized with:

- Primary background color
- Dark foreground text color
- Rounded corners
- Fixed height
- Custom font
- Loading indicator support

This makes actions clear and consistent across the application.

### 15.10 Navigation Design

The bottom navigation bar uses:

- Custom SVG icons
- Active and inactive colors
- Animated scale effect
- Custom labels
- Role-based navigation items
- Border and shadow

This helps users understand their current location in the app.

### 15.11 Dialog Design

Dialogs use custom styling, including:

- Rounded corners
- Custom icon container
- Accent colors
- Custom title font
- Full-width confirmation button

This makes success, error, and information messages more readable and consistent.

### 15.12 Usability Considerations

The design supports usability in several ways:

1. **Readable contrast**
   - Dark text is used on light backgrounds.
   - Light text is used on dark backgrounds.
   - Buttons and price panels have strong contrast.

2. **Consistent layout**
   - Cards, buttons, dialogs, and forms follow a consistent design.
   - Users can easily recognize similar actions.

3. **Clear active states**
   - Selected tabs, selected navigation items, and active controls are visually highlighted.

4. **Easy interaction**
   - Buttons are large enough to tap.
   - Forms use clear labels and hints.
   - Error messages are shown close to the related action.

5. **Comfortable theme**
   - Light and dark modes allow users to choose the most comfortable appearance.

The UI customizations are visible throughout the application and do not reduce usability.

---

## 16. Creativity

Genshin Import includes several creative features that make the application feel more complete, thematic, and enjoyable to use. These features are designed to match the Genshin-inspired shopping concept while still supporting the main functional requirements of the project.

### 16.1 Genshin-Inspired Item System

The application uses familiar Genshin-style concepts to create a stronger theme identity. Instead of presenting items as plain products, the application displays them as Teyvat-related equipment.

The creative elements include:

- Weapons
- Artifacts
- Rarity stars
- Mora currency
- Artifact set bonuses
- Weapon passive abilities

These elements make the application feel closer to a game-themed marketplace instead of a generic shop application.

### 16.2 Dual Item Categories

The project does not only provide weapons. It also includes artifacts as an additional item category.

This makes the shop more varied because users can browse and purchase two different types of items:

- Weapons, which include type, rarity, base attack, sub stat, passive name, and passive description.
- Artifacts, which include set name, max rarity, two-piece bonus, and four-piece bonus.

This feature expands the original idea and makes the application more aligned with the Genshin theme.

### 16.3 Rarity-Based Visual Design

Weapons and artifacts are displayed with rarity-based gradients and star indicators. Higher rarity items use stronger and more premium-looking colors, while lower rarity items use softer colors.

This design helps users recognize item rarity quickly without reading too much text. It also makes the shop and detail pages more visually interesting.

### 16.4 Mora Balance and Purchase System

The application uses Mora as the user currency. Each user has a Mora balance, and every purchase reduces the user's Mora based on the selected item price and quantity.

This makes the purchase system feel more thematic and game-like. It also adds meaningful interaction because users must have enough Mora before they can buy weapons or artifacts.

### 16.5 Transaction-Based Inventory

Purchased items are stored through transaction records. The inventory page is generated from the user's purchase history instead of being a static list.

This makes the inventory system more realistic because it reflects what the user has actually bought. It also allows the application to calculate the total quantity owned by the user.

### 16.6 Role-Based User Experience

The application provides a different experience for normal users and admins.

Normal users can access:

- Shop
- Inventory
- Profile

Admins can access:

- Shop
- Create
- Profile

This role-based navigation keeps the interface clean because users only see the features that are relevant to them. Admin features such as create, update, and delete are separated from the normal user shopping experience.

### 16.7 Custom Item Detail Sheets

Item details are displayed using custom bottom sheets instead of simple pages. This makes the browsing experience smoother because users can open item details without completely leaving the shop or inventory page.

The detail sheets include item images, rarity stars, descriptions, stock, price, quantity selection, purchase actions, and admin management actions when available.

### 16.8 Light and Dark Theme Personalization

The application includes a light and dark theme switcher in the profile page. The selected theme is saved locally, so the application can remember the user's preference.

This adds personalization and improves comfort because users can choose the display mode that suits their environment.

### 16.9 Admin Image Upload

Admins can upload custom images when creating or editing weapons and artifacts. The uploaded images are stored by the backend and served through the asset route.

This feature makes item management more flexible because admins are not limited to predefined item images.

---

## 17. Asset Documentation

The project uses several local assets.

### 17.1 Image Assets

Image assets are stored in:

```text
frontend/assets/images/
```

Examples:

- `Genshin_Import_logo.svg`
- `Background_Dark.webp`
- `Background_Dark.jpg`
- `Background_Light.jpg`
- `avatar.png`
- `Item_Mora.webp`
- `google_logo.png`
- `bg_Light.png`

These assets are used for:

- App logo
- Profile background
- User avatar
- Mora currency icon
- Google sign-in button

### 17.2 Icon Assets

Icon assets are stored in:

```text
frontend/assets/icons/
```

Examples:

- Shop icons
- Inventory icons
- Profile icons
- Cart icons
- Bag icons

These icons are used in the bottom navigation bar.

### 17.3 Font Assets

Font assets are stored in:

```text
frontend/assets/fonts/
```

Fonts used:

- `HyWenhei.ttf`
- `Rubik-Regular.ttf`
- `Rubik-Medium.ttf`
- `Rubik-SemiBold.ttf`
- `Rubik-Bold.ttf`

These fonts are registered in `pubspec.yaml`.

### 17.4 External Data and Image Reference

The seed data retrieves weapon and artifact data from the Genshin API:

```text
https://genshin.jmp.blue/
```

The backend seed process uses this source to insert initial weapons, artifacts, and remote item image URLs into the database.

No audio or video assets are used in this project.

---

## 18. How to Run the Application

### 18.1 Backend Setup

Open the backend folder:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Create a `.env` file in the backend folder.

Example environment variables:

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=genshin_import
JWT_SECRET=your_jwt_secret
GOOGLE_CLIENT_ID=your_google_client_id
```

Run database migration:

```bash
node --env-file=.env ./src/migrates/migrate.js
```

Run database seed:

```bash
node --env-file=.env ./src/migrates/seed.js
```

Start the backend server:

```bash
npm run dev
```

The backend runs on:

```text
http://localhost:3000
```

### 18.2 Frontend Setup

Open the frontend folder:

```bash
cd frontend
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For Flutter Web, the default backend URL is:

```text
http://localhost:3000
```

For Android emulator, the default backend URL is:

```text
http://10.0.2.2:3000
```

For a physical mobile device, the backend URL should use the computer's local network IP address. Example:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000
```

---

## 19. How to Use the Application

### 19.1 Register as a User

1. Open the application.
2. Go to the Register tab.
3. Enter username, email, and password.
4. Check the Terms and Conditions checkbox.
5. Submit the registration form.
6. After successful registration, the user is automatically logged in.

### 19.2 Login as a User

1. Open the application.
2. Go to the Sign-in tab.
3. Enter email and password.
4. Press the login button.
5. If the credentials are correct, the user enters the main application.

### 19.3 Login with Google

1. Open the application.
2. Press **Sign in with Google**.
3. Select a Google account.
4. After successful authentication, the application logs the user in.

### 19.4 Buy a Weapon or Artifact

1. Open the Shop page.
2. Select either the Weapons tab or Artifacts tab.
3. Tap an item card.
4. Read the item detail.
5. Select quantity.
6. Press the purchase button.
7. If the user has enough Mora and the item has enough stock, the purchase succeeds.

### 19.5 View Inventory

1. Open the Inventory page.
2. View all purchased items.
3. Use filters to show all items, weapons only, or artifacts only.
4. Tap an item to see its detail.

### 19.6 Admin Create Item

1. Log in as an admin.
2. Open the Create page.
3. Choose Weapons or Artifacts tab.
4. Upload an image.
5. Fill in the item data.
6. Submit the form.

### 19.7 Admin Edit Item

1. Log in as an admin.
2. Open the Shop page.
3. Tap an item.
4. Choose the edit action.
5. Update the item data.
6. Save changes.

### 19.8 Admin Delete Item

1. Log in as an admin.
2. Open the Shop page.
3. Tap an item.
4. Choose the delete action.
5. Confirm the deletion.

### 19.9 Edit Profile

1. Open the Profile page.
2. Press **Edit Profile**.
3. Enter a new username.
4. Press Save.

### 19.10 Change Theme

1. Open the Profile page.
2. Find the Theme setting.
3. Toggle the switch to change between light and dark mode.

### 19.11 Logout

1. Open the Profile page.
2. Press **Log out**.
3. The user session is cleared and the app returns to the authentication screen.

---

## 20. Requirement Checklist

| Requirement | Implementation in Genshin Import |
|---|---|
| MySQL database | Implemented using MySQL and `mysql2` |
| Create operation | Register user, create weapon, create artifact, purchase item |
| Retrieve operation | Get weapons, artifacts, inventory, profile |
| Update operation | Update weapon, artifact, profile, stock, money |
| Delete operation | Delete weapon and artifact |
| Flutter frontend | Implemented using Flutter |
| At least 5 UI components | Implemented more than 5 components |
| At least 5 pages | Implemented more than 5 screen views |
| At least 3 validations | Implemented multiple validations |
| Error message when validation fails | Implemented using field errors, dialogs, and snackbars |
| Node.js Express backend | Implemented using Express.js |
| At least 2 GET requests | Implemented many GET endpoints |
| At least 1 POST/PUT/PATCH/DELETE request | Implemented many mutation endpoints |
| Login using database user | Implemented local email and password login |
| Login using external OAuth | Implemented Google Sign-In |
| Generate bearer token | Implemented JWT bearer token |
| Bearer token verification | Implemented with authentication middleware |
| Themed UI design | Implemented light and dark themes |
| 2-4 visible UI customizations | Implemented colors, fonts, font sizes, alpha, image fit, backgrounds |
| Usable design | Maintains contrast, readability, and clear navigation |
| Creativity | Explained through themed item categories, rarity visuals, Mora system, role-based experience, custom detail sheets, theme personalization, and admin image upload |

---

## 21. Conclusion

Genshin Import is a complete mobile hybrid application that satisfies the project requirements. It provides a Genshin-inspired marketplace where users can browse and buy weapons and artifacts, while admins can manage item data.

The project includes:

- Flutter frontend
- Node.js Express backend
- MySQL database
- Local authentication
- Google OAuth authentication
- JWT bearer token authorization
- Role-based user and admin features
- CRUD operations
- Data validation
- Custom UI design
- Light and dark theme support
- Inventory and transaction system
- Image upload for admin-created items

Overall, the application is functional, themed, and usable. The visual design supports the Genshin Import concept while keeping the interface clear and easy to navigate.
