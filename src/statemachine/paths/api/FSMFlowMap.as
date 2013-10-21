package statemachine.paths.api
{
import statemachine.engine.impl.TransitionPhase;
import statemachine.paths.builders.FSMFlowMapping;

public interface FSMFlowMap
{
    function during( stateName:String ):FSMFlowMapping;

    function remove( stateName:String, phase:TransitionPhase ):void;
}
}
