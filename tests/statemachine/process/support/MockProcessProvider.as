package statemachine.process.support
{
import statemachine.process.impl.Process;
import statemachine.process.impl.ProcessProvider;
import statemachine.process.impl.SubProcess;

public class MockProcessProvider  extends ProcessProvider
{
    public var targetChecked:String;
    public var targetsGot:String;
    public var hasProcessValue:Boolean;
   // public var processValue:Process;
    public var getSubName:String;
    public var getSubStateName:String;
    public var subProcessValue:SubProcess;

    override public function has( name:String ):Boolean
    {
        targetChecked = name;
        return hasProcessValue;
    }

   /* override public function get( name:String ):Process
    {
        targetsGot = name;
        return processValue
    }
*/

    override public function getSub( name:String, stateName:String ):SubProcess
    {
        getSubName =  name;
        getSubStateName = stateName;
        return subProcessValue;
    }
}
}
