package statemachine.paths.impl
{

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.paths.support.ProcessName;
import statemachine.support.StateName;

public class ProcessProviderTest
{
    private var _classUnderTest:PathProvider;


    [Before]
    public function before():void
    {
        _classUnderTest = new PathProvider();
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
    }

    [Test]
    public function has_returns_false_when_no_Process_registered():void
    {
        assertThat(
                _classUnderTest.has( ProcessName.ONE ),
                isFalse()
        )
    }

    [Test]
    public function get_returns_Process():void
    {
        assertThat(
                _classUnderTest.get( ProcessName.ONE ),
                instanceOf( Path )
        );
    }

    [Test]
    public function get_returns_Process_with_given_name():void
    {
        assertThat(
                _classUnderTest.get( ProcessName.ONE ).name,
                equalTo( ProcessName.ONE )
        );
    }

    [Test]
    public function get_returns_same_Process_instance():void
    {
        const process:Path = _classUnderTest.get( ProcessName.ONE )
        assertThat(
                _classUnderTest.get( ProcessName.ONE ),
                strictlyEqualTo( process )
        );
    }

    [Test]
    public function has_returns_true_when_a_Process_has_previously_been_registered():void
    {
        _classUnderTest.get( ProcessName.ONE );
        assertThat(
                _classUnderTest.has( ProcessName.ONE ),
                isTrue()
        )
    }

    [Test]
    public function getSub_returns_instanceOf_SubProcess():void
    {
        assertThat(
                _classUnderTest.getSub( ProcessName.ONE, StateName.CURRENT ),
                instanceOf( SubPath )
        )
    }

    [Test]
    public function getSub_returns_SubProcess_registered_under_correct_terms():void
    {
        const subProcess:SubPath = new SubPath( [StateName.TARGET, StateName.CURRENT, StateName.ONE] );
        _classUnderTest.get( ProcessName.ONE ).add( subProcess );
        assertThat(
                _classUnderTest.getSub( ProcessName.ONE, StateName.CURRENT ),
                strictlyEqualTo( subProcess )
        )
    }

    [Test(expects="RangeError")]
    public function fix_fixes_the_Process_vectors():void
    {
        const subProcess:SubPath = new SubPath( [StateName.TARGET, StateName.CURRENT, StateName.ONE] );
        subProcess.add(StateName.FOUR);
        _classUnderTest.get( ProcessName.ONE ).add( subProcess );
        _classUnderTest.fix();
        subProcess.add(StateName.TWO);

    }


}
}
