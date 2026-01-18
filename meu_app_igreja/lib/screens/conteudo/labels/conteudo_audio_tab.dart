// -----------------------------------------------------------------------------
// Importações principais
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // biblioteca para áudio

// -----------------------------------------------------------------------------
// ConteudoAudioTab
// Aba de áudio do conteúdo, com player estilo YouTube/IGTV.
// Permite:
// - Play/Pause
// - Avançar/Retroceder 10s
// - Barra de progresso com tempo atual/total
// - Integração com callback onSalvarProgresso
// -----------------------------------------------------------------------------
class ConteudoAudioTab extends StatefulWidget {
  final Function(double progresso) onSalvarProgresso;

  const ConteudoAudioTab({super.key, required this.onSalvarProgresso});

  @override
  State<ConteudoAudioTab> createState() => _ConteudoAudioTabState();
}

class _ConteudoAudioTabState extends State<ConteudoAudioTab> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Exemplo de áudio local ou remoto
    _player.setUrl(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    );

    // Atualiza posição do áudio em tempo real
    _player.positionStream.listen((pos) {
      setState(() {
        _position = pos;
        // salva progresso como valor entre 0.0 e 1.0
        if (_duration.inMilliseconds > 0) {
          final progresso = pos.inMilliseconds / _duration.inMilliseconds;
          widget.onSalvarProgresso(progresso);
        }
      });
    });

    // Captura duração total do áudio
    _player.durationStream.listen((d) {
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Barra de progresso
          Slider(
            value: _position.inMilliseconds.toDouble(),
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(milliseconds: value.toInt()));
            },
            activeColor: const Color(0xFFDE6D56),
            inactiveColor: Colors.grey,
          ),
          // Tempo atual / duração
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Controles do player
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white),
                onPressed: () {
                  final newPos = _position - const Duration(seconds: 10);
                  _player.seek(newPos > Duration.zero ? newPos : Duration.zero);
                },
              ),
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final playing = playerState?.playing ?? false;
                  return IconButton(
                    icon: Icon(
                      playing ? Icons.pause_circle : Icons.play_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: () {
                  final newPos = _position + const Duration(seconds: 10);
                  _player.seek(newPos < _duration ? newPos : _duration);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
