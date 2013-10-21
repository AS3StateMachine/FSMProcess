package statemachine.paths.support.cmds
{
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.support.TestRegistry;

public class CommandWithInjectedEvent
{
    [Inject]
    public var commandRegistry:TestRegistry;

    [Inject]
    public var event:TransitionEvent;


    public function execute():void
    {
        commandRegistry.register( event );
    }
}
}
