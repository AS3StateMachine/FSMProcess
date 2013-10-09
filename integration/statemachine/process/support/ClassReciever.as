package statemachine.process.support
{
import statemachine.support.TestRegistry;

public class ClassReciever implements TestRegistry
{
    public const classes:Array = []

    public function register( c:Class ):void
    {
        classes.push( c ) ;
    }
}
}
