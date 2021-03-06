-module(k).

%% API
-behavior(gen_worker).

-export([
  start_link/0, do/1
]).

start_link() ->
  gen_worker:start_link(?MODULE, fun(X) ->
    Ret = crypto:hash(sha256, term_to_binary(X+17)),
    io:format("k: ~p~n", [ Ret ])
  end).

do(X) ->
  gen_worker:do(?MODULE, X).

