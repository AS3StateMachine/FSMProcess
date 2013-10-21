package statemachine.paths
{
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
import statemachine.paths.api.*;
import statemachine.paths.impl.PathDriver;
import statemachine.paths.impl.PathProvider;
import statemachine.flow.impl.TransitionFlowMap;

public class PathConfiguration
{
    internal var injector:IInjector;

    public function PathConfiguration( injector:IInjector )
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

        injector.parent.map( FSMBuilder ).toValue( injector.getInstance( FSMBuilder ) );


        //////////////////////////////////////////
        injector.map( Executor ).asSingleton();
        injector.map( TriggerFlowMap ).asSingleton();
        injector.map( EventFlowMap ).toSingleton( EventMap );
        injector.map( TransitionFlowMap ).asSingleton();
        injector.map( PathProvider ).asSingleton();
        injector.map( PathBuilder ).asSingleton();
        injector.map( PathDriver ).asSingleton();

        injector.parent.map( FSMFlowMap ).toValue( injector.getInstance( TransitionFlowMap ) );
        injector.parent.map( PathBuilder ).toValue( injector.getInstance( PathBuilder ) );
        injector.parent.map( StateMachine ).toValue( injector.getInstance( StateMachineDriver ) );
        injector.parent.map( PathControl ).toValue( injector.getInstance( PathDriver ) );


    }


}
}
