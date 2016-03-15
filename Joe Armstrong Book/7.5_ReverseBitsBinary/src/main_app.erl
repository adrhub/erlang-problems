-module(main_app).

-export([start/0, reverseBites/1]).

start() -> Value = <<7>>,
  io:format("~p~n~p~n",
    [getBits(Value),
      reverseBites(Value)]).

getBits(Value) ->
  <<<<Bit>> || <<Bit:1>> <= Value>>.

reverseBites(X) ->
  list_to_binary(lists:reverse([Bit || <<Bit:1>> <= X])).