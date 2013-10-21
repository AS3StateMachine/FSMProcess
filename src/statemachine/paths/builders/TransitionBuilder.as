package statemachine.paths.builders
{
import statemachine.paths.api.PathBuilder;
import statemachine.paths.impl.SubPath;

public class TransitionBuilder implements TransitionMapping
{
    private var _subPath:SubPath;
    private var _parent:StateMapping;


    public function TransitionBuilder( path:SubPath, parent:StateMapping)
    {
        _subPath = path;
        _parent = parent;
    }


    public function transition( ...stateNames ):StateMapping
    {
        for each( var name:String in stateNames )
        {
            _subPath.add( name );
        }
        return _parent;
    }



}


}
