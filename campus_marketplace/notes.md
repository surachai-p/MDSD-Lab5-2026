Search box: Ephemeral State
- Decision: The search query is Ephemeral State and kept local to `HomePage` using `setState`.
- Reason: No other screen in the app needs access to the current search query, so a lightweight local state is sufficient and avoids unnecessary global complexity.

Clear all favorites: App State access via Provider
- Implementation: The Favorites list is global app state (`FavoritesModel` provided via Provider).
- Visibility: `context.watch<FavoritesModel>()` is used in `FavoritesPage` to rebuild and decide whether to show the clear button (only when there is at least one favorite).
- Action: `context.read<FavoritesModel>()` is used to call `clear()` inside the confirmation dialog's confirmation handler because the action is a one-off command and does not need to subscribe the widget to further updates.

Notes on Riverpod trial
- (Optional) If porting to Riverpod, the same principles apply: keep search query as local state in the widget (use `StatefulWidget` or `StateProvider` only if global access is required), and use Riverpod's `ref.watch` to read favorites for visibility and `ref.read(...).clear()` for one-off actions.
