# Google Play Store Assets

This directory contains all assets required for the Google Play Store listing.

## Required Assets Checklist

### Graphics

| Asset | Size | Format | Status |
|-------|------|--------|--------|
| App Icon | 512x512px | PNG (32-bit, alpha) | [ ] Pending |
| Feature Graphic | 1024x500px | PNG or JPG | [ ] Pending |
| Phone Screenshots | Min 2, Max 8 | PNG or JPG | [ ] Pending |

### Text Content

| Asset | Limit | Status |
|-------|-------|--------|
| Short Description | 80 characters | [x] Complete |
| Full Description | 4000 characters | [x] Complete |

## File Structure

```
store_assets/
├── README.md              # This file
├── short_description.txt  # 80 char description
├── full_description.txt   # Full store description
├── icon_512.png          # App icon (512x512)
├── feature_graphic.png   # Feature graphic (1024x500)
└── screenshots/          # Phone screenshots
    ├── 01_home.png
    ├── 02_add_recipe.png
    ├── 03_recipe_detail.png
    ├── 04_search.png
    └── ...
```

## Asset Specifications

### App Icon (512x512)
- 512 x 512 pixels
- 32-bit PNG (with alpha)
- No rounded corners (Google applies them automatically)
- Should match the app's launcher icon style

### Feature Graphic (1024x500)
- 1024 x 500 pixels
- PNG or JPG
- No text in corners (may be cropped)
- Represents the app brand/functionality

### Screenshots
- Minimum: 2 screenshots
- Maximum: 8 screenshots
- Minimum dimension: 320px
- Maximum dimension: 3840px
- Aspect ratio between 16:9 and 9:16
- PNG or JPG (24-bit, no alpha)

#### Recommended Screenshots
1. Home screen with recipes list
2. Add/Edit recipe screen
3. Recipe detail view
4. Search functionality
5. Categories/filtering
6. Settings screen
7. Dark mode (optional)
8. Empty state or onboarding (optional)

## Creating Screenshots

### Using Android Emulator
```bash
# Start emulator
flutter emulators --launch <emulator_name>

# Run app
flutter run

# Take screenshot (from another terminal)
adb exec-out screencap -p > screenshot.png
```

### Using Flutter
```bash
# Run in profile mode for better performance
flutter run --profile

# Use device screenshot button in DevTools
```

## Text Content

### Short Description (80 chars)
See `short_description.txt`

### Full Description (4000 chars)
See `full_description.txt`

## Optional Assets

### Tablet Screenshots
- 7-inch tablet: 1024 x 600 minimum
- 10-inch tablet: 1280 x 800 minimum

### Promo Video
- YouTube URL
- 30 seconds to 2 minutes recommended
- Landscape orientation preferred
