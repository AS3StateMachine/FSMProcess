package statemachine.process.impl
{

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;

import statemachine.support.StateName;

public class SubProcessTest
{
    private var _classUnderTest:SubProcess;


    [Before]
    public function before():void
    {
        _classUnderTest = new SubProcess( [StateName.ONE, StateName.TWO] );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
    }

    [Test]
    public function hasNext_returns_false_by_default():void
    {
        assertThat( _classUnderTest.hasNext(), isFalse() );
    }

    [Test]
    public function when_stateName_added_hasNext_returns_true():void
    {
        _classUnderTest.add( StateName.CLIENT );
        assertThat( _classUnderTest.hasNext(), isTrue() );
    }

    [Test]
    public function by_default_getNext_returns_NULL():void
    {
        assertThat( _classUnderTest.getNext(), equalTo( "NULL" ) );
    }

    [Test]
    public function when_stateName_added_getNext_returns_value():void
    {
        _classUnderTest.add( StateName.CLIENT );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.CLIENT ) );
    }

    [Test]
    public function when_stateNames_added_getNext_returns_first_on_first_off():void
    {
        _classUnderTest.add( StateName.ONE );
        _classUnderTest.add( StateName.TWO );
        _classUnderTest.add( StateName.THREE );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.ONE ) );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.TWO ) );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.THREE ) );
    }

    [Test]
    public function when_hasNext_is_false__getNext_returns_NULL():void
    {
        _classUnderTest.add( StateName.ONE );
        _classUnderTest.add( StateName.TWO );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.ONE ) );
        assertThat( _classUnderTest.getNext(), equalTo( StateName.TWO ) );
        assertThat( _classUnderTest.getNext(), equalTo( "NULL" ) );
    }

    [Test]
    public function when_at_end_of_iteration_hasNext_returns_false():void
    {
        _classUnderTest.add( StateName.ONE );
        _classUnderTest.add( StateName.TWO );
        _classUnderTest.add( StateName.THREE );
        _classUnderTest.getNext();
        _classUnderTest.getNext();
        _classUnderTest.getNext();
        assertThat( _classUnderTest.hasNext(), isFalse() );
    }

    [Test]
    public function when_reset__getNext_returns_first_value():void
    {
        _classUnderTest.add( StateName.ONE );
        _classUnderTest.add( StateName.TWO );
        _classUnderTest.add( StateName.THREE );
        _classUnderTest.getNext();
        _classUnderTest.getNext()

        _classUnderTest.reset();

        assertThat( _classUnderTest.getNext(), equalTo( StateName.ONE ) );
    }

    [Test(expects="RangeError")]
    public function when_fix_called__vector_is_fixed():void
    {
        _classUnderTest.add( StateName.ONE );
        _classUnderTest.add( StateName.TWO );
        _classUnderTest.fix();
        _classUnderTest.add( StateName.THREE );

    }



    [Test]
    public function when_stateName_is_defined_in_clientStateNames_returns_true():void
    {

        assertThat( _classUnderTest.has( StateName.ONE ), isTrue() );
    }

    [Test]
    public function when_stateName_is_not_defined_in_clientStateNames_returns_false():void
    {
        assertThat( _classUnderTest.has( StateName.THREE ), isFalse() );
    }


}
}
