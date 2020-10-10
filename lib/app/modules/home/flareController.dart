import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';

class WareController extends FlareControls{
  ActorNode actorNode ;
  int modifier = 0;
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    actorNode.y -= modifier;

    return true;
  }

  increament(){
    modifier++;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    play('Untitled');

    actorNode = artboard.getNode('Ware');
  }

}