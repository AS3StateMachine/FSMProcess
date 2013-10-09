package statemachine.process.builders
{
import statemachine.flow.builders.FlowMapping;

public interface FSMFlowMapping
{
    function get cancellation():FlowMapping

    function get tearDown():FlowMapping

    function get setUp():FlowMapping


}
}
