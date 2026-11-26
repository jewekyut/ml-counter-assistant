% ============================================================================
% api.pl - JSON-ready data builders used by server.pl (no HTTP here, so it can
% be tested from the Prolog console, e.g.  ?- team_json([fanny,atlas], D). )
% ============================================================================
:- module(ml_api, [heroes_json/1, hero_json/2, team_json/2, build_json/3,
                   draft_json/3, meta_json/1, items_json/1, parse_ids/2]).

:- use_module(library(lists)).
:- use_module(library(apply)).

:- use_module(heroes).
:- use_module(items).
:- use_module(counters).
:- use_module(builds).
:- use_module(meta).
:- use_module(season).

:- dynamic api_dir/1.
:- prolog_load_context(directory, D), assertz(api_dir(D)).

% ------------------------------------------------------------- helpers ----
name_override(x_borg,         'X.Borg').
name_override(yi_sun_shin,    'Yi Sun-shin').
name_override(lapu_lapu,      'Lapu-Lapu').
name_override(luo_yi,         'Luo Yi').
name_override(chang_e,        'Chang\'e').
name_override(popol_and_kupa, 'Popol and Kupa').
% item display names (match the wiki titles)
name_override(athenas_shield,     'Athena\'s Shield').
name_override(berserkers_fury,    'Berserker\'s Fury').
name_override(queens_wings,       'Queen\'s Wings').
name_override(blade_of_despair,   'Blade of Despair').
name_override(blade_of_heptaseas, 'Blade of the Heptaseas').
name_override(haas_claws,         'Haas\'s Claws').

disp(A, N) :- name_override(A, N), !.
disp(A, N) :-
    atom_string(A, S), split_string(S, "_", "", Ps),
    maplist(cap, Ps, Cs), atomic_list_concat(Cs, ' ', N).

cap(W, W) :- memberchk(W, ["of", "the", "and"]), !.
cap(W, C) :-
    atom_string(A, W), atom_chars(A, [F|R]),
    upcase_atom(F, U), atom_chars(C, [U|R]).

%% parse_ids(+Atom, -Ids): "a, b,c" -> [a,b,c] (empty string -> [])
parse_ids(S, Ids) :-
    split_string(S, ",", " ", P0), exclude(==(""), P0, P),
    maplist(to_atom, P, Ids0), list_to_set(Ids0, Ids).
to_atom(S, A) :- atom_string(A, S).

valid_ids(Ids, Min, Max) :-
    length(Ids, N), N >= Min, N =< Max,
    forall(member(H, Ids), hero(H)).

id_name(H, _{id: H, name: N}) :- disp(H, N).

%% local_url(+Kind, +Id, -Url): local image in src/frontend/img/<Kind>/<Id>.<ext>
local_url(Kind, Id, Url) :-
    api_dir(D), member(Ext, [jpg, png, jpeg, webp]),
    format(atom(F), '~w/../frontend/img/~w/~w.~w', [D, Kind, Id, Ext]),
    exists_file(F), !,
    format(atom(Url), '/img/~w/~w.~w', [Kind, Id, Ext]).
local_url(_, _, '').
reason_of(C, T, R) :- ( counter_reason(C, T, R0) -> R = R0 ; R = "" ).
roles_of(H, Rs) :- findall(R, hero_role(H, R), Rs).

take(N, L, P) :- ( length(L, Len), Len =< N -> P = L ; length(P, N), append(P, _, L) ).

% -------------------------------------------------------------- heroes ----
hero_brief(H, _{id: H, name: N, roles: Rs, damage: D, tier: T, score: S, lanes: Ls,
                local: Lc, full: Fu}) :-
    disp(H, N), roles_of(H, Rs),
    local_url(hero, H, Fu),
    (   local_url(thumb, H, Th), Th \== '' -> Lc = Th ; Lc = Fu ),
    findall(X, hero_damage_type(H, X), D),
    hero_tier(H, T),
    ( season_score(H, S) -> true ; S = 0 ),
    findall(L, hero_lane(H, L), Ls).

