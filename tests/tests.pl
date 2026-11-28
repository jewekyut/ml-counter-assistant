% ============================================================================
% tests/tests.pl - automated tests for the ML Counter Assistant (plunit)
% Run from the repository root:
%     swipl -g run_tests -t halt tests/tests.pl
% ============================================================================
:- use_module(library(plunit)).
:- use_module(library(lists)).

:- use_module('../src/prolog/heroes').
:- use_module('../src/prolog/items').
:- use_module('../src/prolog/counters').
:- use_module('../src/prolog/builds').
:- use_module('../src/prolog/meta').
:- use_module('../src/prolog/season').
:- use_module('../src/prolog/api').

:- begin_tests(counter_reasoning).

% T1 - a stored fact is found (knowledge base query)
test(hard_counter_fact, [nondet]) :-
    hard_counter(khufra, fanny).

% T2 - a counter is INFERRED from tags (rule, not a stored fact)
test(tag_based_inference, [nondet]) :-
    \+ hard_counter(phoveus, julian),
    \+ soft_counter(phoveus, julian),
    counters(phoveus, julian).

% T3 - every counter pick appears once (list processing + dedup)
test(no_duplicate_counters, [nondet]) :-
    get_counter_picks(fanny, Picks),
    findall(H, member(counter(H, _), Picks), Hs),
    sort(Hs, Unique),
    length(Hs, N), length(Unique, N).

% T4 - team scoring: sorted best-first and never suggests an enemy hero
test(best_counter_for_team, [nondet]) :-
    Team = [fanny, atlas, vale],
    best_counter_for_team(Team, Recs),
    Recs \== [],
    forall(member(_-H, Recs), \+ memberchk(H, Team)),
    findall(S, member(S-_, Recs), Scores),
    msort(Scores, Asc), reverse(Asc, Scores).

% T5 - UNSUCCESSFUL case: a hero does not counter itself
test(no_self_counter, [fail]) :-
    counters(khufra, khufra).

% T6 - UNSUCCESSFUL case: the matchup is one-directional
test(matchup_not_symmetric, [fail]) :-
    hard_counter(fanny, khufra).

% T7 - INVALID input: an unknown hero is rejected
test(unknown_hero, [fail]) :-
    hero(nobody).

:- end_tests(counter_reasoning).

:- begin_tests(build_reasoning).

% T8 - heavy enemy CC makes the system choose Tough Boots
test(boots_vs_heavy_cc, [nondet]) :-
    recommend_boots([atlas, tigreal, fanny], Boots),
    Boots == tough_boots.

% T9 - an all-physical enemy team without CC makes it choose Warrior Boots
test(boots_vs_physical, [nondet]) :-
    recommend_boots([fanny, lancelot, ling], Boots),
    Boots == warrior_boots.

% T10 - anti-heal is recommended only when sustain exists (negation)
test(anti_heal_needed, [nondet]) :-
    recommend_anti_heal([estes, fanny], Item),
    Item == dominance_ice.
test(anti_heal_not_needed, [nondet]) :-
    recommend_anti_heal([fanny, lancelot], Item),
    Item == none.

% T11 - the full build contains anti-heal vs a healer and has at most 6 items
test(build_contains_anti_heal, [nondet]) :-
    once(recommend_build(karrie, [estes, floryn], Build)),
    memberchk(dominance_ice, Build),
    length(Build, N), N =< 6.

% T12 - every item that any build can recommend exists in the item database
test(builds_use_real_items, [nondet]) :-
    forall(( hero(H), once(recommend_build(H, [fanny, floryn, gloo], B)),
             member(I, B) ),
           item(I)).

:- end_tests(build_reasoning).

:- begin_tests(data_and_api).

% T13 - every hero has a season tier (data integrity)
test(every_hero_has_tier, [nondet]) :-
    forall(hero(H), ( hero_tier(H, T), memberchk(T, [s_plus, s, a, b, c]) )).

% T14 - the JSON API layer reasons over a valid team
test(api_team_valid, [nondet]) :-
    team_json([fanny, atlas], D),
    get_dict(recommendations, D, Recs), Recs \== [].

% T15 - INVALID input: the API rejects a team containing an unknown hero
test(api_team_invalid, [fail]) :-
    team_json([fanny, nobody], _).

% T16 - the draft board covers all five roles
test(draft_covers_roles, [nondet]) :-
    draft_json([atlas], [fanny], D),
    get_dict(roles, D, Roles), length(Roles, 5).

:- end_tests(data_and_api).

:- use_module('../src/prolog/strategies').
:- begin_tests(strategy_reasoning).
test(solo_roam) :- recommend_strategies(1,roam,Ds), Ds\=[], forall(member(D,Ds),(D.picks=[P],P.lane==roam,hero_lane(P.id,roam))).
test(duo_synergy) :- recommend_strategies(2,all,Ds), Ds\=[], forall(member(D,Ds),D.synergies\=[]).
test(five_unique_lanes) :- recommend_strategies(5,all,Ds), Ds\=[], forall(member(D,Ds),(findall(L,(member(P,D.picks),L=P.lane),Ls),sort(Ls,[exp,gold,jungle,mid,roam]))).
test(invalid_lane,[fail]) :- recommend_strategies(1,invalid,_).
:- end_tests(strategy_reasoning).

:- use_module('../src/prolog/team_draft').
:- begin_tests(smart_draft).
test(solo_lane) :- once(recommend_draft(1,gold,[],[fanny],D)),D.picks=[P],P.lane==gold,P.id\==fanny.
test(trio_locked) :- once(recommend_draft(3,all,[tigreal],[fanny,atlas],D)),length(D.picks,3),member(P,D.picks),P.id==tigreal.
test(full_lanes) :- once(recommend_draft(5,all,[],[fanny,atlas],D)),findall(L,(member(P,D.picks),L=P.lane),Ls),sort(Ls,[exp,gold,jungle,mid,roam]),findall(H,(member(P,D.picks),H=P.id),Hs),sort(Hs,U),length(U,5),\+memberchk(fanny,Hs),\+memberchk(atlas,Hs).
test(overlap,[fail]) :- recommend_draft(2,all,[fanny],[fanny],_).
:- end_tests(smart_draft).
