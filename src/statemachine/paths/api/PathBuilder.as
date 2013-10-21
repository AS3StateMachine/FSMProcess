package statemachine.paths.api
{
import statemachine.paths.builders.SubPathBuilder;
import statemachine.paths.builders.StateMapping;
import statemachine.paths.impl.PathProvider;

public class PathBuilder
{
    public function PathBuilder( provider:PathProvider )
    {
        _provider = provider;
    }

    private var _provider:PathProvider;

    public function configure( pathName:String ):StateMapping
    {
        return  new SubPathBuilder( _provider.get( pathName ), this );
    }

    public function fix():void {
        _provider.fix()
    }


}
}
