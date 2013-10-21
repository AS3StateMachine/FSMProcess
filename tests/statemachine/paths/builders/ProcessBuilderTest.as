package statemachine.paths.builders
{
import org.hamcrest.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;

import statemachine.paths.impl.Path;
import statemachine.paths.impl.SubPath;
import statemachine.paths.support.ProcessName;
import statemachine.support.StateName;

public class ProcessBuilderTest
{
    private var _classUnderTest:SubPathBuilder;
    private var _process:Path;


    [Before]
    public function before():void
    {
        _process = new Path( ProcessName.ONE );
        _classUnderTest = new SubPathBuilder( _process, null );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
        _process = null;
    }

    [Test]
    public function ifCurrentState_returns_instanceOf_TransitionMapping():void
    {
        assertThat( _classUnderTest.ifCurrentState( StateName.ONE ), instanceOf( TransitionMapping ) );
    }

    [Test]
    public function ifCurrentState_adds_SubProcess_to_Process():void
    {
        _classUnderTest.ifCurrentState( StateName.ONE )
        assertThat( _process.get( StateName.ONE ), not( SubPath.NULL ) );
    }




}
}
