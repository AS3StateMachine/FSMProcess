package statemachine.paths.support
{
import statemachine.engine.api.FSMProperties;
import statemachine.engine.impl.TransitionPhase;
import statemachine.support.StateName;

public class MockStateMachineProperties implements FSMProperties
{


    public function get currentState():String
    {
        return StateName.CURRENT;
    }

    public function get currentTarget():String
    {
        return StateName.TARGET;
    }

    public function get currentPhase():String
    {
        return TransitionPhase.NULL.name;
    }
}
}
