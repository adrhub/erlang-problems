-module(main_app).

-export([start/0, term2packet/1, packet2term/1]).

start() -> Value = "adr",
  Value = packet2term(term2packet(Value)),
  io:format("test worked"),
  test_worked.

term2packet(Term) ->
  TermToBinary = term_to_binary(Term),
  BitSizeTerm = bit_size(TermToBinary),
  list_to_binary([<<BitSizeTerm:32/integer>>, TermToBinary]).

packet2term(Packet) -> <<_:32/integer, Binary/binary>> = Packet, binary_to_term(Binary).