-module(f).

-behaviour(gen_server).

%% API
-export([
  start_link/0,
  calc/2, rand/1
]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
  next_send :: undefined | atom()
}).

calc(X, sin) ->
  calc(X, fun math:sin/1);

calc(X, tan) ->
  calc(X, fun math:tan/1);

calc(X, Fun) ->
  gen_server:cast(?SERVER, { calc, X, Fun }).

rand(List) ->
  gen_server:cast(?SERVER, { rand, List}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  {ok, #state{
    next_send = g
  }}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({ rand, List }, State) ->
  Rand = rand:uniform(length(List)),
  Module = lists:nth(Rand, List),
  NewState = State#state{
    next_send = Module
  },
  { noreply, NewState };

handle_cast({ calc, X, Fun }, State) ->
  Result = Fun(X),
  Module = State#state.next_send,
  Module:do(Result),
  NewState = State#state{
    next_send = g
  },
  { noreply, NewState };

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
