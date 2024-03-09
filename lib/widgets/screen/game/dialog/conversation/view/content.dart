import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/colors.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/base_overlay.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/conversation/view/message.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

class GameConversationContent extends StatefulWidget {
  final GameComponent game;
  final ConversationType type;

  const GameConversationContent({
    super.key,
    required this.game,
    required this.type,
  });

  @override
  State<GameConversationContent> createState() => _GameConversationContentState();
}

class _GameConversationContentState extends State<GameConversationContent> {
  int _index = 0;
  int _messageIndex = 0;

  _onTap() {
    if (_isLastMessage) {
      if (_isLastConversation) {
        Navigator.of(context).pop();
        return;
      }

      setState(() {
        _index++;
        _messageIndex = 0;
      });

      return;
    }

    setState(() {
      _messageIndex++;
    });
  }

  bool get _isLastMessage {
    final conversation = widget.type.data[_index];
    if (_messageIndex == conversation.messages.length - 1) return true;
    return false;
  }

  bool get _isLastConversation {
    if (_index == widget.type.data.length - 1) return true;
    return false;
  }

  String get _currentMessage {
    try {
      return widget.type.data[_index].messages[_messageIndex];
    } catch (_) {
      return "";
    }
  }

  String get _image {
    try {
      final message = widget.type.data[_index];
      switch (message.speaker) {
        case ConversationSpeaker.captainDash:
          return "assets/images/dash.jpeg";
        case ConversationSpeaker.shipBot:
          return "assets/images/dartina.jpeg";
        case ConversationSpeaker.planetPresident:
          return "assets/images/president.jpeg";
      }
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.paddingOf(context);
    return GameBaseOverlay(
      game: widget.game,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _onTap,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 300,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(1.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16 + p.bottom,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: GameConstants.borderWidth,
                        color: GameColors.white,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(_image),
                        child: _image != "" ? Image(image: AssetImage(_image)) : Container(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: GameColors.darker,
                        border: Border.all(
                          color: GameColors.white,
                          width: GameConstants.borderWidth,
                        ),
                      ),
                      child: MovingMessage(
                        message: _currentMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
