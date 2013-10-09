package statemachine.process.api
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMProperties;

public interface ProcessControl
{
    function run( processName:String  ):void;

    function get properties():FSMProperties;

    function get dispatcher():IEventDispatcher

}
}
