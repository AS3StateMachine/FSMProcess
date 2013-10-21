package statemachine.paths.builders
{
import statemachine.paths.api.PathBuilder;

public interface StateMapping
{
    function ifCurrentState( ...stateNames ):TransitionMapping


    function get and():PathBuilder



}
}
