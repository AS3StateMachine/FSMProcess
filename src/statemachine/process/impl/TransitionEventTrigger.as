package statemachine.process.impl
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMDispatcher;
import statemachine.engine.impl.TransitionPhase;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.flow.api.Payload;
import statemachine.flow.core.ExecutableBlock;
import statemachine.flow.core.Trigger;

public class TransitionEventTrigger implements Trigger
{
    private var _dispatcher:IEventDispatcher;
    private var _client:ExecutableBlock;
    private var _eventClass:Class;
    private var _stateName:String;
    private var _phase:TransitionPhase;

    public function TransitionEventTrigger( stateName:String, phase:TransitionPhase )
    {
        _stateName = stateName;
        _phase = phase;
        _eventClass = TransitionEvent;
    }

    public function setDispatcher( value:IEventDispatcher ):TransitionEventTrigger
    {
        _dispatcher = value;
        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, handleEvent );
        return this;
    }

    private function handleEvent( event:TransitionEvent ):void
    {
        if ( _client == null || event.stateName != _stateName || event.phase != _phase )return;
        _client.executeBlock( new Payload().add(event, _eventClass) );
    }

    public function add( client:ExecutableBlock ):void
    {
        _client = client;
    }

    public function remove():void
    {
        _dispatcher.removeEventListener( TransitionEvent.PHASE_CHANGED, handleEvent );
        _client = null;
    }
}
}
