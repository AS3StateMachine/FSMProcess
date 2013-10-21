package statemachine.paths.support
{
import statemachine.paths.impl.Path;
import statemachine.paths.impl.PathProvider;
import statemachine.paths.impl.SubPath;

public class MockProcessProvider  extends PathProvider
{
    public var targetChecked:String;
    public var targetsGot:String;
    public var hasProcessValue:Boolean;
   // public var processValue:Process;
    public var getSubName:String;
    public var getSubStateName:String;
    public var subProcessValue:SubPath;

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

    override public function getSub( name:String, stateName:String ):SubPath
    {
        getSubName =  name;
        getSubStateName = stateName;
        return subProcessValue;
    }
}
}
