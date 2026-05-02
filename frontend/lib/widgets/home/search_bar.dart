import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          leading: const Icon(Icons.search),
          hintText: 'Search weapons and artifacts here!',
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          const ListTile(title: Text("Suggestion 1")),
          const ListTile(title: Text("Suggestion 2")),
        ];
      },
    );
  }
}
