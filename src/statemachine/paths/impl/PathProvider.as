package statemachine.paths.impl
{
import flash.utils.Dictionary;

public class PathProvider
{
    private const _map:Dictionary = new Dictionary( false );

    public function has( name:String ):Boolean
    {
        return (_map[name] != null );
    }

    public function get( name:String ):Path
    {
        if ( has( name ) ) return _map[name];
        return _map[name] = create( name );
    }

    private function create( name:String ):Path
    {
        return new Path( name );
    }

    public function getSub( name:String, stateName:String ):SubPath
    {
        return get(name ).get(stateName);
    }

    public function fix():void
    {
       for each( var p:Path in _map){
           p.fix();
       }
    }
}
}
