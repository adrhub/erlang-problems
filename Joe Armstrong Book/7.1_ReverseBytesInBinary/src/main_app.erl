-module(main_app).

-export([start/0]).

start() -> io:fwrite("~p~n", [reverseBytes(<<1,2,3,4>>)]).

reverseBytes(X) -> list_to_binary(lists:reverse([ B || <<B>> <= X])).