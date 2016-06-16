-module(app).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").
-compile(export_all).

main() ->
    User = wf:user(),
    io:fwrite("User: ~p~n", [User]),
    case User of
        <<>> -> wf:redirect("/login");
        undefined -> wf:redirect("/login");
        User ->
            [#dtl{file="app", ext="dtl", bindings = [{body, body()}]}]
    end.

body() ->
    User = wf:user(),
    #'div'{id = "app", body = <<"Welcome to the app, ", User/binary>>}.
