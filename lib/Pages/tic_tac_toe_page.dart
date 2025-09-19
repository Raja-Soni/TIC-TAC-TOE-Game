import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppColors/app_colors.dart';
import '../CustomWidgets/import_all_custom_widgets.dart';
import '../Provider/game_provider.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<GameProvider>();

    if (provider.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!provider.resultMessage.toLowerCase().contains("draw")) {
          _confettiController.play();
        }
        _showGameOverDialog(provider);
      });
    }
  }

  void _showGameOverDialog(GameProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: AppColors.winnerCelebrationColor,
          ),
          AlertDialog(
            backgroundColor: AppColors.whiteColor,
            title: CustomText(
              text: provider.resultMessage,
              textSize: 24,
              textBoldness: FontWeight.bold,
              textColor: AppColors.winnerTextColor,
            ),
            content: CustomText(
              text: "Would you like to play again?",
              textSize: 18,
              textColor: AppColors.blackColor,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.cancelColor,
                ),
                onPressed: () {
                  provider.resetEverything();
                  Navigator.pop(ctx);
                },
                child: CustomText(
                  text: 'Restart',
                  textColor: AppColors.whiteColor,
                  textSize: 16,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.confirmColor,
                ),
                onPressed: () {
                  provider.restartKeepScore();
                  Navigator.pop(ctx);
                },
                child: CustomText(
                  text: 'Next Match',
                  textColor: AppColors.whiteColor,
                  textSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    Widget buildCell(int index) {
      final value = provider.board[index];
      final isWinningCell = provider.winningIndices.contains(index);

      return CustomAnimatedContainer(
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: isWinningCell
            ? AppColors.winnerTileColor
            : AppColors.whiteColor,
        borderWidth: 1.5,
        borderColor: AppColors.animatedContainerBorderColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: provider.currentPlayer == 'X'
                ? AppColors.xPlayerSplashColor
                : AppColors.yPlayerColor,
            onTap: () => provider.playMove(index),
            child: Center(
              child: CustomText(
                text: value.toString(),
                textSize: 56,
                textBoldness: FontWeight.bold,
                textColor: value == 'X'
                    ? AppColors.xPlayerColor
                    : AppColors.yPlayerColor,
              ),
            ),
          ),
        ),
      );
    }

    Widget buildBoard() => AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) => buildCell(index),
      ),
    );

    Widget scoreTile(String title, int val) => Column(
      children: [
        CustomText(
          alignment: TextAlign.center,
          text: title,
          textSize: 22,
          textColor: AppColors.blackColor,
          textBoldness: FontWeight.bold,
        ),
        const SizedBox(height: 6),
        CustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Colors.blueGrey.shade300,
          borderRadius: 12,
          child: CustomText(
            text: val.toString(),
            textSize: 20,
            textBoldness: FontWeight.w600,
            textColor: AppColors.whiteColor,
          ),
        ),
      ],
    );

    Widget scoreRow() {
      final score = provider.score;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          scoreTile('Player X\nWins', score['X'] ?? 0),
          scoreTile('Draws', score['Draws'] ?? 0),
          scoreTile('Player O\nWins', score['O'] ?? 0),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.ticTacToePageBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: 'Tic-Tac-Toe',
          textSize: 30,
          textColor: AppColors.whiteColor,
          textBoldness: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.appBarColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CustomText(
                text: '${provider.currentPlayer} Player\'s turn',
                textSize: 28,
                textBoldness: FontWeight.bold,
                textColor: AppColors.blackColor,
              ),
              SizedBox(height: 6),
              scoreRow(),
              SizedBox(height: 14),
              buildBoard(),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                ),
                onPressed: provider.undo,
                icon: Icon(Icons.undo, color: AppColors.whiteColor),
                label: CustomText(
                  text: 'Undo Last Move',
                  textSize: 18,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
