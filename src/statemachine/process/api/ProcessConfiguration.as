package statemachine.process.api
{
import org.swiftsuspenders.Injector;

import statemachine.process.impl.ProcessDriver;
import statemachine.process.impl.ProcessProvider;
import statemachine.process.impl.TransitionEventMap;

public class ProcessConfiguration
{
    internal var injector:Injector;

    public function ProcessConfiguration( injector:Injector )
    {
        this.injector = injector;//.createChildInjector();
    }

    public function configure():void
    {
        injector.map( FSMFlowMap ).toSingleton( TransitionEventMap );
        injector.map( ProcessBuilder ).asSingleton();
        injector.map( ProcessProvider ).asSingleton();
        injector.map( ProcessControl ).toSingleton( ProcessDriver );

    }


}
}
