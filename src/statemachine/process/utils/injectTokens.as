package statemachine.process.utils
{

public function injectTokens( string:String, tokens:Array )
{
    const token:RegExp = /\$\{(.*?)\}/g;
    const f:Function = function ( token:String, capture:String, index:int, full:String ):String
    {
        return tokens[int( capture )];
    }
    return string.replace( token, f )
}
}

