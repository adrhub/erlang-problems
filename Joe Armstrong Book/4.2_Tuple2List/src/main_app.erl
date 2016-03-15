-module(main_app).

-export([start/0, tuple2list/1]).

start() -> tupleToListDisplay().

tupleToListDisplay() -> io:format("~p~n", [tuple2list( {1,2,3} )]).

tuple2list(Tuple) -> Size = tuple_size(Tuple), lists:reverse(tuple2list(Tuple, Size, Size)).
tuple2list( _ , 0, _ ) -> [];
tuple2list(Tuple, Current, Size) -> [element(Current, Tuple)| tuple2list(Tuple, Current-1, Size)].