# Project Rules – Sodium Recipe App

This file defines the project-level rules for Claude when working on the Sodium recipe app.

---

## Project Overview

**Sodium** is a mobile recipe app for Android and iOS built with Flutter. Users can create, view, edit, search, and delete their personal recipes. All data is stored locally on-device.

### Technology Stack

| Component | Choice | Reason |
|-----------|--------|--------|
| Framework | Flutter | Single codebase for Android & iOS |
| Language | Dart | Flutter's native language |
| Database | Isar | Fast, type-safe, Flutter-optimized local storage |
| State Management | Riverpod | Modern, testable, beginner-friendly |
| CI/CD | GitHub Actions | Full automation for tests & builds |
| Documentation | GitHub Wiki | Developer docs + user manual |
| Project Management | GitHub Projects | Sprint planning with milestones |

---

## Git Workflow (Mandatory)

### Rules

1. **All work requires an issue** – No changes without a tracking issue
2. **Branch naming** – `type/id-description` format
   - Types: `feature/`, `fix/`, `docs/`, `refactor/`, `test/`
   - Examples: `feature/16-flutter-setup`, `fix/23-crash-on-save`
3. **Commit message format** – All commits MUST start with `#<issue-id> <message>`
   - Example: `#16 Add initial Flutter project structure`
   - Example: `#23 Implement Recipe model with Isar annotations`
   - This is **non-negotiable** and enforced via git hook
4. **Main branch protected** – No direct pushes to main, all changes via PR
5. **PR requirements:**
   - Must reference a GitHub issue
   - All CI checks must pass
   - At least one review approval required
6. **Code standards** – Flutter defaults enforced
   - `dart format` – code formatting
   - `flutter analyze` – static analysis

### Git Hook (Commit Message Validation)

The following hook MUST be installed at `.git/hooks/commit-msg`:

```bash
#!/bin/bash
commit_msg=$(cat "$1")
if ! echo "$commit_msg" | grep -qE "^#[0-9]+ .+"; then
  echo "ERROR: Commit message must start with #<issue-id> <message>"
  echo "Example: #123 Add recipe model"
  exit 1
fi
```

Make executable with: `chmod +x .git/hooks/commit-msg`

### Development Workflow

```
1. Create/Pick issue from GitHub Project board
2. Create branch: git checkout -b feature/<issue-id>-<description>
3. Make code changes
4. Commit: git commit -m "#<issue-id> <message>"
5. Push & create PR (link issue in description)
6. CI passes + Review approval
7. Merge to main
```

---

## GitHub Issue Requirements (Mandatory)

Every issue MUST have:

### Required Fields
- **Labels** – At least one type label (e.g., `feature`, `setup`, `ui`, `testing`, `ci`)
- **Milestone** – Assigned to appropriate version milestone (v0.1.0, v0.2.0, v0.3.0, v1.0.0)
- **Assignee** – Assigned to `philipp-gatzka`
- **Priority** – Set as PROJECT FIELD (not label): `P0`, `P1`, or `P2`
- **Size** – Set as PROJECT FIELD (not label): `XS`, `S`, `M`, `L`, or `XL`

### Required Content
- **User Story** – Every issue must start with a user story
  - Format: `As a **[role]**, I want [feature] so that [benefit].`
- **Detailed Description** – Technical details, design specifications, implementation notes
- **Dependencies** – If blocked by another issue, reference using task list format:
  ```markdown
  ## Dependencies
  - [ ] #16
  - [ ] #23
  ```
- **Tasks** – Checklist of specific implementation steps
- **Acceptance Criteria** – MUST always include:
  ```markdown
  ## Acceptance Criteria
  - [ ] Documentation has been updated
  - [ ] Implemented code has test coverage ≥ 80%
  - [ ] [Additional criteria specific to this issue]
  ```

### Issue Granularity
- Issues must be **granular** – no general issues like "Set up project"
- Each issue should represent a single, focused piece of work
- Break down large features into multiple smaller issues

### Issue Template

