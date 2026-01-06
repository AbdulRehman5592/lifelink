import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LifeLinkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const LifeLinkAppBar({
    super.key,
    this.showBackButton = false,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      leading: _buildLeading(context),
      title: _buildTitle(),
      actions: actions ?? _buildDefaultActions(),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black54),
        onPressed: () => Navigator.pop(context),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Icon(Icons.favorite, color: Color(0xFF00A89D), size: 32),
    );
  }

  Widget _buildTitle() {
    if (title != null) {
      return Row(
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title!,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF00A89D),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'LifeLink',
              style: GoogleFonts.poppins(
                color: const Color(0xFF00A89D),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      const Icon(Icons.location_on_outlined, color: Colors.black54),
      const SizedBox(width: 4),
      Text(
        'Lahore, Pakis...',
        style: GoogleFonts.poppins(color: Colors.black54),
      ),
      const SizedBox(width: 16),
      const Icon(Icons.notifications_none, color: Colors.black54),
      const SizedBox(width: 16),
      const Icon(Icons.menu, color: Colors.black54),
      const SizedBox(width: 16),
    ];
  }
}
