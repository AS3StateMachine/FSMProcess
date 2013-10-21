package statemachine.paths.events
{
import flash.events.Event;

public class PathStatusEvent extends Event
{
    public static const UNDECLARED_PATH:String = "PathStatusEvent.undeclaredPath";
    public static const UNDECLARED_STATE:String = "PathStatusEvent.undeclaredState";

    public static const UNDECLARED_PROCESS_MESSAGE:String = "[Path: ${0}] is undeclared";
    public static const UNDECLARED_STATE_MESSAGE:String = "No transition has been declared for [State: ${0}] in [Path: ${1}]";


    public function PathStatusEvent( type:String, message:String = "" )
    {
        super( type );
        _message = message;

    }

    private var _message:String;

    public function get message():String
    {
        return _message;
    }

    override public function clone():Event
    {
        return new PathStatusEvent( type, _message );
    }
}
}
