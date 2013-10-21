package statemachine.paths.api
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMProperties;

public interface PathControl
{
    function run( pathName:String  ):void;

    function get properties():FSMProperties;

    function get dispatcher():IEventDispatcher

}
}
