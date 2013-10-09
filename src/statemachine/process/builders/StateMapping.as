package statemachine.process.builders
{
import statemachine.process.api.ProcessBuilder;

public interface StateMapping
{
    function ifCurrentState( ...stateNames ):TransitionMapping


    function get and():ProcessBuilder



}
}
