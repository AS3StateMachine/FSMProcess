package statemachine.process
{
import org.swiftsuspenders.Injector;

import statemachine.engine.api.FSMBuilder;
import statemachine.engine.api.StateMachine;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.StateMachineDriver;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.StateProvider;
import statemachine.engine.impl.TransitionInspector;
import statemachine.flow.impl.Executor;
import statemachine.flow.impl.TriggerFlowMap;
import statemachine.process.api.*;
import statemachine.process.impl.ProcessDriver;
import statemachine.process.impl.ProcessProvider;
import statemachine.process.impl.TransitionEventMap;

public class ProcessConfiguration
{
    internal var injector:Injector;

    public function ProcessConfiguration( injector:Injector )
    {
        this.injector = injector.createChildInjector();
    }

    public function configure():void
    {
        injector.map( Injector ).toValue( injector );
        injector.map( StateProvider ).asSingleton();
        injector.map( StateMachineProperties ).asSingleton();
        injector.map( StateDispatcher ).asSingleton();
        injector.map( StateMachineEngine ).asSingleton();
        injector.map( TransitionInspector ).asSingleton();
        injector.map( StateMachineDriver ).asSingleton();
        injector.map( FSMBuilder ).asSingleton();

        injector.parentInjector.map( FSMBuilder ).toValue( injector.getInstance( FSMBuilder ) );


        //////////////////////////////////////////
        injector.map( Executor ).asSingleton();
        injector.map( TriggerFlowMap ).asSingleton();
        injector.map( TransitionEventMap ).asSingleton();
        injector.map( ProcessProvider ).asSingleton();
        injector.map( ProcessBuilder ).asSingleton();
        injector.map( ProcessDriver ).asSingleton();

        injector.parentInjector.map( FSMFlowMap ).toValue( injector.getInstance( TransitionEventMap ) );
        injector.parentInjector.map( ProcessBuilder ).toValue( injector.getInstance( ProcessBuilder) );
        injector.parentInjector.map( StateMachine ).toValue( injector.getInstance( StateMachineDriver) );
        injector.parentInjector.map( ProcessControl ).toValue( injector.getInstance( ProcessDriver) );



    }


}
}
