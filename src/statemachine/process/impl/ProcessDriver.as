package statemachine.process.impl
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMProperties;
import statemachine.engine.api.StateMachine;
import statemachine.process.api.ProcessControl;
import statemachine.utils.injectTokens;
import statemachine.process.events.ProcessStatusEvent;

public class ProcessDriver implements ProcessControl
{

    private var _processProvider:ProcessProvider;
    private var _stateMachine:StateMachine;

    public function ProcessDriver( processProvider:ProcessProvider, stateMachine:StateMachine ):void
    {
        _processProvider = processProvider;
        _stateMachine = stateMachine;
    }

    public function run( processName:String ):void
    {
        if ( _processProvider.has( processName ) )
        {
            const subProcess:SubProcess = _processProvider.getSub( processName, _stateMachine.properties.currentState );
            if ( subProcess !== SubProcess.NULL )
            {
                handleTransitions( subProcess );
            }

            else
            {
                dispatch(
                        ProcessStatusEvent.UNDECLARED_STATE,
                        injectTokens( ProcessStatusEvent.UNDECLARED_STATE_MESSAGE, [_stateMachine.properties.currentState, processName] )
                );
            }
        }

        else
        {
            dispatch(
                    ProcessStatusEvent.UNDECLARED_PROCESS,
                    injectTokens( ProcessStatusEvent.UNDECLARED_PROCESS_MESSAGE, [processName] )
            );
        }
    }

    private function handleTransitions( subProcess:SubProcess ):void
    {
        while ( subProcess.hasNext() && _stateMachine.changeState( subProcess.getNext() ) )
        {
        }
        subProcess.reset();
    }

    private function dispatch( type:String, message:String ):void
    {
        _stateMachine.dispatcher.dispatchEvent( new ProcessStatusEvent( type, message ) );
    }


    public function get properties():FSMProperties
    {
        return _stateMachine.properties;
    }

    public function get dispatcher():IEventDispatcher
    {
        return _stateMachine.dispatcher;
    }
}
}
