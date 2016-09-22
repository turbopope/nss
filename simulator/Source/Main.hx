import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.Event.RESIZE;
import openfl.events.Event.ENTER_FRAME;
import openfl.events.MouseEvent.CLICK;
import openfl.events.MouseEvent.MOUSE_OUT;
import openfl.events.MouseEvent.MOUSE_OVER;
import openfl.events.KeyboardEvent.KEY_DOWN;
import openfl.Lib;
import openfl.ui.Keyboard;


class Main extends Sprite
{
    var contentWidth  = 1920.0;
    var contentHeight = 1080.0;

    static inline var INFO_TEXT = "[Space] play/pause [Q] faster [W] slower "
                                + "[S] single step [I] trigger random impulse "
                                + "[H] hide this help [R] reset";

    static inline var MIN_NODES = 100;
    static inline var MAX_NODES = 300;

    var MIN_K  = 1;
    var MAX_K  = 5;
    var UNIT_DISC_RADIUS = 200;
    var MIN_NODE_DISTANCE = 32;

    var MIN_IMPULSE_COUNT = 10;
    var MAX_IMPULSE_COUNT = 20;

    var info:Info;

    var content = new Sprite();
    var nodes   = new Array<Node>();
    var time    = 0.0;
    var scale   = 0.0;
    var step    = 0.0;
    var speed   = 0.1;

    public function new()
    {
        super();
        addChild(content);

        setUpNodes();

        stage.addEventListener(KEY_DOWN, onKey);
        stage.addEventListener(RESIZE, resize);
        resize();

        addEventListener(ENTER_FRAME, onFrame);
    }


    function setUpNodes()
    {
        var nodeCount = Std.random(MAX_NODES - MIN_NODES + 1) + MIN_NODES;

        info      = new Info();
        info.text = INFO_TEXT;

        for (i in 0 ... nodeCount) {
            var node = new Node(Math.random(), false);
            do {
                node.x = contentWidth  * Math.random();
                node.y = contentHeight * Math.random();
            } while(nodeTooClose(node, nodes));
            content.addChild(node);
            nodes.push(node);

            node.buttonMode = true;
            node.addEventListener(CLICK, function (_) {
                node.state = !node.state;
                info.text  = node.dump();
            });

            node.addEventListener(MOUSE_OVER, function (_) {
                info.text = node.dump();
            });

            node.addEventListener(MOUSE_OUT, function (_) {
                info.text = INFO_TEXT;
            });
        }

        for (node in nodes) {
            var potentialNeighbors = nodes.copy();
            potentialNeighbors.remove(node);
            for (n in node.neighbors) {
                potentialNeighbors.remove(n);
            }

            for (other in potentialNeighbors.copy()) {
                if (node.distanceTo(other) > UNIT_DISC_RADIUS) {
                    potentialNeighbors.remove(other);
                }
            }

            for (other in potentialNeighbors) {
                var toTest = nodes.copy();
                toTest.remove(other);
                toTest.remove(node);
                if (connectingCircleEmpty(node, other, toTest)) {
                    node.addNeighbor(other);
                    other.addNeighbor(node);
                }
            }

            content.addChildAt(node.lines, 0);
        }

        content.addChild(info);
    }


    function reset() {
        nodes = [];
        time  = 0.0;
        scale = 0.0;
        step  = 0.0;
        speed = 0.1;
        content.removeChildren();
        setUpNodes();
    }


    function onKey(e)
    {
        switch (e.keyCode) {
            case Keyboard.S: {
                ++step;
            }
            case Keyboard.I: {
                impulse();
            }
            case Keyboard.SPACE: {
                scale = scale > 0.0 ? 0.0 : speed;
            }
            case Keyboard.Q: {
                speed *= 1.1;
                if (scale > 0.0) {
                    scale = speed;
                }
            }
            case Keyboard.W: {
                speed /= 1.1;
                if (scale > 0.0) {
                    scale = speed;
                }
            }
            case Keyboard.R: {
                reset();
            }
            case Keyboard.H: {
                info.visible = !info.visible;
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
        nodes[Std.random(nodes.length)].state = true;
    }


    function resize(?e:Event)
    {
        content.scaleX = stage.stageWidth  / contentWidth;
        content.scaleY = stage.stageHeight / contentHeight;
    }


    public static function rand(min:Int, max:Int)
    {
        return Std.random(max - min + 1) + min;
    }

    public function nodeTooClose(node:Node, otherNodes:Array<Node>)
    {
        for (other in otherNodes) {
            if (node.distanceTo(other) < MIN_NODE_DISTANCE) {
                return true;
            }
        }
        return false;
    }

    public static function circleContainsPoint(circleX:Float, circleY:Float, circleRadius:Float, pointX:Float, pointY:Float)
    {
        var x = circleX - pointX;
        var y = circleY - pointY;
        var distance = Math.sqrt(x*x + y*y);
        return distance <= circleRadius;
    }

    function connectingCircleEmpty(a:Node, b:Node, otherNodes:Array<Node>)
    {
        var diameter = a.distanceTo(b);
        var midPointX = (a.x + b.x) / 2;
        var midPointY = (a.y + b.y) / 2;
        for (n in otherNodes) {
            if (circleContainsPoint(midPointX, midPointY, diameter/2, n.x, n.y)) {
                return false;
            }
        }
        return true;
    }
}
