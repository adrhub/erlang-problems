-module(main_app).

-import(math_functions, [even/1, odd/1, split/1, filter/2, accSplit/1]).
-export([start/0]).

start() ->
  X1 = 4, X2 = 3, List = [1,2,3,4,5],
  io:fwrite("even(~p): ~p~n", [X1, even(X1)]),
  io:fwrite("even(~p): ~p~n", [X2, even(X2)]),
  io:fwrite("odd(~p): ~p~n", [X1, odd(X1)]),
  io:fwrite("odd(~p): ~p~n", [X2, odd(X2)]),
  io:fwrite("filter(~p): ~p~n", [List, filter(fun math_functions:even/1, List)]),
  io:fwrite("split(~p): ~p~n", [List, split(List)]),
  io:fwrite("accSplit(~p): ~p~n", [List, accSplit(List)]).