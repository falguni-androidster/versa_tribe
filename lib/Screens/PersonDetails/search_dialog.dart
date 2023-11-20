import 'package:flutter/material.dart';
import 'package:versa_tribe/Utils/custom_string.dart';

class SearchPopupScreen extends StatefulWidget {
  const SearchPopupScreen({super.key});
  @override
  State<SearchPopupScreen> createState() => _SearchPopupScreenState();
}

class _SearchPopupScreenState extends State<SearchPopupScreen> {

  final TextEditingController _searchController = TextEditingController();

  List<String> items = List.generate(50, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(CustomString.searchTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
                labelText: CustomString.searchContentLabel,
                hintText: CustomString.searchContentHint,
                suffixIcon: IconButton(icon: const Icon(Icons.search),onPressed: (){},)
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                // Add filtering logic based on the search input
                if (_searchController.text.isNotEmpty &&
                    !item.contains(_searchController.text)) {
                  return const SizedBox.shrink(); // Hide items that don't match the search
                }
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    // Handle item selection here
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Handle continue button press here
              Navigator.of(context).pop();
            },
            child: const Text(CustomString.buttonContinue),
          ),
        ],
      ),
    );
  }
}
