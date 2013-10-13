package statemachine.process.support
{
import statemachine.support.TestRegistry;

public class Receiver implements TestRegistry
{
    public const classes:Array = []

    public function register( value:* ):void
    {
        classes.push( value ) ;
    }
}
}
