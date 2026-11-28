% ============================================================================
% winrates.pl - hero win-rate statistics + draft win-rate prediction
%
% Data: MLBB statistics site export (133 heroes), retrieved 2026-11-28.
% Rank bracket / patch were not stated in the export: fill in stats_meta/2.
%
% Hero ids are lowercase snake_case (same rule the front-end uses:
% "X.Borg" -> x_borg, "Chang'e" -> chang_e, "Popol and Kupa" -> popol_and_kupa).
% If api.pl uses different ids for some heroes, add them to hero_alias/2.
%
% Usage from server.pl:
%   :- use_module(winrates).
%   :- http_handler(root(api/winrates), api_winrates, []).
%   :- http_handler(root(api/predict),  api_predict,  []).
% ============================================================================
:- module(winrates, [ hero_stat/6, winrate/2, adjusted_winrate/2,
                      tier/2, top_heroes/2, league_average/1,
                      team_rating/2, predict_winrate/3,
                      winrates_json/1, predict_json/3, stats_meta/2 ]).

:- use_module(library(lists)).
:- use_module(library(apply)).

stats_meta(source,    'MLBB statistics website export').
stats_meta(retrieved, '2026-11-28').
stats_meta(bracket,   unknown).
stats_meta(patch,     unknown).

% --- tuning knobs ----------------------------------------------------------
% shrink_k: heroes with a low pick rate have noisy win rates, so they are pulled
%           toward the league average:  adj = avg + (wr-avg) * pick/(pick+K).
% team_scale: how many win-rate points one point of rating difference is worth.
% Both are guesses - adjust once you can compare predictions to real results.
shrink_k(0.30).
team_scale(1.0).

