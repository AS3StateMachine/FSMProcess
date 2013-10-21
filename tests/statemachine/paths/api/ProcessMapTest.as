package statemachine.paths.api
{
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;

import statemachine.paths.builders.StateMapping;
import statemachine.paths.impl.PathProvider;
import statemachine.paths.support.ProcessName;

public class ProcessMapTest
{
    private var _classUnderTest:PathBuilder;
    private var _provider:PathProvider;


    [Before]
    public function before():void
    {
        _provider = new PathProvider();
        _classUnderTest = new PathBuilder( _provider );
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
