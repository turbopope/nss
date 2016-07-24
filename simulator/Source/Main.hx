import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.Event.RESIZE;
import openfl.events.Event.ENTER_FRAME;
import openfl.events.MouseEvent.CLICK;
import openfl.events.KeyboardEvent.KEY_DOWN;
import openfl.ui.Keyboard;


class Main extends Sprite
{
    static inline var WIDTH  = 1920.0;
    static inline var HEIGHT = 1080.0;

    static inline var NODES  = 200;
    static inline var MIN_K  = 1;
    static inline var MAX_K  = 5;
    static inline var UNIT_DISC_RADIUS = 200;

    static inline var MIN_IMPULSE_COUNT = 10;
    static inline var MAX_IMPULSE_COUNT = 20;

    var content = new Sprite();
    var nodes   = new Array<Node>();
    var time    = 0.0;
    var scale   = 0.0;
    var step    = 0.0;

    public function new()
    {
        super();
        addChild(content);

        for (i in 0 ... NODES) {
            var node = new Node(Math.random(), false);
            node.x   = WIDTH  * Math.random();
            node.y   = HEIGHT * Math.random();
            content.addChild(node);
            nodes.push(node);

            node.buttonMode = true;
            node.addEventListener(CLICK, function (_) {
                node.state = !node.state;
            });
        }

        for (node in nodes) {
            var nodesLeft = nodes.copy();
            nodesLeft.remove(node);
            for (n in node.neighbors) {
                nodesLeft.remove(n);
            }

            for (other in nodesLeft.copy()) {
                if (node.distanceTo(other) > UNIT_DISC_RADIUS) {
                    nodesLeft.remove(other);
                }
            }

            var k = rand(MIN_K, MAX_K);
            for (i in 0 ... Std.int(Math.min(k, nodesLeft.length))) {
                var neighbor = nodesLeft[Std.random(nodesLeft.length)];
                nodesLeft.remove(neighbor);
                node.addNeighbor(neighbor);
                neighbor.addNeighbor(node);
            }

            content.addChildAt(node.lines, 0);
        }

        stage.addEventListener(KEY_DOWN, onKey);

        stage.addEventListener(RESIZE, resize);
        resize();

        addEventListener(ENTER_FRAME, onFrame);
    }


    function onKey(e)
    {
        switch (e.keyCode) {
            case Keyboard.S: {
                ++step;
            }
            case Keyboard.C: {
                for (n in nodes) {
                    n.checkState();
                }
            }
            case Keyboard.I: {
                impulse();
            }
            case Keyboard.UP: {
                scale += 0.01;
            }
            case Keyboard.DOWN: {
                scale = Math.max(0, scale - 0.01);
            }
            case Keyboard.SPACE: {
                scale = 0;
            }
        }
    }


    function onFrame(_)
    {
        var prev = Std.int(time);
        time += scale + step;
        step  = 0;

        var t = Std.int(time) - prev;
        for (n in nodes) {
            n.step(t);
        }
    }


    function impulse()
    {
        var impulses  = rand(MIN_IMPULSE_COUNT, MAX_IMPULSE_COUNT);
        var nodesLeft = nodes.copy();
        for (i in 0 ... impulses) {
            var node = nodesLeft[Std.random(nodesLeft.length)];
            nodesLeft.remove(node);
            node.state = true;
        }
    }


    function resize(?e:Event)
    {
        content.scaleX = stage.stageWidth  / WIDTH;
        content.scaleY = stage.stageHeight / HEIGHT;
    }


    public static function rand(min:Int, max:Int)
    {
        return Std.random(max - min + 1) + min;
    }
}
