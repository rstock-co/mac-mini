---
name: apple-docs
description: |
  Fetch official Apple developer documentation using the apple_docs.py tool. Use for Xcode, SwiftUI, UIKit, Swift, iOS SDK, and any Apple framework documentation. Converts Apple's JSON API docs to clean Markdown.
---

# Apple Developer Documentation

Fetch official Apple docs and convert them to Markdown using the `apple_docs.py` tool.

## When to Use

- Need Xcode documentation
- Looking up SwiftUI, UIKit, Swift, or any Apple framework
- Need iOS/macOS SDK reference
- Building mobile apps and need API docs
- Any question about Apple development APIs

## The Tool

**Location:** `/home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py`

This Python script fetches documentation directly from Apple's developer JSON API at `https://developer.apple.com/tutorials/data/documentation/` and converts it to clean, readable Markdown.

## Usage

### Single Page
```bash
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py <path> -o <output-dir>
```

**Examples:**
```bash
# SwiftUI State
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py swiftui/state -o /tmp/docs/

# UIKit UIViewController
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py uikit/uiviewcontroller -o /tmp/docs/

# Xcode
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py xcode -o /tmp/docs/
```

### Multiple Pages
```bash
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py swiftui/state swiftui/binding -o /tmp/docs/
```

### Bundle Mode (Hub + All Sub-pages)
```bash
# Fetch a topic page and ALL its linked sub-pages into one file
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py --bundle swiftui/model-data -o /tmp/state-management.md
```

### List Mode (Dry Run)
```bash
# See what a hub page links to before fetching everything
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py --list swiftui/model-data
```

## Common Documentation Paths

### Xcode
- `xcode` - Xcode overview
- `xcode/build-system` - Build system
- `xcode/debugging` - Debugging tools
- `xcode/testing` - XCTest framework

### SwiftUI
- `swiftui` - SwiftUI overview
- `swiftui/state` - @State property wrapper
- `swiftui/binding` - @Binding
- `swiftui/observedobject` - @ObservedObject
- `swiftui/environmentobject` - @EnvironmentObject
- `swiftui/view` - View protocol
- `swiftui/list` - List view
- `swiftui/navigationstack` - Navigation

### UIKit
- `uikit` - UIKit overview
- `uikit/uiviewcontroller` - View controllers
- `uikit/uitableview` - Table views
- `uikit/uicollectionview` - Collection views

### Swift
- `swift` - Swift language
- `swift/array` - Array type
- `swift/string` - String type
- `swift/codable` - Codable protocol

### Foundation
- `foundation` - Foundation framework
- `foundation/urlsession` - Networking
- `foundation/jsonencoder` - JSON encoding

### Other Frameworks
- `combine` - Reactive framework
- `coredata` - Data persistence
- `swiftdata` - Modern data framework
- `realitykit` - AR/3D
- `mapkit` - Maps
- `avfoundation` - Audio/Video

## Workflow

### When user asks about an Apple API:

1. **Identify the framework and class/protocol** from the question
2. **Run the tool** to fetch the docs:
   ```bash
   python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py <framework>/<class> -o /tmp/docs/
   ```
3. **Read the generated Markdown** from the output directory
4. **Answer the question** using the official documentation

### When user needs a broad overview:

1. **Use list mode** to see what's available:
   ```bash
   python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py --list <framework>
   ```
2. **Use bundle mode** for comprehensive docs:
   ```bash
   python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py --bundle <framework>/<topic> -o /tmp/docs/
   ```

### When user is building an iOS app:

1. Identify the relevant frameworks (SwiftUI, UIKit, etc.)
2. Fetch docs for the specific APIs being used
3. Reference the generated Markdown for accurate API signatures, parameters, and examples

## Important Notes

- The tool uses Apple's live JSON API - docs are always current
- Output is clean Markdown, perfect for LLM consumption
- Bundle mode fetches in parallel (6 workers) for speed
- 15-second timeout per request
- Always check `--list` first for large topics to avoid massive downloads
