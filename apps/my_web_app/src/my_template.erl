-module(my_template).
-export([main/0]).
-include_lib("nitro/include/nitro.hrl").


main() ->
    [#dtl{file="my_template", ext = "dtl",
          bindings = [{name, <<"This has started working, let us try with some HTML and CSS">>}]}].
