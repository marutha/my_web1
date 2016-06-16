-module(my_index).
-compile(export_all).

-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    #dtl{file = "app", ext = "dtl",
         bindings = [{body, body()}]}.

body() ->
    #'div'{id = <<"app">>,
           body = identify_body()}.

identify_body() ->
    User = wf:user(),
    case User of
        <<>> ->
            login_div();
        undefined ->
            login_div();
        User ->
            menu()
    end.

login_div() -> #'dtl'{file = "login1",
                     ext = "dtl",
                     bindings = [{login_button, login_button()}]}.

menu() ->
    #'dtl'{file = "menu",
          ext = "dtl",
          bindings = []}.

login_button() ->
    #'div'{class = <<"form-group">>,
           body = #button{class = <<"btn btn-def btn-block animated bounceIn">>,
                          type = <<"button">>, body =  <<"Login">>,
                          postback = login, id = loginButton,
                          source = [username, password]}}.
event(login) ->
    User = wf:q(username),
    Pass = wf:q(password),
    io:fwrite("Username:~p, Password:~p", [User, Pass]),
    if User == Pass ->
           DTL = #'dtl'{file = "menu",
                               ext = "dtl",
                                bindings = [{user, User}]},
           wf:update(app, wf:jse(wf:render(DTL)));
           %wf:update(app, #'div'{body = <<"Load the menu here">>});
       true ->
           wf:update(login_info, #'div'{id = login_info,
                                        body = <<"Invalid Username password">>,
                                       class = <<"animated shake">>})
    end;
event(What) ->
    io:fwrite("Event triggered:~p", [What]).
