package statemachine.paths
{
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

import statemachine.engine.StateMachineExtension;
import statemachine.flow.EventFlowMapExtension;
import statemachine.flow.TriggerFlowMapExtension;

public class PathBundle implements IBundle
{

    public function extend( context:IContext ):void
    {
        context.install(
                StateMachineExtension,
                TriggerFlowMapExtension,
                TransitionFlowMapExtension,
                EventFlowMapExtension,
                TransitionPathExtension
        );
    }
}
}