package statemachine.process.impl
{
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.engine.api.FSMDispatcher;
import statemachine.engine.impl.State;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.TransitionPhase;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.impl.*;
import statemachine.support.StateName;
import statemachine.support.TestRegistry;
import statemachine.support.cmds.MockCommandOne;

public class TransitionEventMapTest implements TestRegistry
{
    private var _classUnderTest:TransitionEventMap;
    private var _injector:Injector;
    private var _executables:Vector.<Class>;
    private var _dispatcher:IEventDispatcher;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _dispatcher = new StateDispatcher();
        _injector.map( FSMDispatcher ).toValue( _dispatcher );
        _injector.map( TestRegistry ).toValue( this );
        _classUnderTest = new TransitionEventMap( _injector );
        _executables = new Vector.<Class>();
    }

    [Test]
    public function constructor_creates_childInjector():void
    {
        assertThat( _classUnderTest.injector.parentInjector, strictlyEqualTo( _injector ) );
    }

    [Test]
    public function constructor_injects_childInjector_as_Injector():void
    {
        assertThat( _classUnderTest.injector.getInstance( Injector ), strictlyEqualTo( _classUnderTest.injector ) );
    }

    [Test]
    public function constructor_injects_Executor():void
    {
        assertThat( _classUnderTest.injector.hasMapping( Executor ), isTrue() );
    }

    [Test]
    public function during_returns_self():void
    {
        assertThat( _classUnderTest.during( StateName.CLIENT ), strictlyEqualTo( _classUnderTest ) )
    }

    [Test]
    public function cancellation_returns_instanceOf_ControlFlowMapping():void
    {
        assertThat( _classUnderTest.during( StateName.CLIENT ).cancellation, instanceOf( FlowMapping ) )
    }

    [Test]
    public function cancellation_maps_trigger():void
    {
        _classUnderTest.during( StateName.CLIENT ).cancellation
        assertThat( _classUnderTest.has( StateName.CLIENT, TransitionPhase.CANCELLATION ), isTrue() );
    }

    [Test]
    public function setUp_returns_instanceOf_ControlFlowMapping():void
    {
        assertThat( _classUnderTest.during( StateName.CLIENT ).setUp, instanceOf( FlowMapping ) )
    }

    [Test]
    public function setUp_maps_trigger():void
    {
        _classUnderTest.during( StateName.CLIENT ).setUp;
        assertThat( _classUnderTest.has( StateName.CLIENT, TransitionPhase.SET_UP ), isTrue() );
    }

    [Test]
    public function tearDown_returns_instanceOf_ControlFlowMapping():void
    {
        assertThat( _classUnderTest.during( StateName.CLIENT ).tearDown, instanceOf( FlowMapping ) )
    }

    [Test]
    public function tearDown_maps_trigger():void
    {
        _classUnderTest.during( StateName.CLIENT ).tearDown;
        assertThat( _classUnderTest.has( StateName.CLIENT, TransitionPhase.TEAR_DOWN ), isTrue() );
    }

    [Test]
    public function when_configuring_same_state__the_previous_settings_are_not_overwritten():void
    {
        _classUnderTest.during( StateName.CLIENT ).tearDown;
        _classUnderTest.during( StateName.CLIENT ).setUp;
        assertThat( _classUnderTest.has( StateName.CLIENT, TransitionPhase.TEAR_DOWN ), isTrue() );
    }


    [Test]
    public function flow_not_executed_if_event_not_dispatched():void
    {
        _classUnderTest.during( StateName.CLIENT )
                .cancellation
                .always.executeAll( MockCommandOne )
                .and.fix();

        assertThat( _executables.length, equalTo( 0 ) );
    }

    [Test]
    public function flow_executed_when_corresponding_event_dispatched():void
    {
        _classUnderTest.during( StateName.CLIENT )
                .cancellation
                .always.executeAll( MockCommandOne )
                .and.fix();

        _dispatcher.dispatchEvent( new TransitionEvent( new State( StateName.CLIENT ), TransitionPhase.CANCELLATION ) );

        assertThat( _executables.length, equalTo( 1 ) );
    }

    [Test]
    public function flow_not_executed_when_non_corresponding_event_dispatched():void
    {
        _classUnderTest.during( StateName.CLIENT )
                .cancellation
                .always.executeAll( MockCommandOne )
                .and.fix();

        _dispatcher.dispatchEvent( new TransitionEvent( new State( StateName.CLIENT ), TransitionPhase.TEAR_DOWN ) );

        assertThat( _executables.length, equalTo( 0 ) );
    }

    [Test]
    public function flow_not_executed_when_event_removed():void
    {

        _classUnderTest.during( StateName.CLIENT )
                .cancellation
                .always.executeAll( MockCommandOne )
                .and.fix();

        _classUnderTest.remove( StateName.CLIENT, TransitionPhase.CANCELLATION );
        _dispatcher.dispatchEvent( new TransitionEvent( new State( StateName.CLIENT ), TransitionPhase.CANCELLATION ) );

        assertThat( _executables.length, equalTo( 0 ) );

    }


    public function register( value:* ):void
    {
        _executables.push( value );
    }
}
}
