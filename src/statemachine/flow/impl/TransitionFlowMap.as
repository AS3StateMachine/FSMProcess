package statemachine.flow.impl
{
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.TransitionPhase;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.core.Trigger;
import statemachine.flow.impl.*;
import statemachine.paths.api.FSMFlowMap;
import statemachine.paths.builders.FSMFlowMapping;

public class TransitionFlowMap implements FSMFlowMap, FSMFlowMapping
{
    private const _triggers:Dictionary = new Dictionary( false );
    private var _dispatcher:IEventDispatcher;

    public function TransitionFlowMap( triggerMap:TriggerFlowMap, dispatcher:StateDispatcher )
    {
        _triggerMap = triggerMap;
        _dispatcher = dispatcher;
    }

    private var _triggerMap:TriggerFlowMap;
    private var _currentBag:TriggerBag;

    public function during( stateName:String ):FSMFlowMapping
    {
        if ( _triggers[stateName] == null )
        {
            _currentBag = new TriggerBag( stateName );
            _triggers[stateName] = _currentBag
        }

        else
        {
            _currentBag = _triggers[stateName];
        }

        return this;
    }

    public function remove( stateName:String, phase:TransitionPhase ):void
    {
        if ( _triggers[stateName] == null )return;
        const bag:TriggerBag = _triggers[stateName];
        const trigger:Trigger = bag.get( phase );
        if ( trigger == null )return;
        _triggerMap.unmap( trigger )
        bag.set( null, phase );
    }

    public function get cancellation():FlowMapping
    {
        return mapTrigger( _currentBag, TransitionPhase.CANCELLATION );
    }

    public function get tearDown():FlowMapping
    {
        return mapTrigger( _currentBag, TransitionPhase.TEAR_DOWN );
    }

    public function get setUp():FlowMapping
    {
        return mapTrigger( _currentBag, TransitionPhase.SET_UP );
    }

    private function mapTrigger( bag:TriggerBag, phase:TransitionPhase ):FlowMapping
    {
        const trigger:Trigger = new TransitionEventTrigger( bag.stateName, phase ).setDispatcher( _dispatcher );
        TriggerBag( _triggers[bag.stateName] ).set( trigger, phase );
        return _triggerMap.map( trigger );
    }

    public function has( stateName:String, phase:TransitionPhase ):Boolean
    {
        const trigger:Trigger = TriggerBag( _triggers[stateName] ).get( phase );
        if ( trigger == null ) return false;
        return  (_triggerMap.has( trigger ));
    }
}
}

import statemachine.engine.impl.TransitionPhase;
import statemachine.flow.core.Trigger;

class TriggerBag
{

    internal var stateName:String;

    private var setUp:Trigger;
    private var tearDown:Trigger;
    private var cancellation:Trigger;

    public function TriggerBag( stateName:String )
    {
        this.stateName = stateName;
    }

    public function get( phase:TransitionPhase ):Trigger
    {
        return this[phase.id];
    }

    public function set( trigger:Trigger, phase:TransitionPhase ):void
    {
        this[phase.id] = trigger;
    }


}
