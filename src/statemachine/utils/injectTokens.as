package statemachine.utils
{

public function injectTokens( string:String, tokens:Array ):String
{
    const token:RegExp = /\$\{(.*?)\}/g;
    const f:Function = function ( token:String, capture:String, index:int, full:String ):String
    {
        return tokens[int( capture )];
    }
    return string.replace( token, f )
}
}

