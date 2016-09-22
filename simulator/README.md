# Simulator

Simple visual simulator for network cascades. We used this to understand the model and construct examples.

There's a pre-built HTML5 version in [html5/index.html](html5/index.html). Clone this repository and open the file in your browser to see it.

You can hit the keys mentioned at the top of the simulation to control it. Clicking a node will change its state. Hovering over one will show you its tau value.


## Building

Requires Haxe and OpenFL: <http://www.openfl.org/download/>

Compile and run with `lime test <target>`, where target is one of:

* `html5`

* `flash`

* `neko` (Haxe's native target)

* `cpp` (native C++ target)

Or cross compile to:

* `windows`

* `linux`

* `mac`

* `android`
