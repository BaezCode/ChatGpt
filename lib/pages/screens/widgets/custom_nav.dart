import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNav extends StatelessWidget {
  final int index;

  const CustomNav({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          canvasColor: const Color(0xfff20262e)),
      child: SizedBox(
        height: 100,
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(color: Color(0xfff20262e), fontSize: 14),
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          currentIndex: index,
          onTap: chatBloc.selectedIndex,
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(
                CupertinoIcons.square_split_2x2_fill,
                color: Colors.white,
                size: 25,
              ),
              icon: Icon(
                CupertinoIcons.square_split_2x2,
                color: Colors.white,
                size: 25,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                CupertinoIcons.bubble_left_bubble_right_fill,
                color: Colors.white,
                size: 25,
              ),
              icon: Icon(
                CupertinoIcons.bubble_left_bubble_right,
                color: Colors.white,
                size: 25,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 25,
              ),
              icon: Icon(
                Icons.workspace_premium_outlined,
                color: Colors.white,
                size: 25,
              ),
              label: 'Premium',
            ),
          ],
        ),
      ),
    );
  }
}
