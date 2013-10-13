//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package statemachine.process.support.guards
{
import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.support.Reason;

public class BadStateGuard
{

    [Inject]
    public var event:TransitionEvent

    public function approve():Boolean
    {
        return false;
    }

    public function getReason():CancellationReason
    {
        return Reason.BECAUSE;
    }


}

}

