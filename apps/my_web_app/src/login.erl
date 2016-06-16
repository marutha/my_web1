-module(login).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    [#dtl{file="login", ext="dtl", app=my_web_app, bindings = [{body, login_body()}]}].

login_body() ->
    [#'div'{class = <<"container">>,
            body = #'div'{class = <<"row">>,
                          body = #'div'{class = <<"Absolute-Center is-Responsive">>,
                                        body = [#'div'{id = <<"logo-container">>},
                                                #'div'{class = login_form_class(),
                                                       body = login_form()}]}}}
    ].


login_form_class() -> <<"col-ms-12 col-md-10 col-md-offset-1">>.

login_form() ->
    #form{action = <<"login">>, id= <<"loginForm">>, method = "post",
          postback = login, source = [username, password],
          body = [#'span'{id = "login_info"},
                  #'div'{class = <<"form-group input-group">>,
                         body = [#'input'{class = <<"form-control">>, type = <<"text">>,
                                          name = <<"username">>, placeholder = <<"username">>,
                                          id = username},
                                 #'span'{class = <<"input-group-addon">>,
                                         body = #'i'{class = <<"glyphicon glyphicon-user">>}}]
                        },
                  #'div'{class = <<"form-group input-group">>,
                         body = [#'input'{class = <<"form-control">>, type = <<"password">>,
                                          name = <<"password">>, placeholder = <<"password">>,
                                          id = password},
                                 #'span'{class = <<"input-group-addon">>,
                                         body = #'i'{class = <<"glyphicon glyphicon-lock">>}}]},
                  #'div'{class = <<"checkbox">>,
                         body = #'label'{body = #'input'{type = <<"checkbox">>,
                                                         body = [<<"I agree to the ">>,
                                                                 #'link'{body = <<"Terms and Conditions">>,
                                                                         href = <<"#">>}]}}},
                  #'div'{class = <<"form-group">>,
                         body = #button{class = <<"btn btn-def btn-block animated bounceIn">>,
                                        type = <<"button">>, body =  <<"Login">>,
                                        postback = login, id = loginButton,
                                        source = [username, password]}},
                  #'div'{class= <<"form-group text-center">>,
                         body = #'link'{href = <<"#">>,
                                        body = <<"Forgot Password">>}}
                 ]}.

event(login) ->
    User = wf:q(username),
    Pass = wf:q(password),
    if User == Pass ->
           wf:user(User),
           wf:redirect("app");
       true ->
           wf:update(login_info, #span{id = login_info,
                                       body= #b{body = <<"Invalid username password">>},
                                       class = <<"animated shake">>})
    end.
