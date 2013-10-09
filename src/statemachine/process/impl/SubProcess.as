package statemachine.process.impl
{
public class SubProcess
{
    public static const NULL:SubProcess = new SubProcess( ["NULL"] );

    public function SubProcess( clientStateNames:Array )
    {
        this.clientStateNames = Vector.<String>( clientStateNames );
    }

    private var clientStateNames:Vector.<String>;
    private var _transitions:Vector.<String>;
    private var _count:int = 0;


    public function add( stateName:String ):void
    {
        const t:Vector.<String> = _transitions || (_transitions = new Vector.<String>());
        t.push( stateName );
    }

    public function fix():void
    {
        if(_transitions == null)return;
        _transitions.fixed = true;
    }

    public function hasNext():Boolean
    {
        if ( _transitions == null )return false;
        return _count < _transitions.length;
    }

    public function getNext():String
    {
        if ( _transitions == null || _count == _transitions.length )return "NULL";
        return _transitions[_count++];
    }

    public function reset():void
    {
        _count = 0;
    }

    public function has( stateName:String ):Boolean
    {
        if ( clientStateNames == null )return false;
        return (clientStateNames.indexOf( stateName ) > -1);
    }
}


}
