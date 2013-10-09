package statemachine.process.impl
{
import flash.events.Event;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.engine.impl.State;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.TransitionPhase;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.flow.api.Payload;
import statemachine.flow.impl.support.ExecutableTrigger;
import statemachine.support.StateName;

public class TransitionEventTriggerTest
{
    private var _classUnderTest:TransitionEventTrigger;
    private var _dispatcher:IEventDispatcher;
    private var _executable:ExecutableTrigger;

    [Before]
    public function before():void
    {
        _dispatcher = new StateDispatcher()

    }

    [Test]
    public function by_default_client_not_executed():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        assertThat( _executable.numbExecutions, equalTo( 0 ) );
    }

    [Test]
    public function on_event_dispatch_once__client_executed_once():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) )
        assertThat( _executable.numbExecutions, equalTo( 1 ) );
    }

    [Test]
    public function on_event_dispatch_twice__client_executed_twice():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        assertThat( _executable.numbExecutions, equalTo( 2 ) );
    }

    [Test]
    public function on_event_dispatch__when_state_name_mismatch__client_not_executed():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        dispatch( new TransitionEvent( new State( StateName.TARGET ), TransitionPhase.SET_UP ) );
        assertThat( _executable.numbExecutions, equalTo( 1 ) );
    }

    [Test]
    public function on_event_dispatch__when_phase_mismatch__client_not_executed():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.TEAR_DOWN ) );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.CANCELLATION ) );
        assertThat( _executable.numbExecutions, equalTo( 1 ) );
    }

    [Test]
    public function remove__client_not_executed():void
    {
        configure( StateName.CURRENT, TransitionPhase.SET_UP );
        _classUnderTest.remove();
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        dispatch( new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP ) );
        assertThat( _executable.numbExecutions, equalTo( 0 ) );
    }

    [Test]
    public function client_is_passed_instanceOf_payload_when_triggered():void
    {
        const event:Event = new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP );
        configure( StateName.CURRENT,  TransitionPhase.SET_UP );

        dispatch( event );

        assertThat( _executable.receivedPayload, instanceOf( Payload ) );
    }

    [Test]
    public function client_payload_contains_TransitionEvent():void
    {
        const event:Event = new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP );
        configure( StateName.CURRENT,  TransitionPhase.SET_UP );

        dispatch( event );

        assertThat( _executable.receivedPayload.get( TransitionEvent ), strictlyEqualTo( event ) );
    }


    /* [Test]
     public function event_is_mapped_as_TransitionEvent_during_execution():void
     {
     var mappedEvent:TransitionEvent;
     const event:TransitionEvent = new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP );
     configure( StateName.CURRENT, TransitionPhase.SET_UP );

     _classUnderTest.preExecute = function ():void
     {
     mappedEvent = _classUnderTest.injector.getInstance( TransitionEvent );
     }

     dispatch( event );
     assertThat( mappedEvent, strictlyEqualTo( event ) );
     }


     [Test]
     public function event_is_unmapped_after_execution():void
     {
     const event:TransitionEvent = new TransitionEvent( new State( StateName.CURRENT ), TransitionPhase.SET_UP )
     configure( StateName.CURRENT, TransitionPhase.SET_UP );
     dispatch( event );
     assertThat( _classUnderTest.injector.hasMapping( TransitionEvent ), isFalse() );
     }*/

    private function dispatch( event:Event ):void
    {
        _dispatcher.dispatchEvent( event );
    }

    public function configure( stateName:String, phase:TransitionPhase ):void
    {
        _executable = new ExecutableTrigger();
        _classUnderTest = new TransitionEventTrigger( stateName, phase );
        _classUnderTest.setDispatcher( _dispatcher );
        _classUnderTest.add( _executable )
    }


}
}