% hero_stat(Id, SourceTier, WinRate%, BanRate%, PickRate%, Roles)
hero_stat(belerick,      'SS',  54.16,  62.02,  1.43, [tank]).
hero_stat(estes,         'SS',  53.21,  69.30,  0.53, [support]).
hero_stat(sun,           'SS',  55.40,  46.02,  1.99, [fighter]).
hero_stat(obsidia,       'SS',  52.99,  49.97,  1.66, [marksman]).
hero_stat(gloo,          'SS',  54.00,  47.35,  0.54, [tank]).
hero_stat(eudora,        'SS',  50.30,  52.55,  1.74, [mage]).
hero_stat(saber,         'SS',  51.13,  46.06,  1.26, [assassin]).
hero_stat(hirara,        'SS',  49.95,  54.58,  0.47, [assassin]).
hero_stat(hilda,         'S',   53.27,  33.02,  0.79, [fighter,tank]).
hero_stat(marcel,        'S',   57.65,  15.40,  0.17, [support]).
hero_stat(hanabi,        'S',   54.19,   6.93,  3.29, [marksman]).
hero_stat(masha,         'S',   56.86,  10.72,  0.24, [fighter,tank]).
hero_stat(floryn,        'S',   53.73,  18.38,  0.66, [support]).
hero_stat(nolan,         'S',   49.05,  28.72,  1.61, [assassin]).
hero_stat(rafaela,       'S',   54.69,  12.15,  0.66, [support]).
hero_stat(minotaur,      'S',   55.19,   9.94,  0.66, [tank,support]).
hero_stat(argus,         'S',   57.48,   1.29,  0.56, [fighter]).
hero_stat(valir,         'S',   54.27,   7.20,  1.37, [mage]).
hero_stat(angela,        'S',   50.49,  18.19,  1.58, [support]).
hero_stat(carmilla,      'S',   53.90,   9.73,  0.90, [support,tank]).
hero_stat(alice,         'S',   50.09,  23.74,  0.68, [mage,tank]).
hero_stat(silvanna,      'S',   52.77,   4.70,  1.58, [fighter]).
hero_stat(lesley,        'S',   48.00,  16.59,  2.24, [marksman,assassin]).
hero_stat(zetian,        'S',   51.96,   7.64,  1.33, [mage]).
hero_stat(miya,          'S',   49.87,   5.68,  2.67, [marksman]).
hero_stat(aldous,        'S',   54.53,   1.29,  0.81, [fighter]).
hero_stat(lolita,        'S',   55.86,   0.23,  0.07, [support,tank]).
hero_stat(atlas,         'S',   52.29,   8.25,  0.66, [tank]).
hero_stat(layla,         'S',   50.34,   2.76,  2.31, [marksman]).
hero_stat(minsitthar,    'S',   52.87,   4.06,  0.63, [fighter]).
hero_stat(zhask,         'A',   53.95,   0.67,  0.43, [mage]).
hero_stat(paquito,       'A',   49.30,  13.04,  0.95, [fighter,assassin]).
hero_stat(cyclops,       'A',   52.46,   1.41,  0.96, [mage]).
hero_stat(lukas,         'A',   50.27,  12.51,  0.46, [fighter]).
hero_stat(karina,        'A',   49.63,   9.63,  1.21, [assassin]).
hero_stat(khufra,        'A',   54.02,   0.58,  0.18, [tank]).
hero_stat(natalia,       'A',   52.35,   4.67,  0.46, [assassin]).
hero_stat(johnson,       'A',   51.65,   3.11,  1.03, [tank,support]).
hero_stat(edith,         'A',   53.76,   0.16,  0.27, [tank,marksman]).
hero_stat(irithel,       'A',   53.39,   0.45,  0.41, [marksman]).
hero_stat(novaria,       'A',   49.40,   7.78,  1.40, [mage]).
hero_stat(aulus,         'A',   51.85,   5.99,  0.34, [fighter]).
hero_stat(diggie,        'A',   52.92,   2.86,  0.15, [support]).
hero_stat(gord,          'A',   52.39,   0.85,  0.71, [mage]).
hero_stat(ling,          'A',   52.88,   0.62,  0.47, [assassin]).
hero_stat(vexana,        'A',   49.93,   1.78,  1.80, [mage]).
hero_stat(badang,        'A',   50.64,   2.78,  1.26, [fighter]).
hero_stat(tigreal,       'A',   45.13,  12.92,  2.51, [tank]).
hero_stat(barats,        'A',   51.97,   2.02,  0.43, [tank,fighter]).
hero_stat(aamon,         'A',   49.49,   5.91,  1.17, [assassin]).
hero_stat(nana,          'A',   47.83,   5.33,  2.15, [mage]).
hero_stat(bruno,         'A',   52.50,   0.26,  0.38, [marksman]).
hero_stat(benedetta,     'A',   52.47,   0.58,  0.34, [assassin,fighter]).
hero_stat(helcurt,       'A',   49.08,   8.79,  0.87, [assassin]).
hero_stat(hanzo,         'A',   50.45,   6.96,  0.37, [assassin]).
hero_stat(freya,         'A',   48.79,   9.10,  0.94, [fighter]).
hero_stat(x_borg,        'A',   50.72,   3.55,  0.62, [fighter]).
hero_stat(khaleed,       'A',   52.54,   0.12,  0.10, [fighter]).
hero_stat(xavier,        'A',   50.66,   0.83,  0.95, [mage]).
hero_stat(vale,          'A',   51.27,   0.30,  0.70, [mage]).
hero_stat(lunox,         'A',   51.58,   1.63,  0.33, [mage]).
hero_stat(bane,          'A',   51.84,   0.25,  0.37, [fighter,mage]).
hero_stat(gusion,        'A',   48.40,   4.62,  1.51, [assassin]).
hero_stat(kagura,        'A',   51.13,   1.39,  0.50, [mage]).
hero_stat(ixia,          'A',   50.25,   1.57,  0.92, [marksman]).
hero_stat(thamuz,        'A',   49.64,   2.58,  1.07, [fighter]).
hero_stat(selena,        'A',   48.66,   5.44,  1.12, [assassin,mage]).
hero_stat(yin,           'A',   50.13,   2.54,  0.74, [fighter,assassin]).
hero_stat(akai,          'A',   51.07,   1.62,  0.37, [tank]).
hero_stat(terizla,       'A',   51.47,   0.27,  0.34, [fighter]).
hero_stat(popol_and_kupa, 'A',   51.22,   0.81,  0.36, [marksman]).
hero_stat(kadita,        'A',   49.79,   3.96,  0.65, [mage,assassin]).
hero_stat(suyou,         'A',   49.68,   2.29,  0.93, [assassin,fighter]).
hero_stat(sora,          'A',   48.91,   7.93,  0.48, [fighter,assassin]).
hero_stat(kaja,          'A',   48.85,   8.65,  0.39, [support,fighter]).
hero_stat(guinevere,     'A',   50.05,   2.40,  0.67, [fighter]).
hero_stat(julian,        'A',   50.11,   1.29,  0.80, [fighter,mage]).
hero_stat(alpha,         'A',   48.59,   0.85,  1.59, [fighter]).
hero_stat(dyrroth,       'A',   47.91,   2.01,  1.76, [fighter]).
hero_stat(harley,        'A',   48.22,   4.99,  1.09, [assassin,mage]).
hero_stat(natan,         'A',   51.15,   0.16,  0.23, [marksman]).
hero_stat(fredrinn,      'A',   50.09,   2.33,  0.28, [fighter,tank]).
hero_stat(cici,          'A',   49.57,   2.13,  0.58, [fighter]).
hero_stat(uranus,        'B',   50.48,   0.46,  0.28, [tank]).
hero_stat(odette,        'B',   49.85,   0.33,  0.59, [mage]).
hero_stat(kalea,         'B',   49.61,   2.07,  0.44, [support,fighter]).
hero_stat(hylos,         'B',   50.16,   0.36,  0.32, [tank]).
hero_stat(cecilion,      'B',   49.67,   0.21,  0.60, [mage]).
hero_stat(leomord,       'B',   50.12,   1.13,  0.20, [fighter]).
hero_stat(brody,         'B',   49.18,   1.79,  0.60, [marksman]).
hero_stat(chang_e,       'B',   49.04,   0.48,  0.79, [mage]).
hero_stat(esmeralda,     'B',   48.15,   3.44,  0.80, [mage,tank]).
hero_stat(karrie,        'B',   49.32,   0.97,  0.53, [marksman]).
hero_stat(alucard,       'B',   49.37,   0.42,  0.56, [fighter,assassin]).
hero_stat(roger,         'B',   49.93,   0.12,  0.30, [fighter,marksman]).
hero_stat(moskov,        'B',   49.07,   0.32,  0.71, [marksman]).
hero_stat(clint,         'B',   48.95,   0.89,  0.59, [marksman]).
hero_stat(claude,        'B',   49.09,   0.31,  0.57, [marksman]).
hero_stat(lylia,         'B',   49.31,   0.62,  0.39, [mage]).
hero_stat(hayabusa,      'B',   48.20,   2.17,  0.74, [assassin]).
hero_stat(melissa,       'B',   48.95,   1.41,  0.43, [marksman]).
hero_stat(aurora,        'B',   48.77,   0.55,  0.65, [mage]).
hero_stat(ruby,          'B',   49.42,   0.65,  0.27, [fighter]).
hero_stat(yu_zhong,      'B',   48.76,   1.16,  0.53, [fighter]).
hero_stat(jawhead,       'B',   48.73,   0.68,  0.53, [fighter]).
hero_stat(yi_sun_shin,   'B',   47.89,   2.43,  0.69, [assassin,marksman]).
hero_stat(faramis,       'B',   49.45,   0.33,  0.05, [support,mage]).
hero_stat(beatrix,       'B',   48.54,   0.43,  0.45, [marksman]).
hero_stat(yve,           'B',   49.41,   0.05,  0.02, [mage]).
hero_stat(zilong,        'B',   47.45,   0.56,  0.96, [fighter,assassin]).
hero_stat(lapu_lapu,     'B',   48.47,   0.46,  0.30, [fighter]).
hero_stat(phoveus,       'C',   48.03,   1.96,  0.25, [fighter]).
hero_stat(balmond,       'C',   47.33,   0.48,  0.84, [fighter]).
hero_stat(kimmy,         'C',   47.13,   0.84,  0.70, [marksman,mage]).
hero_stat(chou,          'C',   45.21,   4.39,  1.19, [fighter]).
hero_stat(martis,        'C',   47.22,   0.60,  0.64, [fighter]).
hero_stat(grock,         'C',   47.33,   1.20,  0.41, [tank,fighter]).
hero_stat(arlott,        'D',   46.58,   0.85,  0.43, [fighter,assassin]).
hero_stat(wanwan,        'D',   47.33,   0.21,  0.12, [marksman]).
hero_stat(pharsa,        'D',   46.83,   0.23,  0.35, [mage]).
hero_stat(luo_yi,        'D',   47.10,   0.10,  0.16, [mage]).
hero_stat(chip,          'D',   46.95,   0.23,  0.03, [support,tank]).
hero_stat(gatotkaca,     'D',   45.51,   0.44,  0.75, [tank,fighter]).
hero_stat(zhuxin,        'D',   46.61,   0.30,  0.07, [mage]).
hero_stat(joy,           'D',   46.24,   0.21,  0.08, [assassin]).
hero_stat(baxia,         'D',   46.05,   0.10,  0.04, [tank]).
hero_stat(franco,        'D',   41.86,   3.83,  1.23, [tank]).
hero_stat(harith,        'D',   44.76,   0.07,  0.09, [mage]).
hero_stat(mathilda,      'D',   44.64,   0.18,  0.09, [support,assassin]).
hero_stat(lancelot,      'D',   42.93,   0.65,  0.49, [assassin]).
hero_stat(granger,       'D',   40.69,   2.55,  1.31, [marksman]).
hero_stat(fanny,         'D',   42.06,   2.25,  0.59, [assassin]).
hero_stat(valentina,     'D',   41.81,   0.09,  0.06, [mage]).

