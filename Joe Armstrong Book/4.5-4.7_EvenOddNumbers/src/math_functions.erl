-module(math_functions).

%% API
-export([even/1, odd/1, split/1, filter/2, accSplit/1]).

even(X) ->
  if
    X rem 2 =:= 0 -> true;
    true -> false
  end.

odd(X) ->
  if
    X rem 2 =:= 1 -> true;
    true -> false
  end.

filter(F, L) -> [X || X <- L, F(X) =:= true].

split(L) ->
  Odds = filter(fun odd/1, L),
  Evens = filter(fun even/1, L),
  {Odds, Evens}.


accSplit(L) -> accSplit(L, [], []).
accSplit([], Odds, Evens) -> {lists:reverse(Odds), lists:reverse(Evens)};
accSplit([H|T], Odds, Evens) ->
  case odd(H) of
    true -> accSplit(T, [H|Odds], Evens);
    false -> accSplit(T, Odds, [H|Evens])
  end.

