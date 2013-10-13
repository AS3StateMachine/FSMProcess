package statemachine.process
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasPropertyWithValue;
import org.swiftsuspenders.Injector;

import statemachine.engine.api.FSMBuilder;
import statemachine.engine.FSMConfiguration;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.process.api.FSMFlowMap;
import statemachine.process.api.ProcessBuilder;
import statemachine.process.ProcessConfiguration;
import statemachine.process.api.ProcessControl;
import statemachine.process.support.Receiver;
import statemachine.process.support.ProcessName;
import statemachine.process.support.cmds.CommandWithInjectedEvent;
import statemachine.process.support.guards.BadStateGuard;
import statemachine.support.Reason;
import statemachine.support.TestRegistry;
import statemachine.support.StateName;
import statemachine.support.cmds.CommandWithTestEvent;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.cmds.MockCommandThree;
import statemachine.support.cmds.MockCommandTwo;
import statemachine.support.guards.GrumpyStateGuard;

public class Test
{
    private var _injector:Injector;


    public var flow:FSMFlowMap;

    public var stateBuilder:FSMBuilder;

    public var processDriver:ProcessControl;

    public var processBuilder:ProcessBuilder;

    public var receiver:Receiver;


    [Before]
    public function before():void
    {
        _injector = new Injector();
        _injector.map( Injector ).toValue( _injector );
        _injector.map( IEventDispatcher ).toSingleton( EventDispatcher );
        _injector.map( TestRegistry ).toSingleton( Receiver );
        _injector.getOrCreateNewInstance( ProcessConfiguration ).configure();

        stateBuilder = _injector.getInstance( FSMBuilder );
        processBuilder = _injector.getInstance( ProcessBuilder );
        processDriver = _injector.getInstance( ProcessControl );
        flow = _injector.getInstance( FSMFlowMap );
        receiver = _injector.getInstance( TestRegistry );

    }

   [Test]
    public function test():void
    {

        stateBuilder
                .configure( StateName.ONE )
                .withTargets( StateName.TWO )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.FOUR )
                .and
                .configure( StateName.FOUR )
                .withEntryGuards( GrumpyStateGuard )
                .withTargets( StateName.ONE );

        processBuilder
                .configure( ProcessName.TO_THE_END )
                .ifCurrentState( "NULL" )
                .transition( StateName.ONE, StateName.TWO, StateName.THREE, StateName.FOUR )
                .and.fix();

        flow
                .during( StateName.ONE )
                .setUp.always.executeAll( MockCommandThree )
                .and.fix();

        flow
                .during( StateName.TWO )
                .tearDown.always.executeAll( MockCommandTwo )
                .and.fix();

        flow
                .during( StateName.THREE )
                .setUp.always.executeAll( MockCommandOne )
                .and.fix();

        flow
                .during( StateName.THREE )
                .cancellation.always.executeAll( CommandWithInjectedEvent )
                .and.fix();

        flow
                .during( StateName.FOUR )
                .setUp.always.executeAll( MockCommandOne, MockCommandTwo, MockCommandThree )
                .and.fix();




        processDriver.run( ProcessName.TO_THE_END );

        assertThat( processDriver.properties.currentState, equalTo( StateName.THREE ) );

        assertThat(
                receiver.classes,
                array(
                        MockCommandThree,
                        MockCommandTwo,
                        MockCommandOne,
                        hasPropertyWithValue("reason", Reason.BECAUSE ) ) )
    }


}
}
