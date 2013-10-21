package statemachine.paths.builders
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;

import statemachine.paths.impl.SubPath;
import statemachine.support.StateName;

public class TransitionBuilderTest
{
    private var _classUnderTest:TransitionBuilder;
    private var _subprocess:SubPath;
    private var _processBuilder:SubPathBuilder;


    [Before]
    public function before():void
    {
        _processBuilder = new SubPathBuilder( null, null );
        _subprocess = new SubPath( [StateName.ONE, StateName.TWO] );
        _classUnderTest = new TransitionBuilder( _subprocess, _processBuilder );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
        _subprocess = null;
        _processBuilder = null;
    }

    [Test]
    public function transition_returns_instanceOf_StateMapping():void
    {
        assertThat( _classUnderTest.transition(), instanceOf( StateMapping ) );
    }

    [Test]
    public function transition_adds_StateNames_to_SubProcess():void
    {
        _classUnderTest.transition( StateName.ONE, StateName.FOUR )
        assertThat( _subprocess.getNext(), equalTo( StateName.ONE ) );
        assertThat( _subprocess.getNext(), equalTo( StateName.FOUR ) );
    }




}
}
