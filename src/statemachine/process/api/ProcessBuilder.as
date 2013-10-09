package statemachine.process.api
{
import statemachine.process.builders.SubProcessBuilder;
import statemachine.process.builders.StateMapping;
import statemachine.process.impl.ProcessProvider;

public class ProcessBuilder
{
    public function ProcessBuilder( provider:ProcessProvider )
    {
        _provider = provider;
    }

    private var _provider:ProcessProvider;

    public function configure( processName:String ):StateMapping
    {
        return  new SubProcessBuilder( _provider.get( processName ), this );
    }

    public function fix():void {
        _provider.fix()
    }


}
}
