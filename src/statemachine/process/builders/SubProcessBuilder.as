package statemachine.process.builders
{
import statemachine.process.api.ProcessBuilder;
import statemachine.process.impl.*;

public class SubProcessBuilder implements StateMapping
{
    private var _process:Process;
    private var _parent:ProcessBuilder;

    public function SubProcessBuilder( process:Process, parent:ProcessBuilder )
    {
        _process = process;
        _parent = parent;
    }

    public function ifCurrentState( ...stateNames ):TransitionMapping
    {
        const subProcess:SubProcess = new SubProcess( stateNames );
        _process.add( subProcess );
        return new TransitionBuilder( subProcess, this );
    }

    public function get and():ProcessBuilder
    {
        return _parent;
    }


}


}
