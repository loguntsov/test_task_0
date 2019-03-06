-module(test_app_sup).

-behaviour(supervisor).

%% API
-export([
  start_link/0
]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  {ok, {SupFlags,
    [#{
      id => Module,
      start => { Module, start_link, []},
      restart => permanent,
      shutdown => 1000,
      type => worker,
      modules => [ Module ]
    } || Module <- [h, k, g, f]]
  }}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