heroes_json(Ds) :-
    findall(H, hero(H), Hs0), sort(Hs0, Hs),
    maplist(hero_brief, Hs, Ds).

counter_item(E, counter(C, Ty), _{id: C, name: N, type: Ty, reason: R}) :-
    disp(C, N), reason_of(C, E, R).

counter_list(E, Cs) :-
    get_counter_picks(E, Ps), maplist(counter_item(E), Ps, Cs).

strong(H, Ds) :-
    findall(_{id: T, name: N, type: hard, reason: R},
            (hard_counter(H, T), disp(T, N), reason_of(H, T, R)), A),
    findall(_{id: T, name: N, type: soft, reason: R},
            (soft_counter(H, T), disp(T, N), reason_of(H, T, R)), B),
    append(A, B, Ds).

hero_json(H, D) :-
    hero(H),
    hero_brief(H, B),
    findall(X, hero_specialty(H, X), Sp),
    hero_difficulty(H, Df),
    findall(X, hero_strength(H, X), St),
    findall(X, hero_weakness(H, X), Wk),
    findall(X, hero_tag(H, X), Tg),
    counter_list(H, By), strong(H, Strong),
    put_dict(_{specialty: Sp, difficulty: Df, strengths: St, weaknesses: Wk,
               tags: Tg, counteredBy: By, strongAgainst: Strong}, B, D).

% ---------------------------------------------------------------- team ----
team_analysis(T, _{physical: P, magic: M, hybrid: Hy, sustain: Su, mobile: Mo,
                   cc: Cc, shield: Sh, dps: Dp, burst: Bu}) :-
    dmg(T, physical, P), dmg(T, magic, M), dmg(T, hybrid, Hy),
    tagged(T, [sustain_hero, healer, lifesteal_hero], Su),
    tagged(T, [mobile_hero], Mo),
    tagged(T, [cc_heavy], Cc),
    tagged(T, [shield_hero], Sh),
    tagged(T, [dps_hero], Dp),
    tagged(T, [burst_hero], Bu).

dmg(T, Ty, N) :-
    findall(E, (member(E, T), hero_damage_type(E, Ty)), L), length(L, N).

tagged(T, Tags, Names) :-
    findall(N, (member(E, T), member(Tag, Tags), hero_tag(E, Tag), disp(E, N)), L),
    sort(L, Names).

rec_item(Score-H, _{id: H, name: N, score: Score, tier: Ti, roles: Rs}) :-
    disp(H, N), hero_tier(H, Ti), roles_of(H, Rs).

enemy_item(E, _{id: E, name: N, counters: Cs}) :-
    disp(E, N), counter_list(E, Cs).

team_json(T, _{analysis: A, recommendations: Recs, enemies: Per}) :-
    valid_ids(T, 1, 5),
    team_analysis(T, A),
    best_counter_for_team(T, Recs0), maplist(rec_item, Recs0, Recs),
    maplist(enemy_item, T, Per).

% --------------------------------------------------------------- items ----
item_brief(I, _{id: I, name: N, type: Ty, categories: Cs, price: Pr, passive: P,
                stats: St, goodAgainst: G, local: Lc}) :-
    disp(I, N), item_type(I, Ty),
    findall(C, item_category(I, C), Cs),
    ( item_price(I, Pr0)  -> Pr = Pr0 ; Pr = 0 ),
    ( item_passive(I, P0) -> P = P0 ; P = "" ),
    findall(_{stat: S, value: V}, item_stat(I, S, V), St),
    findall(X, item_good_against(I, X), G),
    local_url(item, I, Lc).

items_json(Ds) :-
    findall(I, item(I), Is0), sort(Is0, Is),
    maplist(item_brief, Is, Ds).

