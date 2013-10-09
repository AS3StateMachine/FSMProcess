package statemachine.process.impl
{
import flash.utils.Dictionary;

public class ProcessProvider
{
    private const _map:Dictionary = new Dictionary( false );

    public function has( name:String ):Boolean
    {
        return (_map[name] != null );
    }

    public function get( name:String ):Process
    {
        if ( has( name ) ) return _map[name];
        return _map[name] = create( name );
    }

    private function create( name:String ):Process
    {
        return new Process( name );
    }

    public function getSub( name:String, stateName:String ):SubProcess
    {
        return get(name ).get(stateName);
    }

    public function fix():void
    {
       for each( var p:Process in _map){
           p.fix();
       }
    }
}
}
