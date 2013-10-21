package statemachine.paths
{
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

import statemachine.engine.api.StateMachine;
import statemachine.engine.impl.StateDispatcher;
import statemachine.flow.impl.TriggerFlowMap;
import statemachine.paths.api.*;
import statemachine.flow.impl.TransitionFlowMap;

public class TransitionFlowMapExtension implements IExtension
{

    public function extend( context:IContext ):void
    {
        const injector:IInjector = context.injector;
        const stateMachine:StateMachine = injector.getInstance( StateMachine );
        const triggerMap:TriggerFlowMap = injector.getInstance( TriggerFlowMap );

        const map:TransitionFlowMap = new TransitionFlowMap( triggerMap, stateMachine.dispatcher as StateDispatcher );
        context.injector.map( FSMFlowMap ).toValue( map );

    }

}
}
