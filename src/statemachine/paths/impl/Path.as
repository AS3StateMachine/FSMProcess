package statemachine.paths.impl
{
public class Path
{
    public function Path( name:String )
    {
        _name = name;
    }

    private var _map:Vector.<SubPath>;

    private var _name:String;

    public function get name():String
    {
        return _name;
    }

    public function add( process:SubPath ):void
    {
        _map || (_map = new Vector.<SubPath>());
        _map.push( process );
    }

    public function get( stateName:String ):SubPath
    {
        if ( _map == null ) return SubPath.NULL;
        for each ( var subPath:SubPath in _map )
        {
            if ( subPath.has( stateName ) )return subPath;
        }
        return SubPath.NULL;
    }

    public function fix():void
    {
        if ( _map == null )return;
        _map.fixed = true;
        for each ( var sub:SubPath in _map )
        {
            sub.fix();
        }

    }


}
}
