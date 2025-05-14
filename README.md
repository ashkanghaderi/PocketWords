# PocketWords - Vocabulary Flash Card App

## Overview
PocketWords is a single-screen iOS app designed to help language learners master new vocabulary through interactive flash cards with instant feedback and progress tracking.

## Features
- **Flash Card System**
  - Create and flip through vocabulary cards
  - Smooth 3D flip animation
- **Practice Mode**
  - Type meanings for each word
  - Instant correctness feedback (✓/✗)
  - Case and whitespace insensitive checking
- **Progress Tracking**
  - Earn +10 XP per correct answer
  - Visual progress bar
  - Persistent XP tracking

## Technical Specifications
| Category        | Details                     |
|-----------------|----------------------------|
| Target Platform | iOS 18+                    |
| Architecture    | MVVM                       |
| Persistence     | SwiftData                  |
| Dependencies    | None (100% native SwiftUI) |

## Code Structure
```bash
PocketWords/
├── Models/
│   ├── WordCard.swift
│   └── UserProgress.swift
├── ViewModels/
│   └── FlashCardsViewModel.swift
├── Views/
│   ├── CardView.swift
│   ├── AddCardView.swift
│   └── FlashCardsView.swift
├── Utilities/
│   └── Extensions.swift
└── Tests/
    └── FlashCardsViewModelTests.swift
    
