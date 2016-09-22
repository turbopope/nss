import openfl.text.TextField;
import openfl.text.TextFormat;


class Info extends TextField
{
    public function new()
    {
        super();

        var format  = new TextFormat();
        format.bold = true;
        format.size = 20;

        defaultTextFormat = format;
        background        = true;
        autoSize          = LEFT;
        mouseEnabled      = false;
    }
}
