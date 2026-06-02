import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/surah_bloc/surah_list_bloc.dart';
import '../utils/app_theme.dart';

class SurahSearchBar extends StatefulWidget {
  const SurahSearchBar({super.key});

  @override
  State<SurahSearchBar> createState() => _SurahSearchBarState();
}

class _SurahSearchBarState extends State<SurahSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<SurahListBloc>().add(SurahListSearchChanged(value));
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    context.read<SurahListBloc>().add(const SurahListSearchCleared());
    setState(() {});
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      style: AppTheme.titleMedium,
      decoration: InputDecoration(
        hintText: 'Search by name or number…',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: _onClear,
              )
            : null,
      ),
    );
  }
}
