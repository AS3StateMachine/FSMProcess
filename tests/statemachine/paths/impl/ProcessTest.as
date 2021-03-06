package statemachine.paths.impl
{

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.paths.support.ProcessName;
import statemachine.support.StateName;

public class ProcessTest
{
    private var _classUnderTest:Path;


    [Before]
    public function before():void
    {

        _classUnderTest = new Path( ProcessName.ONE );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
    }

    [Test]
    public function name_is_set_via_constructor():void
    {
        assertThat( _classUnderTest.name, equalTo( ProcessName.ONE ) )
    }

    [Test]
    public function get_by_default_returns_NULL_Process():void
    {
        assertThat( _classUnderTest.get( "" ), strictlyEqualTo( SubPath.NULL ) );
    }

    [Test]
    public function when_Process_is_added_it_can_be_retrieved_with_client_state_name():void
    {
        const process:SubPath = new SubPath( [StateName.ONE, StateName.TWO] );
        _classUnderTest.add( process );

        assertThat( _classUnderTest.get( StateName.ONE ), strictlyEqualTo( process ) );
    }

    [Test]
    public function ignoreUndeclaredSubProcesses_by_default_true():void
    {
        assertThat( _classUnderTest.ignoreUndeclaredSubPaths, isTrue() )
    }

    [Test(expects="RangeError")]
    public function when_lock_called__Process_vector_is_fixed():void
    {
        _classUnderTest.add( new SubPath( [StateName.ONE, StateName.TWO] ) );
        _classUnderTest.fix();
        _classUnderTest.add( new SubPath( [StateName.THREE, StateName.TWO] ) );
    }

    [Test(expects="RangeError")]
    public function when_lock_called__children_lock_method_is_called():void
    {
        const sub:SubPath = new SubPath( [StateName.ONE, StateName.TWO] )
        sub.add(StateName.TARGET);
        _classUnderTest.add(sub );
        _classUnderTest.fix();
        sub.add(StateName.CURRENT);
    }


}
}
