# Travela - Accommodation Search (Flutter)

A Flutter application built with Flutter 3.29.0 featuring real-time SSE stream accommodation search, location autocomplete, dynamic guest/date selection, and responsive stay grid cards.

---

## Tech Stack & Architecture

- Framework: Flutter 3.44.8
- State Management: Provider
- Dependency Injection: GetIt
- Network & SSE: Custom EventSource parser for chunked streaming
- Images: cached_network_image with local fallbacks

---

## Features Implemented

- Real-Time SSE Streaming: Handles live chunked stay results (meta, item, done, error) with a live status bar banner.
- Debounced Search Bar: 300ms debounced location autocomplete with outside-tap unfocus and active filter badge indicators.
- Guest & Date Selection: Dedicated screen for check-in/out date ranges (YYYY-MM-DD) and guest occupancy steppers.
- Filter Sheet: Bottom sheet control for real-time price range adjustments (BDT 1,000–10,000).
- Responsive Stay Grid: Optimized 2-column grid cards (0.72 ratio) with property specs, badges, and offer pricing without UI overflow.
- Paginated Scrolling: Safe infinite scroll pagination (limit: 20) with isolated ScrollController instances.

---

## Getting Started

1. Get dependencies:
   flutter pub get

2. Run the app:
   flutter run


https://github.com/user-attachments/assets/c957fc46-5050-4483-a25c-9f467d0e140e
