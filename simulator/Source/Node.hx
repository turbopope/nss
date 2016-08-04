import Main.rand;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

using Lambda;


class Node extends Sprite
{
    static inline var MIN_DELAY = 1;
    static inline var MAX_DELAY = 30;

    static var blue:BitmapData;
    static var red :BitmapData;

    public var tau      (default, null):Float;
    public var state    (default, set ):Bool;
    public var lines    (default, null):Sprite;
    public var neighbors(default, null) = new Array<Node>();

    var check    = 0;
    var checking = false;
    var oldState = false;
    var bitmap:Bitmap;

    public function new(tau:Float, state:Bool)
    {
        super();

        if (blue == null) {
            blue = new BitmapData(8, 8, false, 0x0000ff);
        }
        if (red == null) {
            red = new BitmapData(8, 8, false, 0xff0000);
        }

        bitmap = new Bitmap(blue);
        bitmap.x = bitmap.width  / -2;
        bitmap.y = bitmap.height / -2;
        addChild(bitmap);

        this.tau   = tau;
        this.state = state;
        this.lines = new Sprite();

        lines.graphics.lineStyle(1, 0);
        lines.alpha = 0.1;

        nextCheck();
    }


    function nextCheck()
    {
        check = rand(MIN_DELAY, MAX_DELAY) + check;
    }


    function set_state(s:Bool):Bool
    {
        state = s;
        var bmp = state ? red : blue;
        if (bmp != bitmap.bitmapData) {
            bitmap.bitmapData = bmp;
        }
        return state;
    }

    public function checkState()
    {
        if (checking) {
            lines.alpha = 0.5;
            scaleX = scaleY = 2;

            var active = neighbors.count(function (n) { return n.state; });
            state      = active / neighbors.length >= tau;
            rotation   = state == oldState ? 0 : 45;
        }
    }


    public function addNeighbor(n:Node)
    {
        neighbors.push(n);
        lines.graphics.moveTo(x, y);
        lines.graphics.lineTo(n.x, n.y);
    }


    public function step(t:Int)
    {
        check -= t;
        if (check <= 0) {
            checking = true;
            oldState = state;
            checkState();
            nextCheck();
        }
        else if (t > 0 && checking) {
            checking = false;
            lines.alpha = 0.1;
            scaleX = scaleY = 1;
            rotation = 0;
        }
    }

    public function distanceTo(other:Node)
    {
      var x = this.x - other.x;
      var y = this.y - other.y;
      return Math.sqrt(x*x + y*y);
    }
}
