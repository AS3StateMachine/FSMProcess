package statemachine.process.support
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMProperties;
import statemachine.engine.impl.StateMachineDriver;

public class MockStateMachineDriver extends StateMachineDriver
{
    public function MockStateMachineDriver()
    {
        super( null, null, null, null );
        _props = new MockStateMachineProperties()
        _dispatcher = new EventDispatcher();
    }

    public const receivedTargetStates:Array = [];
    public var changeStateReturnValues:Array;

    private var _props:FSMProperties;
    private var _dispatcher:IEventDispatcher;

    override public function get dispatcher():IEventDispatcher
    {
        return _dispatcher;
    }

    override public function get properties():FSMProperties
    {
        return _props;
    }

    override public function changeState( targetState:String ):Boolean
    {
        receivedTargetStates.push( targetState );
        if( changeStateReturnValues == null )return true
        return changeStateReturnValues.shift();
    }
}
}
