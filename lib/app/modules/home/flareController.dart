import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';

class WareController extends FlareControls {
  ActorNode actorNode;

  int modifier = 0;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    actorNode.y -= modifier;

    return true;
  }

  increament() {
    modifier++;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    play('Untitled');

    actorNode = artboard.getNode('Ware');
  }
}
class OpenController extends FlareControls {

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);

    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
  }

  click() {
    play('Run', mix: 1, mixSeconds: 0.5);
  }
}
  class FlareDLController extends FlareControls {
  double _duration =0;
  int _looping = 2;
  bool _isActive = false;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    _duration += elapsed;
    if (_isActive) {
      if (_duration > 1000 * _looping) {
        _isActive = false;
        return false;
      }
    }

    return true;
  }

  setNewComponent() {
    _isActive = true;
  }

  bool get IsActive => _isActive;

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
   play('Aura');
  }

}
