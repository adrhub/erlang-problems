-module(main_app).

-export([start/0]).

start() ->
  Map = #{k1 => 1, 2 => 2, k3 => 3},
  FunX = fun(X) -> {K, V} = X, K =:= V end,
  io:fwrite("~p~n", [map_search_pred(Map, FunX)]).

map_search_pred(Map, Pred) when is_map(Map) -> map_search_pred(maps:to_list(Map), Pred);
map_search_pred([], _Pred) -> [];
map_search_pred([H| T], Pred) ->
  case Pred(H) of
    true -> H;
    false -> map_search_pred(T, Pred)
  end.


