Plan: Flutter dev tasks and implementation checklist

Objective

Collect and implement the requested changes and demo pages in the `gsy_flutter_demo` project. Produce small, self-contained, no-third-party demos for:

- ButtonStyle & MaterialStateProperty技巧
- ThemeExtensions使用技巧
- 网络图片加载演示（带本地缓存接口设计）
- 自定义RenderObject实现自定义Column
- OverlayPortal 演示页面及在 `main.dart` 新增跳转项
- 跨页面悬浮球（永久悬浮、不能拖出屏幕）
- 左侧分类 ListView 与右侧详情 ListView 联动（右侧 item 高度不定）
- Demo wiring in `main.dart` (add items for each new demo)
- Minor dev-environment notes / lints (ctrl+/ behavior, const/new lints, running on Android only)

Assumptions

- Project root: C:\flutter_work\gsy_flutter_demo
- `lib/main.dart` exists and follows the current project's navigation items pattern.
- Use only Flutter built-in libraries (no third-party packages allowed).
- Terminal: PowerShell 7. Device: Android emulator. Tests / run instructions will match PowerShell 7 syntax.

Contract (inputs / outputs / success criteria)

- Inputs: existing project code under `lib/` and `lib/main.dart` navigation list.
- Outputs: new dart files in `lib/` (one per demo) and `main.dart` entry items added.
- Success: apps compile and run on Android emulator with no errors; each demo page runs and demonstrates the requested behavior.

High-level checklist

1. Create a plan file (this file) — Done.
2. Add demo pages (one Dart file per demo) and wire navigation items in `lib/main.dart`.
   - ButtonStyle demo
   - ThemeExtensions demo
   - NetworkImage-like cached image widget demo
   - Custom RenderObject Column demo
   - OverlayPortal demo + main navigation
   - Cross-page floating ball demo
   - Left-right category-detail linked lists demo (variable right-side heights)
3. Implement logic details (explain per demo in each file):
   - No third-party libs; implement caching using local filesystem via Flutter `dart:io` + `Image.memory`.
   - Cross-page floating ball backed by a top-level Overlay entry created at app root; ensure it's re-used across routes.
   - Prevent ball being dragged outside screen bounds.
   - Left/Right link: right side uses SliverList/CustomScrollView with keyed GlobalKeys per category and measures item positions via RenderObject/Sliver/ScrollController; expose callback when visible category changes.
   - CustomRenderObject: implement a minimal RenderBox-based Column (layout/performLayout/paint/hitTest)
4. Add tests or smoke run steps: quick run to ensure compile on Android emulator (PowerShell 7). Steps provided per demo.
5. Lint/config: document how to modify analysis_options.yaml to disable const/new reminders or specific lint rules; also document how to change keybinding for ctrl+/ default to /// if desired (editor-level change — explained for VS Code/Android Studio).
6. Quality gates: Build, lint (or note changes), run each demo page manually. If errors, iterate.

Per-demo details and implementation plan

A. ButtonStyle & MaterialStateProperty demo
- File: lib/demo/button_style_material_state_demo.dart
- Show: ElevatedButton/OutlinedButton custom styles via ButtonStyle and MaterialStateProperty.resolveWith; show pressed/hover/focused states.
- No third-party libs.
- Test: open page, interact with buttons to see different visuals.

B. ThemeExtensions demo
- File: lib/demo/theme_extensions_demo.dart
- Show: Define custom ThemeExtension class, extend ThemeData, read via Theme.of(context).extension<T>() and demonstrate light/dark switch
- Test: toggle a switch to change ThemeData and observe extension-provided values changing.

C. NetworkImage-like cached image widget demo
- File: lib/demo/cached_network_image_demo.dart
- Implement a widget `SimpleCachedNetworkImage` that:
  - Uses `HttpClient` (dart:io) to download image bytes to the app's temporary directory.
  - Uses `File` to check cache; `Image.memory` to display bytes; fallback to placeholder while loading.
  - Expose cache key policy and simple TTL.
- Test: open page, images load and subsequent reloads use local cache.

D. CustomRenderObject Column demo
- File: lib/demo/custom_column_demo.dart
- Implement a `RenderCustomColumn` / `CustomColumn` widget that lays children vertically with simple spacing, supporting intrinsic sizing minimal, and example usage with colored boxes.
- Ensure paint, performLayout, and hitTest are implemented.
- Test: open page, verify layout identical to Column for simple cases.

E. OverlayPortal demo & main navigation item
- File: lib/demo/overlay_portal_demo.dart
- Implement an `OverlayPortal` demo that shows usage of `Overlay.of(context).insert` and `OverlayEntry`, plus a small portal content anchored to a widget.
- Add a `main.dart` item: "OverlayPortal 演示"
- Test: open page, tap to show overlay, dismiss.

