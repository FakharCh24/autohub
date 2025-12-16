# ⚡ AutoHub - Quick 15-Minute Test

Essential testing guide to verify all core features work correctly.

---

## ⏱️ Time Allocation

- **5 min:** Authentication & Setup
- **5 min:** Core Features (Listing, Search, Favorites)
- **3 min:** Chat System
- **2 min:** Profile & Final Checks

---

## 🚀 Quick Start

### Prerequisites (1 min)

- [ ] App installed and running
- [ ] Internet connected
- [ ] Have 2-3 car images ready on device

---

## ✅ Test Sequence

### Part 1: Authentication (2 min)

**Test 1.1: Registration**

1. Launch app
2. Skip onboarding (or swipe through)
3. Tap "Sign Up"
4. Enter:
   - Name: `Test User`
   - Email: `test@example.com`
   - Phone: `1234567890`
   - Password: `Test123`
5. Tap "Sign Up"

**✓ Expected:** Account created, redirected to home

**Test 1.2: Logout & Login**

1. Go to Profile → Logout
2. Login with same credentials

**✓ Expected:** Successfully logged back in

---

### Part 2: Create Listing (3 min)

**Test 2.1: Add Car Listing**

1. Tap "Sell" or "+" button
2. Fill in:
   - Title: `2020 Honda Civic`
   - Price: `18000`
   - Description: `Clean car, low miles`
   - Category: `Sedan`
   - Fuel: `Petrol`
   - Transmission: `Automatic`
   - Mileage: `25000`
   - Year: `2020`
3. Upload 3 images
4. Submit

**✓ Expected:** Listing created, visible in home feed

---

### Part 3: Search & Filter (2 min)

**Test 3.1: Search**

1. In home screen, search: `Honda`

**✓ Expected:** Your listing appears

**Test 3.2: Filter**

1. Open filters
2. Select category: `Sedan`
3. Set price: `15000 - 20000`
4. Apply

**✓ Expected:** Only matching cars shown

---

### Part 4: Favorites (1 min)

**Test 4.1: Save Favorite**

1. Browse listings
2. Tap heart icon on 2 cars
3. Go to "Saved" tab

**✓ Expected:** Both cars in favorites list

**Test 4.2: Remove Favorite**

1. Tap heart icon to unfavorite one

**✓ Expected:** Removed from favorites

---

### Part 5: Chat System (3 min)

**Test 5.1: Start Chat** (Need 2nd account)

1. Create/login to 2nd account: `buyer@test.com`
2. View a car listing (from 1st account)
3. Tap "Chat with Seller"
4. Send: `Is this available?`

**✓ Expected:** Message sent

**Test 5.2: Receive & Reply**

1. Switch to 1st account
2. Check chat list (should have unread badge)
3. Open chat
4. Reply: `Yes!`

**✓ Expected:**

- Message received
- Typing indicator works
- Reply sent successfully

---

### Part 6: Profile (2 min)

**Test 6.1: Edit Profile**

1. Go to Profile
2. Tap Edit
3. Update name: `Updated Name`
4. Upload profile picture
5. Save

**✓ Expected:** Changes saved

**Test 6.2: View My Listings**

1. Tap "My Listings"

**✓ Expected:** Your car listing appears with stats

---

### Part 7: Edit & Delete (2 min)

**Test 7.1: Edit Listing**

1. From "My Listings", select your car
2. Tap "Edit"
3. Change price to `17500`
4. Save

**✓ Expected:** Price updated

**Test 7.2: Delete Listing**

1. Select listing
2. Tap "Delete"
3. Confirm

**✓ Expected:** Listing removed from everywhere

---

## 🎯 Quick Checklist

After 15 minutes, verify:

- [ ] ✅ Can register/login
- [ ] ✅ Can create car listing with images
- [ ] ✅ Listing appears in home feed
- [ ] ✅ Search works
- [ ] ✅ Filters work
- [ ] ✅ Can favorite/unfavorite cars
- [ ] ✅ Chat works (send/receive)
- [ ] ✅ Can edit profile
- [ ] ✅ Can edit/delete listings
- [ ] ✅ No crashes occurred

---

## 🚨 Critical Issues to Watch For

**STOP and fix if you see:**

- ❌ App crashes on any action
- ❌ Cannot create account
- ❌ Images don't upload
- ❌ Search returns no results
- ❌ Chat messages don't send
- ❌ Firebase errors in console

---

## 📱 Test on Multiple Scenarios

### Quick Additional Tests (if time permits):

**Network Test:**

1. Turn off WiFi → Check error handling
2. Turn on WiFi → Should reconnect

**Image Test:**

1. Try uploading 10 images (max limit)
2. Verify limit enforcement

**Permission Test:**

1. Deny camera permission
2. Check error message quality

---

## 🎉 Success Criteria

**Your app is ready if:**

✅ All 7 parts completed without critical errors  
✅ Basic CRUD operations work (Create, Read, Update, Delete)  
✅ Real-time features work (chat, favorites)  
✅ UI is responsive and intuitive  
✅ No crashes during testing

---

## 📝 Document Issues

If you find bugs:

```
⚠️ [ISSUE]: Brief description
🔍 Steps: How to reproduce
💥 Impact: Critical/Medium/Low
```

---

## 🔄 Next Steps

After quick test:

1. ✅ If all pass → Run full TESTING_GUIDE.md
2. ⚠️ If issues found → Fix and retest
3. 📹 Record demo video
4. 📄 Review documentation
5. 🚀 Ready for submission!

---

**15-Minute test complete! ⏱️✅**

_For comprehensive testing, see TESTING_GUIDE.md_

_Last Updated: December 15, 2025_
