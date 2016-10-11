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

logo_calendar() ->
    {_Y, M, D} = date(),
    Month = month(M),
    Date = list_to_binary(integer_to_list(D)),
    #'div'{class = <<"logo_calendar">>,
           body =
           [#'div'{class = <<"logo-calendar-date">>,
                   body = Date},
            #'div'{class = <<"logo-calendar-month">>,
                   body = Month}]}.

event(login) ->
    User = wf:q(username),
    Pass = wf:q(password),
    io:fwrite("Username:~p, Password:~p", [User, Pass]),
    if User == Pass ->
           DTL = #'dtl'{file = "menu",
                        ext = "dtl",
                        bindings = [{user, User},
                                    {logo_calendar, logo_calendar()}]},
           wf:update(app, wf:jse(wf:render(DTL)));
       %wf:update(app, #'div'{body = <<"Load the menu here">>});
       true ->
           wf:update(login_info, #'div'{id = login_info,
                                        body = <<"Invalid Username password">>,
                                        class = <<"animated shake">>})
    end;
event(What) ->
    io:fwrite("Event triggered:~p", [What]).

month(1) -> <<"Jan">>;
month(2) -> <<"Feb">>;
month(3) -> <<"Mar">>;
month(4) -> <<"Apr">>;
month(5) -> <<"May">>;
month(6) -> <<"Jun">>;
month(7) -> <<"Jul">>;
month(8) -> <<"Aug">>;
month(9) -> <<"Sep">>;
month(10) -> <<"Oct">>;
month(11) -> <<"Nov">>;
month(12) -> <<"Dec">>.
