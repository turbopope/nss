import haxe.Timer;
import sys.io.File;
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

    var NODES  = 200;
    var MIN_K  = 1;
    var MAX_K  = 5;
    var UNIT_DISC_RADIUS = 200;
    var MIN_NODE_DISTANCE = 32;

    var MIN_IMPULSE_COUNT = 10;
    var MAX_IMPULSE_COUNT = 20;

    var content = new Sprite();
    var nodes   = new Array<Node>();
    var time    = 0.0;
    var scale   = 0.0;
    var step    = 0.0;

    public function new()
    {
        super();
        addChild(content);

        var save : {nodes:Array<Dynamic>, edges:Array<Dynamic>} = null;
        if (Sys.args().length == 2) {
            var saveName = Sys.args()[0];
            save = haxe.Json.parse(File.getContent("../../../../../" + saveName + ".json"));

            NODES = getDynamicProperty(save, "NODES", NODES);
            MIN_K = getDynamicProperty(save, "MIN_K", MIN_K);
            MAX_K = getDynamicProperty(save, "MAX_K", MAX_K);
            UNIT_DISC_RADIUS = getDynamicProperty(save, "UNIT_DISC_RADIUS", UNIT_DISC_RADIUS);
            MIN_NODE_DISTANCE = getDynamicProperty(save, "MIN_NODE_DISTANCE", MIN_NODE_DISTANCE);

            MIN_IMPULSE_COUNT = getDynamicProperty(save, "MIN_IMPULSE_COUNT", MIN_IMPULSE_COUNT);
            MAX_IMPULSE_COUNT = getDynamicProperty(save, "MAX_IMPULSE_COUNT", MAX_IMPULSE_COUNT);
        }

        for (i in 0 ...  NODES) {
            var node = new Node(Math.random(), false);
            do {
                node.x   = WIDTH  * Math.random();
                node.y   = HEIGHT * Math.random();
            } while(nodeTooClose(node, nodes));
            content.addChild(node);
            nodes.push(node);

            node.buttonMode = true;
            node.addEventListener(CLICK, function (_) {
                node.state = !node.state;
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
                if (connecting_circle_empty(node, other, toTest)) {
                    node.addNeighbor(other);
                    other.addNeighbor(node);
                }
            }

            content.addChildAt(node.lines, 0);
        }

        if (save != null) {
            var newNodes = new Array<Node>();
            for (rawNode in save.nodes) {
                var node = new Node(rawNode.t, false);
                node.x = rawNode.x;
                node.y = rawNode.y;
                newNodes.push(node);
            }

            for (rawEdge in save.edges) {
                var a = newNodes[rawEdge.a];
                var b = newNodes[rawEdge.b];
                a.addNeighbor(b);
                b.addNeighbor(a);
            }

            for (newNode in newNodes) {
                content.addChild(newNode);
                nodes.push(newNode);
                content.addChildAt(newNode.lines, 0);
            }
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

    function connecting_circle_empty(a:Node, b:Node, otherNodes:Array<Node>)
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

    public static function getDynamicProperty(dyn, field, def) {
      if (Reflect.hasField(dyn, field)) {
          return Reflect.getProperty(dyn, field);
      }
      return def;
    }
}
