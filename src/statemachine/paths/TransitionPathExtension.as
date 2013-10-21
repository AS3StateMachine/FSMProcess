package statemachine.paths
{
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

import statemachine.engine.api.StateMachine;
import statemachine.paths.api.*;
import statemachine.paths.impl.PathDriver;
import statemachine.paths.impl.PathProvider;

public class TransitionPathExtension implements IExtension
{
    public function extend( context:IContext ):void
    {
        const injector:IInjector = context.injector;
        const stateMachine:StateMachine = injector.getInstance( StateMachine );
        const provider:PathProvider = new PathProvider();
        const builder:PathBuilder = new PathBuilder( provider );
        const driver:PathDriver = new PathDriver( provider, stateMachine );

        injector.map( PathBuilder ).toValue( builder );
        injector.map( PathControl ).toValue( driver );
    }
}
}