% ------------------------------------------------------------ lookups -------
:- discontiguous hero_alias/2.
% hero_alias(ApiId, StatsId).  Example:  hero_alias(popol_kupa, popol_and_kupa).

resolve(Id, Id) :- hero_stat(Id, _, _, _, _, _), !.
resolve(Id, S)  :- hero_alias(Id, S), hero_stat(S, _, _, _, _, _), !.

winrate(Id, WR)  :- resolve(Id, S), hero_stat(S, _, WR, _, _, _).
tier(Id, T)      :- resolve(Id, S), hero_stat(S, T, _, _, _, _).
pick_rate(Id, P) :- resolve(Id, S), hero_stat(S, _, _, _, P, _).
ban_rate(Id, B)  :- resolve(Id, S), hero_stat(S, _, _, B, _, _).
roles(Id, Rs)    :- resolve(Id, S), hero_stat(S, _, _, _, _, Rs).

league_average(Avg) :-
    findall(W, hero_stat(_, _, W, _, _, _), Ws),
    sum_list(Ws, Sum), length(Ws, N), Avg is Sum / N.

%% adjusted_winrate(+Hero, -Adj)  win rate shrunk toward the league average
adjusted_winrate(Id, Adj) :-
    winrate(Id, WR), pick_rate(Id, P),
    league_average(Avg), shrink_k(K),
    Adj is Avg + (WR - Avg) * P / (P + K).

