import 'package:group_buy_app/screens/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/boards.dart';
import '../providers/auth.dart';
import '../providers/notifications.dart';
import '../widgets/app_drawer.dart';

class MainScreen extends StatelessWidget {
  Future<void> _refreshBoards(BuildContext context) async {
    await Provider.of<Board_List>(context, listen: false).fetchAndSetBoards();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판 목록'),
      ),
      body: FutureBuilder(
        future: _refreshBoards(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Consumer<Board_List>(
          builder: (ctx, boardsData, _) => Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: boardsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          BoardScreen.routeName,
                          arguments: BoardScreenArguments(
                              boardsData.items[i].id,
                              boardsData.items[i].name),
                        );
                      },
                      child: Text(boardsData.items[i].name),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

// board_screen에 전달할 arguments
class BoardScreenArguments {
  final String boardId;
  final String boardName;

  BoardScreenArguments(this.boardId, this.boardName);
}