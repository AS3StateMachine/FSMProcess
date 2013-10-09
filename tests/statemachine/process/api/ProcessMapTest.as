package statemachine.process.api
{
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;

import statemachine.process.builders.StateMapping;
import statemachine.process.impl.ProcessProvider;
import statemachine.process.support.ProcessName;

public class ProcessMapTest
{
    private var _classUnderTest:ProcessBuilder;
    private var _provider:ProcessProvider;


    [Before]
    public function before():void
    {
        _provider = new ProcessProvider();
        _classUnderTest = new ProcessBuilder( _provider );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
        _provider = null;
    }

    [Test]
    public function configure_returns_instance_of_StateMapping():void
    {
        assertThat( _classUnderTest.configure( ProcessName.ONE ), instanceOf( StateMapping ) );
    }

    [Test]
    public function configure_returns_new_ProcessContainer():void
    {
        _classUnderTest.configure( ProcessName.THREE );
        assertThat( _provider.has( ProcessName.THREE ), isTrue() );
    }


}
}
