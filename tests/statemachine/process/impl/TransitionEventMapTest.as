package statemachine.process.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

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
    private var _injector:IInjector;
    private var _executables:Vector.<Class>;
    private var _dispatcher:StateDispatcher;
    private var _triggerMap:TriggerFlowMap;
    private var _executor:Executor;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _injector.map( IInjector ).toValue( _injector );
        _executor = new Executor( _injector );
        //_injector.map( Executor );
        _injector.map( TestRegistry ).toValue( this );
        _dispatcher = new StateDispatcher();
        _triggerMap = new TriggerFlowMap( _executor );

        _classUnderTest = new TransitionEventMap( _triggerMap, _dispatcher );
        _executables = new Vector.<Class>();
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
