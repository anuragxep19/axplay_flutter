import 'package:flutter/material.dart';
import 'package:axplay/utils/responsive.dart';
import 'package:axplay/view/home/widget/custom_drawer.dart';
import 'package:axplay/view/home/widget/video_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            // Match the screen size
            width: double.infinity,
            height: double.infinity,
            // Apply the gradient decoration
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color.fromARGB(255, 39, 70, 248),
                  Color.fromARGB(255, 41, 247, 243),
                ],
              ),
            ),
          ),
          CustomScrollView(slivers: [_SilverAppBar(), VideoList()]),
        ],
      ),
    );
  }
}

class _SilverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 32.0.s),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
      expandedHeight: MediaQuery.of(context).size.width * 1 / 3,
      floating: true,
      snap: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 300),
          child: Text(
            "AxPlay",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 39, 70, 248),
                Color.fromARGB(255, 41, 247, 243),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
