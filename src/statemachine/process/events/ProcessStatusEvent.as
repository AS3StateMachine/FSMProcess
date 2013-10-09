package statemachine.process.events
{
import flash.events.Event;

public class ProcessStatusEvent extends Event
{
    public static const UNDECLARED_PROCESS:String = "ProcessStatusEvent.undeclaredProcess";
    public static const UNDECLARED_STATE:String = "ProcessStatusEvent.undeclaredState";

    public static const UNDECLARED_PROCESS_MESSAGE:String = "[Process: ${0}] is undeclared";
    public static const UNDECLARED_STATE_MESSAGE:String = "No transition has been declared for [State: ${0}] in [Process: ${1}]";


    public function ProcessStatusEvent( type, message:String = "" )
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
        return new ProcessStatusEvent( type, _message );
    }
}
}