F. Cross-page floating ball (persistent) demo
- File: lib/demo/persistent_floating_ball.dart
- Implement a top-level manager (e.g., `FloatingBallController`) that inserts an OverlayEntry at app root (MaterialApp builder) so it persists across route pushes.
- Ball constraints: detect device size via MediaQuery and clamp offsets so ball cannot be dragged outside; animate to keep within safe area on release.
- Integrate a toggle in main or example page to show/hide ball.
- Test: navigate between pages and verify ball remains visible and cannot be dragged out of screen.

G. Left-right ListView linked demo (variable heights on right)
- File: lib/demo/category_detail_linked_demo.dart
- Approach:
  1. Left: a fixed width ListView of categories. OnTap scrolls the right ScrollController to the offset computed for that category.
  2. Right: a CustomScrollView / SliverList where section headers are GlobalKeys or we measure item positions using `RenderObject` size/position (WidgetsBinding.instance.addPostFrameCallback and `context.findRenderObject` + `renderObject.getTransformTo(null)` + `globalToLocal`).
  3. Because right side item heights vary, compute each section's offset by summing measured heights of previous sections. Recompute on layout change (listen to changes via `ResizeObserver` equivalent: use `WidgetsBinding.instance.addPostFrameCallback` after setState or use `LayoutBuilder` + `onChange` pattern with `GlobalKey` per section).
  4. Right scroll listener: when scroll offset crosses section thresholds, call the exposed callback to notify outer widget of active category.
- Expose callback: `ValueChanged<int> onCategoryChanged` which is invoked when the currently visible section index changes.
- Test: tap left category -> right scrolls to the correct header; manually scroll right -> left selection updates.

H. Analysis options / lint changes (const/new / ctrl+/ behaviour)
- To remove lint warnings for `avoid_init_to_null` or to disable specific rules (e.g., prefer_const_constructors, avoid_redundant_constructors): edit `analysis_options.yaml` at project root and add rules to `linter` -> `rules` with false values, for example:
  linter:
    rules:
      prefer_const_constructors: false
      avoid_redundant_argument_values: false
- Editor keybinding ctrl+/ default comment behaviour is an IDE/editor-level action. To change default toggle comment from `//` to `///` requires customizing the editor's comment toggle or creating a custom keybinding/IDE plugin; note: Android Studio/IntelliJ or VS Code do not have built-in toggle to switch to `///` globally — will document steps for VS Code/IntelliJ and a simple macro approach.

I. Environment/run notes
- PowerShell 7: use semicolon `;` to separate commands rather than `&&` when necessary in scripts. For PowerShell, `;` works; use `Start-Process` or `cmd /c` for complex flows.
- Ensure `flutter run -d <deviceId>` runs on Android emulator by selecting device or passing device id.
- For run commands I will provide PowerShell 7 formatted commands.

Quality gates

- Build: Run `flutter build apk` (or `flutter run` on emulator) and ensure no compile errors.
- Lint: If lints are adjusted, check `dart analyze` results; aim for no new errors.
- Manual tests: 1) open each demo page; 2) exercise interactive pieces (dragging ball, overlay, list linking); 3) ensure no exceptions at runtime.

Files to create (one-per-demo)

- lib/demo/button_style_material_state_demo.dart
- lib/demo/theme_extensions_demo.dart
- lib/demo/cached_network_image_demo.dart
- lib/demo/custom_column_demo.dart
- lib/demo/overlay_portal_demo.dart
- lib/demo/persistent_floating_ball.dart
- lib/demo/category_detail_linked_demo.dart
- Update: lib/main.dart (insert navigation items pointing to above pages)

Next steps (implementation)

1. Add navigation items to `lib/main.dart` for all demos.
2. Implement simple versions of each demo file (start with the easiest: ButtonStyle, ThemeExtensions, OverlayPortal).
3. Implement persistent overlay ball and ensure insertion point is MaterialApp.builder or a top-level `Navigator` overlay.
4. Implement left-right linked lists with measuring logic and exposed callback.
5. Implement custom RenderObject Column and test edge cases (intrinsic sizes, hit testing).
6. Implement SimpleCachedNetworkImage using `dart:io` and test caching behavior.
7. Run `flutter analyze`, `flutter test` (if any tests), and manual `flutter run -d <android-device-id>` in PowerShell 7 to verify.

Notes / Risks

- Measuring variable height content reliably requires re-measuring when dynamic content changes (images loaded, network data arrival). Implement re-measure triggers after frame if size might change.
- Persistent overlay must be inserted at a place where `Overlay.of(context)` is the app root overlay (use `builder` in MaterialApp); otherwise new routes may replace overlays.
- File I/O for caching may require android permissions for persistent directories; use `getTemporaryDirectory()` or app's cache directory.
- Changing editor's ctrl+/ toggle to produce `///` is normally not supported out-of-the-box; will document workaround.

Deliverable

- This plan saved as `plan-flutterDevTasksPlan.prompt.md` in the project root for further refinement.


-- End of plan --

