package statemachine.process.impl
{
public class Process
{
    public function Process( name:String )
    {
        _name = name;
        ignoreUndeclaredSubProcesses = true;
    }

    public var ignoreUndeclaredSubProcesses:Boolean;
    private var _map:Vector.<SubProcess>;

    private var _name:String;

    public function get name():String
    {
        return _name;
    }

    public function add( process:SubProcess ):void
    {
        _map || (_map = new Vector.<SubProcess>());
        _map.push( process );
    }

    public function get( stateName:String ):SubProcess
    {
        if ( _map == null ) return SubProcess.NULL;
        for each ( var process:SubProcess in _map )
        {
            if ( process.has( stateName ) )return process;
        }
        return SubProcess.NULL;
    }

    public function fix():void
    {
        if ( _map == null )return;
        _map.fixed = true;
        for each ( var sub:SubProcess in _map )
        {
            sub.fix();
        }

    }


}
}
