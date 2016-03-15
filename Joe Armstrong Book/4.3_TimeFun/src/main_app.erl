-module(main_app).

-export([start/0, my_time_func/1, my_date_string/0]).

start() ->
  FunX = fun(X) -> X * X end,
  io:fwrite("my_time_func: ~p microseconds ~n",[my_time_func(FunX)]),
  io:fwrite("my_date_string: ~p ~n",[my_date_string()]).

my_time_func(F) ->
  TBegin = now(),
  F(100),
  TEnd = now(),
  timer:now_diff(TEnd, TBegin).

my_date_string() ->
  {H, M, S} = erlang:time(),
  {YY, MM, DD} = erlang:date(),
  string_format("~p:~p:~p ~p/~p/~p", [H, M, S, DD, MM, YY]).

string_format(Pattern, Values) ->
  lists:flatten(io_lib:format(Pattern, Values)).