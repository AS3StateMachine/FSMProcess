package statemachine.paths
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasPropertyWithValue;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

import statemachine.engine.api.FSMBuilder;
import statemachine.paths.api.FSMFlowMap;
import statemachine.paths.api.PathBuilder;
import statemachine.paths.api.PathControl;
import statemachine.paths.support.ProcessName;
import statemachine.paths.support.Receiver;
import statemachine.paths.support.cmds.CommandWithInjectedEvent;
import statemachine.support.Reason;
import statemachine.support.StateName;
import statemachine.support.TestRegistry;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.cmds.MockCommandThree;
import statemachine.support.cmds.MockCommandTwo;
import statemachine.support.guards.GrumpyStateGuard;

public class Test
{
    public var flow:FSMFlowMap;
    public var stateBuilder:FSMBuilder;
    public var processDriver:PathControl;
    public var processBuilder:PathBuilder;
    public var receiver:Receiver;
    private var _injector:IInjector;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _injector.map( IInjector ).toValue( _injector );
        _injector.map( IEventDispatcher ).toSingleton( EventDispatcher );
        _injector.map( TestRegistry ).toSingleton( Receiver );
        _injector.getOrCreateNewInstance( PathConfiguration ).configure();

        stateBuilder = _injector.getInstance( FSMBuilder );
        processBuilder = _injector.getInstance( PathBuilder );
        processDriver = _injector.getInstance( PathControl );
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
                .setUp.only.execute( MockCommandThree )
                .and.fix();

        flow
                .during( StateName.TWO )
                .tearDown.only.execute( MockCommandTwo )
                .and.fix();

        flow
                .during( StateName.THREE )
                .setUp.only.execute( MockCommandOne )
                .and.fix();

        flow
                .during( StateName.THREE )
                .cancellation.only.execute( CommandWithInjectedEvent )
                .and.fix();

        flow
                .during( StateName.FOUR )
                .setUp.only.execute( MockCommandOne, MockCommandTwo, MockCommandThree )
                .and.fix();


        processDriver.run( ProcessName.TO_THE_END );

        assertThat( processDriver.properties.currentState, equalTo( StateName.THREE ) );

        assertThat(
                receiver.classes,
                array(
                        MockCommandThree,
                        MockCommandTwo,
                        MockCommandOne,
                        hasPropertyWithValue( "reason", Reason.BECAUSE ) ) )
    }


}
}
