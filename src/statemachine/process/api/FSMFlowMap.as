package statemachine.process.api
{
import statemachine.engine.impl.TransitionPhase;
import statemachine.process.builders.FSMFlowMapping;

public interface FSMFlowMap
{
    function during( stateName:String ):FSMFlowMapping;

    function remove( stateName:String, phase:TransitionPhase ):void;
}
}
