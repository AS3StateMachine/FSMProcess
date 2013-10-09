package statemachine.process.builders
{
import statemachine.process.api.ProcessBuilder;
import statemachine.process.impl.SubProcess;

public class TransitionBuilder implements TransitionMapping
{
    private var _process:SubProcess;
    private var _parent:StateMapping;


    public function TransitionBuilder( process:SubProcess, parent:StateMapping)
    {
        _process = process;
        _parent = parent;
    }


    public function transition( ...stateNames ):StateMapping
    {
        for each( var name:String in stateNames )
        {
            _process.add( name );
        }
        return _parent;
    }



}


}
