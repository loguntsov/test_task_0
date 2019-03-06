-module(gen_worker).

-behaviour(gen_server).

%% API
-export([
  start_link/2,
  do/2
]).

-callback start_link() -> { ok, pid() }.
-callback do(X :: term()) -> ok.

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state,{
  f :: fun((float()) -> float())
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Name, Fun) ->
  gen_server:start_link({local, Name}, ?MODULE, [ Fun ], []).

do(Name, X) ->
  gen_server:cast(Name, { do, X }).

init([ Fun ]) ->
  {ok, #state{
    f = Fun
  }}.

handle_call(_Request, _From, State) ->
  {reply, error, State}.

handle_cast({ do, X }, State) ->
  (State#state.f)(X),
  { noreply, State};

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
