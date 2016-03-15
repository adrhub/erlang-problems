-module(main_app).

-export([start/0]).

start() -> try read("file1.txt")
             catch
               _:Error -> erlang:display(Error),
                 file:write_file("error_log.txt", io_lib:fwrite("~p.\n", [Error]))
           end.

read(File) -> case file:read_file(File) of
                {ok, Bin} -> io:format("~p~n", [Bin]);
                {error, Reason} -> throw(Reason)
              end.