package statemachine.paths.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.nullValue;

import statemachine.paths.events.PathStatusEvent;
import statemachine.paths.support.MockProcessProvider;
import statemachine.paths.support.MockStateMachineDriver;
import statemachine.paths.support.ProcessName;
import statemachine.utils.injectTokens;
import statemachine.support.StateName;

public class ProcessDriverTest
{
    private var _classUnderTest:PathDriver;
    private var _processProvider:MockProcessProvider;
    private var _stateMachine:MockStateMachineDriver;


    [Before]
    public function before():void
    {
        _processProvider = new MockProcessProvider();
        _stateMachine = new MockStateMachineDriver()
        _classUnderTest = new PathDriver( _processProvider, _stateMachine );
    }


    [Test]
    public function when_run_called_driver_checks_Process_exists():void
    {
        _classUnderTest.run( ProcessName.ONE );
        assertThat( _processProvider.targetChecked, equalTo( ProcessName.ONE ) );
    }

    [Test]
    public function when_Process_does_not_exists__driver_does_not_get_Process():void
    {
        setHasProcess( false );
        _classUnderTest.run( ProcessName.ONE );
        assertThat( _processProvider.targetsGot, nullValue() );
    }

    [Test]
    public function when_Process_does_not_exists__dispatches_ProcessStatusEvent():void
    {
        var onProcessStatusEvent:PathStatusEvent;
        const onProcessStatus:Function = function ( event:PathStatusEvent ):void
        {
            onProcessStatusEvent = event;
        }
        _stateMachine.dispatcher.addEventListener( PathStatusEvent.UNDECLARED_PATH, onProcessStatus );

        const expectedMessage:String = injectTokens( PathStatusEvent.UNDECLARED_PROCESS_MESSAGE, [ProcessName.ONE] );


        setHasProcess( false );
        _classUnderTest.run( ProcessName.ONE )

        assertThat( onProcessStatusEvent, notNullValue() );
        assertThat( onProcessStatusEvent.message, equalTo( expectedMessage ) );
    }

    [Test]
    public function when_Process_exists__driver_retrieves_SubProcess():void
    {
        const subProcess:SubPath = new SubPath( [] );
        subProcess.add( StateName.TARGET );

        setHasProcess( true );
        setSubProcessValue( subProcess );
        _classUnderTest.run( ProcessName.ONE );

        assertThat( _processProvider.getSubName, equalTo( ProcessName.ONE ) );
        assertThat( _processProvider.getSubStateName, equalTo( StateName.CURRENT ) );
    }

    [Test]
    public function when_Process_exists__driver_calls_changeState():void
    {
        const subProcess:SubPath = new SubPath( [] );
        subProcess.add( StateName.TARGET );

        setHasProcess( true );
        setSubProcessValue( subProcess );
        _classUnderTest.run( ProcessName.ONE );

        assertThat( _stateMachine.receivedTargetStates, array( equalTo( StateName.TARGET ) ) );
    }

    [Test]
    public function changeState_is_called_for_each_stateName_declared_in_SubProcess():void
    {
        const subProcess:SubPath = new SubPath( [] );
        subProcess.add( StateName.ONE );
        subProcess.add( StateName.TWO );
        subProcess.add( StateName.THREE );

        setHasProcess( true );
        setSubProcessValue( subProcess );
        _classUnderTest.run( ProcessName.ONE );

        assertThat(
                _stateMachine.receivedTargetStates,
                array(
                        equalTo( StateName.ONE ),
                        equalTo( StateName.TWO ),
                        equalTo( StateName.THREE )
                )
        );
    }

    [Test]
    public function run_is_broken_if_changeState_returns_false():void
    {
        const subProcess:SubPath = new SubPath( [] );
        subProcess.add( StateName.ONE );
        subProcess.add( StateName.TWO );
        subProcess.add( StateName.THREE );
        subProcess.add( StateName.FOUR );

        setHasProcess( true );
        setSubProcessValue( subProcess );
        setChangeStateReturnValues( true, true, false, true );
        _classUnderTest.run( ProcessName.ONE );

        assertThat(
                _stateMachine.receivedTargetStates,
                array(
                        equalTo( StateName.ONE ),
                        equalTo( StateName.TWO ),
                        equalTo( StateName.THREE )

                )
        );
    }

    [Test]
    public function driver_resets_SubProcess_after_run():void
    {
        const subProcess:SubPath = new SubPath( [] );
        subProcess.add( StateName.ONE );
        subProcess.add( StateName.TWO );
        subProcess.add( StateName.THREE );
        subProcess.add( StateName.FOUR );

        setHasProcess( true );
        setSubProcessValue( subProcess );
        setChangeStateReturnValues( true, true, false, true );
        _classUnderTest.run( ProcessName.ONE );

        assertThat( subProcess.getNext(), equalTo( StateName.ONE ) );

    }

    [Test]
    public function NULL():void
    {
        var onProcessStatusEvent:PathStatusEvent;
        const onProcessStatus:Function = function ( event:PathStatusEvent ):void
        {
            onProcessStatusEvent = event;
        }
        _stateMachine.dispatcher.addEventListener( PathStatusEvent.UNDECLARED_STATE, onProcessStatus );

        const expectedMessage:String = injectTokens( PathStatusEvent.UNDECLARED_STATE_MESSAGE, [StateName.CURRENT, ProcessName.ONE] );

        setHasProcess( true );
        setSubProcessValue( SubPath.NULL );
        _classUnderTest.run( ProcessName.ONE );

        assertThat( onProcessStatusEvent, notNullValue() );
        assertThat( onProcessStatusEvent.message, equalTo( expectedMessage ) );

    }

    private function setChangeStateReturnValues( ...args ):void
    {
        _stateMachine.changeStateReturnValues = args;
    }

    private function setHasProcess( hasState:Boolean ):void
    {
        _processProvider.hasProcessValue = hasState;
    }

    private function setSubProcessValue( sub:SubPath ):void
    {
        _processProvider.subProcessValue = sub;
    }
}
}
