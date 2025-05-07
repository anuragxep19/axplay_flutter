import 'package:flutter/material.dart';
import 'package:axplay/utils/responsive.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 50.s, bottom: 20.s),
            height: 150.s,
            child: Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 80.s,
                color: Colors.white,
              ),
            ),
          ),
          _IconText(
            title: 'Home',
            icon: Icons.home_outlined,
            onTap: () => Navigator.of(context).pop(),
          ),
          _IconText(
            onTap: () {},
            icon: Icons.settings_outlined,
            title: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _IconText({
    required this.title,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(10.s),
        margin: EdgeInsets.all(5.s),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 30.s,
            ),
            SizedBox(width: 30.s),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 20.s)),
          ],
        ),
      ),
    );
  }
}
