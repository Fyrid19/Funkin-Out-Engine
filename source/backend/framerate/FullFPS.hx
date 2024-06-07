package backend.framerate;

import openfl.Assets;
import openfl.display.Sprite;
import backend.framerate.FPSCounter;
import backend.framerate.MemoryCounter;

class FullFPS extends Sprite {
    public static var fpsFont:String;

    public var fpsCount:FPSCounter;
    public var memCount:MemoryCounter;

    var offset:Array<Float> = [2, 2];

    public function new() {
        super();

        fpsFont = Assets.getFont('assets/fonts/vcr.ttf').fontName;

        fpsCount = new FPSCounter();
        memCount = new MemoryCounter();

        memCount.y = fpsCount.y + fpsCount.height + 2;

        addChild(fpsCount);
        addChild(memCount);

        x = offset[0];
        y = offset[1];
    }
}