% --------------------------------------------------------------- build ----
item_item(I, _{id: I, name: N, passive: P, price: Pr}) :-
    disp(I, N),
    ( item_passive(I, P0) -> P = P0 ; P = "" ),
    ( item_price(I, Pr0)  -> Pr = Pr0 ; Pr = 0 ).

anti_pick(H, _, dominance_ice) :- hero_damage_type(H, magic), !.
anti_pick(_, R, dominance_ice) :- memberchk(R, [mage, support]), !.
anti_pick(_, R, sea_halberd)         :- memberchk(R, [marksman, assassin, fighter]), !.
anti_pick(_, _, dominance_ice).

build_json(H, T, _{hero: H, name: HN, items: Items, summary: Sum}) :-
    hero(H), valid_ids(T, 1, 5),
    once(recommend_build(H, T, B)),
    disp(H, HN),
    maplist(item_item, B, Items),
    team_analysis(T, A),
    recommend_boots(T, Bo),
    builds:count_enemy_damage_types(T, P, M),
    recommend_defense(P, M, De),
    recommend_anti_heal(T, AH),
    once(hero_role(H, R)), anti_pick(H, R, Pick),
    Sum = _{analysis: A, boots: Bo, defense: De, antiHeal: AH, antiHealPick: Pick}.

% --------------------------------------------------------------- draft ----
draft_json(Mine, Enemies, _{mine: MA, enemy: EA, counterPicks: Recs,
                            roles: Roles, synergies: Syn}) :-
    valid_ids(Mine, 0, 5), valid_ids(Enemies, 0, 5),
    team_analysis(Mine, MA), team_analysis(Enemies, EA),
    (   Enemies == [] -> Recs = []
    ;   best_counter_for_team(Enemies, R0),
        exclude(picked(Mine), R0, R1), maplist(rec_item, R1, Recs)
    ),
    findall(_{role: Role, covered: Cov, picks: Picks},
            ( member(Role, [tank, fighter, assassin, mage, marksman]),
              ( member(C, Mine), hero_role(C, Role) -> Cov = true ; Cov = false ),
              role_picks(Role, Mine, Enemies, Picks) ),
            Roles),
    findall(_{a: A, b: B},
            ( member(X, Mine), member(Y, Mine), X @< Y, meta:has_synergy(X, Y),
              disp(X, A), disp(Y, B) ),
            Syn).

picked(Mine, _-H) :- memberchk(H, Mine).

role_picks(Role, Mine, Enemies, Picks) :-
    findall(Sc-H,
            ( hero_role(H, Role),
              \+ memberchk(H, Mine), \+ memberchk(H, Enemies),
              (   Enemies == [] -> CS = 0
              ;   counters:counter_score_against_team(H, Enemies, CS) ),
              meta:team_fit_score(H, Mine, FS),
              Sc is CS + FS ),
            L0),
    sort(0, @>=, L0, L1), list_to_set(L1, L2),
    take(5, L2, L3), maplist(rec_item, L3, Picks).

% ---------------------------------------------------------------- meta ----
meta_json(_{label: Label, sources: Srcs, notes: Notes, tiers: Tiers,
            bans: Bans, picks: Picks}) :-
    season_label(Label),
    findall(S, season_source(S), Srcs),
    findall(N, season_note(N), Notes),
    findall(_{tier: T, heroes: Hs},
            ( member(T, [s_plus, s, a, b, c]),
              findall(H, hero_tier(H, T), Ids0), sort(Ids0, Ids), Ids \== [],
              maplist(tier_hero, Ids, Hs) ),
            Tiers),
    findall(_{priority: P, heroes: Bs},
            ( member(P, [1, 2, 3]),
              findall(B, season_ban(B, P), BIds), BIds \== [],
              maplist(id_name, BIds, Bs) ),
            Bans),
    meta_heroes(Mh0), maplist(id_name, Mh0, Picks).

tier_hero(H, _{id: H, name: N, roles: Rs, score: S}) :-
    disp(H, N), roles_of(H, Rs), ( season_score(H, S) -> true ; S = 0 ).