```markdown
## User Story
As a **[role]**, I want [feature] so that [benefit].

## Description
[Detailed description of what needs to be done]

## Technical Details
- **File:** `lib/path/to/file.dart`
- **Component:** [Widget/Class/Method name]
- [Additional technical specifications]

## Dependencies
- [ ] #[issue-number]

## Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Acceptance Criteria
- [ ] Documentation has been updated
- [ ] Implemented code has test coverage ≥ 80%
- [ ] [Additional criteria]
```

---

## GitHub Project Configuration

### Project Board
- **Project:** "sodium" (GitHub Projects v2)
- **URL:** https://github.com/users/philipp-gatzka/projects/17

### Project Fields
| Field | Type | Options |
|-------|------|---------|
| Priority | Single Select | P0 (Critical), P1 (High), P2 (Medium) |
| Size | Single Select | XS, S, M, L, XL |
| Status | Single Select | Backlog, Ready, In progress, In review, Done |

### Milestones
| Milestone | Description |
|-----------|-------------|
| v0.1.0 | Project setup & infrastructure |
| v0.2.0 | Core recipe CRUD features |
| v0.3.0 | Search, UI polish & testing |
| v1.0.0 | MVP release |

---

## CI/CD Requirements

### GitHub Actions Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push/PR to main | Run tests, lint, analyze, enforce ≥80% coverage |
| `build-android.yml` | Push/PR to main | Build Android APK |
| `build-ios.yml` | Push/PR to main | Build iOS (unsigned) |
| `release.yml` | Tag `v*` | Build release artifacts, create GitHub Release |

### Coverage Requirements
- **Minimum coverage:** 80%
- CI MUST fail if coverage drops below 80%
- Coverage report uploaded as artifact

---

## Project Structure

```
sodium/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # MaterialApp configuration
│   │
│   ├── models/                   # Data models
│   │   └── recipe.dart           # Recipe Isar collection
│   │
│   ├── providers/                # Riverpod providers
│   │   ├── database_provider.dart
│   │   └── recipe_provider.dart
│   │
│   ├── repositories/             # Data access layer
│   │   └── recipe_repository.dart
│   │
│   ├── screens/                  # Full-page screens
│   │   ├── home_screen.dart
│   │   ├── recipe_detail_screen.dart
│   │   └── recipe_edit_screen.dart
│   │
│   ├── widgets/                  # Reusable components
│   │   ├── recipe_card.dart
│   │   ├── ingredients_input.dart
│   │   ├── instructions_input.dart
│   │   ├── search_bar.dart
│   │   ├── empty_state.dart
│   │   └── loading_widget.dart
│   │
│   └── theme/                    # Styling
│       └── app_theme.dart
│
├── test/                         # Unit & widget tests
│   ├── models/
│   ├── repositories/
│   ├── providers/
│   ├── screens/
│   └── widgets/
│
├── integration_test/             # Integration tests
│
├── .github/
│   └── workflows/                # CI/CD workflows
│
├── android/                      # Android config
├── ios/                          # iOS config
├── pubspec.yaml                  # Dependencies
├── CLAUDE.md                     # This file
└── README.md
```

---

## MVP Features (Scope)

### Included
- Create recipes (title, ingredients, instructions)
- View recipe list
- View recipe details
- Edit recipes
- Delete recipes (with confirmation)
- Search recipes by title

### Excluded (Future)
- Photos
- Categories/collections
- Sharing/export
- User accounts
- Cloud sync

---

## Code Standards

### Flutter/Dart
- Use `dart format` for consistent formatting
- Use `flutter analyze` with `--fatal-infos` for static analysis
- Follow Flutter style guide and best practices
- Use Riverpod for all state management
- Use Isar for all local persistence

### Testing
- Unit tests for models, repositories, providers
- Widget tests for all screens and reusable widgets
- Integration tests for critical user flows
- Maintain ≥80% code coverage

### Documentation
- Update relevant documentation with each change
- Keep README.md current
- Document public APIs with dartdoc comments

---

## Important Notes

1. **Never skip the git hook** – Commit message format is enforced
2. **Never push directly to main** – All changes via PR
3. **Never merge without CI passing** – Tests and coverage must pass
4. **Always create an issue first** – No work without tracking
5. **Always update documentation** – Part of acceptance criteria
6. **Always maintain 80% coverage** – Part of acceptance criteria
