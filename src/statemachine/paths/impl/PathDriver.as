package statemachine.paths.impl
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.FSMProperties;
import statemachine.engine.api.StateMachine;
import statemachine.paths.api.PathControl;
import statemachine.utils.injectTokens;
import statemachine.paths.events.PathStatusEvent;

public class PathDriver implements PathControl
{

    private var _pathProvider:PathProvider;
    private var _stateMachine:StateMachine;

    public function PathDriver( pathProvider:PathProvider, stateMachine:StateMachine ):void
    {
        _pathProvider = pathProvider;
        _stateMachine = stateMachine;
    }

    public function run( pathName:String ):void
    {
        if ( _pathProvider.has( pathName ) )
        {
            const subPath:SubPath = _pathProvider.getSub( pathName, _stateMachine.properties.currentState );
            if ( subPath !== SubPath.NULL )
            {
                handleTransitions( subPath );
            }

            else
            {
                dispatch(
                        PathStatusEvent.UNDECLARED_STATE,
                        injectTokens( PathStatusEvent.UNDECLARED_STATE_MESSAGE, [_stateMachine.properties.currentState, pathName] )
                );
            }
        }

        else
        {
            dispatch(
                    PathStatusEvent.UNDECLARED_PATH,
                    injectTokens( PathStatusEvent.UNDECLARED_PROCESS_MESSAGE, [pathName] )
            );
        }
    }

    private function handleTransitions( subPath:SubPath ):void
    {
        while ( subPath.hasNext() && _stateMachine.changeState( subPath.getNext() ) )
        {
        }
        subPath.reset();
    }

    private function dispatch( type:String, message:String ):void
    {
        _stateMachine.dispatcher.dispatchEvent( new PathStatusEvent( type, message ) );
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