top_heroes(N, Ids) :-
    findall(A-Id, (hero_stat(Id,_,_,_,_,_), adjusted_winrate(Id, A)), Ps),
    keysort(Ps, Asc), reverse(Asc, Desc),
    findall(Id, (nth1(I, Desc, _-Id), I =< N), Ids).

% ---------------------------------------------------------- team maths -----
%% team_rating(+Heroes, -Rating)
%  Mean adjusted win-rate edge over the league average (in % points).
team_rating(Heroes, Rating) :-
    Heroes \== [],
    maplist(adjusted_winrate, Heroes, Adjs),
    league_average(Avg),
    sum_list(Adjs, S), length(Adjs, N),
    Rating is S / N - Avg.

%% predict_winrate(+Mine, +Enemies, -Pct)
%  Mine/Enemies are lists of 1..5 hero ids (enemies may be []).
%  50% means an even match; clamped to 30..70.
predict_winrate(Mine, Enemies, Pct) :-
    team_rating(Mine, RM),
    (   Enemies == [] -> RE = 0 ; team_rating(Enemies, RE) ),
    team_scale(Sc),
    Raw is 50 + (RM - RE) * Sc,
    Clamped is max(30.0, min(70.0, Raw)),
    Pct is round(Clamped * 100) / 100.

% ------------------------------------------------------------- JSON --------
hero_dict(Id, _{id:Id, tier:T, winrate:W, adjusted:A, ban_rate:B,
                pick_rate:P, roles:Rs}) :-
    resolve(Id, S), hero_stat(S, T, W, B, P, Rs),
    adjusted_winrate(Id, A0), A is round(A0 * 100) / 100.

winrates_json(_{meta:Meta, league_average:Avg, heroes:Hs}) :-
    findall(K-V, stats_meta(K, V), KVs), dict_pairs(Meta, _, KVs),
    league_average(Avg0), Avg is round(Avg0 * 100) / 100,
    findall(D, (hero_stat(Id,_,_,_,_,_), hero_dict(Id, D)), Hs).

%% predict_json(+Mine, +Enemies, -Dict)  fails if any hero id is unknown
predict_json(Mine, Enemies, _{your_winrate:P, enemy_winrate:PE,
                              your_rating:RM, enemy_rating:RE,
                              mine:MD, enemies:ED}) :-
    Mine \== [],
    forall(member(H, Mine),    resolve(H, _)),
    forall(member(H, Enemies), resolve(H, _)),
    predict_winrate(Mine, Enemies, P),
    PE is round((100 - P) * 100) / 100,
    team_rating(Mine, RM0), RM is round(RM0 * 100) / 100,
    (   Enemies == [] -> RE = 0.0
    ;   team_rating(Enemies, RE0), RE is round(RE0 * 100) / 100 ),
    maplist(hero_dict, Mine, MD),
    maplist(hero_dict, Enemies, ED).
