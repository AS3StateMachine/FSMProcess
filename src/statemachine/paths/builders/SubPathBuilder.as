package statemachine.paths.builders
{
import statemachine.paths.api.PathBuilder;
import statemachine.paths.impl.*;

public class SubPathBuilder implements StateMapping
{
    private var _path:Path;
    private var _parent:PathBuilder;

    public function SubPathBuilder( path:Path, parent:PathBuilder )
    {
        _path = path;
        _parent = parent;
    }

    public function ifCurrentState( ...stateNames ):TransitionMapping
    {
        const subPath:SubPath = new SubPath( stateNames );
        _path.add( subPath );
        return new TransitionBuilder( subPath, this );
    }

    public function get and():PathBuilder
    {
        return _parent;
    }


}


}
