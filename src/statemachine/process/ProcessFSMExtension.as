package statemachine.process
{
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

import statemachine.engine.api.FSMBuilder;
import statemachine.engine.api.StateMachine;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.StateMachineDriver;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.StateProvider;
import statemachine.engine.impl.TransitionInspector;
import statemachine.flow.api.EventFlowMap;
import statemachine.flow.impl.EventMap;
import statemachine.flow.impl.Executor;
import statemachine.flow.impl.TriggerFlowMap;
import statemachine.process.api.*;
import statemachine.process.impl.ProcessDriver;
import statemachine.process.impl.ProcessProvider;
import statemachine.process.impl.TransitionEventMap;

public class ProcessFSMExtension implements IExtension
{

    internal var injector:IInjector;

    public function extend( context:IContext ):void
    {
        this.injector = injector.createChild();
    }

    public function configure():void
    {
        injector.map( IInjector ).toValue( injector );
        injector.map( StateProvider ).asSingleton();
        injector.map( StateMachineProperties ).asSingleton();
        injector.map( StateDispatcher ).asSingleton();
        injector.map( StateMachineEngine ).asSingleton();
        injector.map( TransitionInspector ).asSingleton();
        injector.map( StateMachineDriver ).asSingleton();
        injector.map( FSMBuilder ).asSingleton();

        injector.map( Executor ).asSingleton();
        injector.map( TriggerFlowMap ).asSingleton();
        injector.map( EventFlowMap ).toSingleton( EventMap );
        injector.map( TransitionEventMap ).asSingleton();
        injector.map( ProcessProvider ).asSingleton();
        injector.map( ProcessBuilder ).asSingleton();
        injector.map( ProcessDriver ).asSingleton();

        /*api injection*/
        injector.parent.map( FSMBuilder ).toValue( injector.getInstance( FSMBuilder ) );
        injector.parent.map( FSMFlowMap ).toValue( injector.getInstance( TransitionEventMap ) );
        injector.parent.map( ProcessBuilder ).toValue( injector.getInstance( ProcessBuilder ) );
        injector.parent.map( StateMachine ).toValue( injector.getInstance( StateMachineDriver ) );
        injector.parent.map( ProcessControl ).toValue( injector.getInstance( ProcessDriver ) );


    }


}
}
