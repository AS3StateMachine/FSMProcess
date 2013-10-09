package statemachine.process.builders
{
import org.hamcrest.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;

import statemachine.process.impl.Process;
import statemachine.process.impl.SubProcess;
import statemachine.process.support.ProcessName;
import statemachine.support.StateName;

public class ProcessBuilderTest
{
    private var _classUnderTest:SubProcessBuilder;
    private var _process:Process;


    [Before]
    public function before():void
    {
        _process = new Process( ProcessName.ONE );
        _classUnderTest = new SubProcessBuilder( _process, null );
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
        assertThat( _process.get( StateName.ONE ), not( SubProcess.NULL ) );
    }




}
}
