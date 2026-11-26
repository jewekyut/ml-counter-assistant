% ============================================================================
% Mobile Legends: Bang Bang - Meta Analysis Module
% meta.pl - Current meta analysis, tier lists, and team composition advice
% ============================================================================
:- module(meta, [
    tier_list/0,
    tier_list_by_role/1,
    meta_heroes/1,
    ban_recommendations/0,
    team_comp_check/1,
    suggest_team_comp/1,
    meta_analysis/0,
    lane_recommendations/1,
    synergy/2,
    synergy_analysis/1,
    draft_helper/2
]).

:- use_module(heroes).
:- use_module(items).
:- use_module(counters).
:- use_module(season).

:- discontiguous meta_pick/1, ban_priority/2.

% ============================================================================
% META DEFINITIONS
% meta_pick(Hero) - heroes currently strong in the meta
% ban_priority(Hero, Priority) - 1 = must ban, 2 = should ban, 3 = situational
% ============================================================================



%% meta_pick/1 and ban_priority/2 now follow the season.pl snapshot.
meta_pick(H)        :- season_tier(H, T), memberchk(T, [s_plus, s]).
ban_priority(H, P)  :- season_ban(H, P).

tier_rank(s_plus, 0).
tier_rank(s, 1).
tier_rank(a, 2).
tier_rank(b, 3).
tier_rank(c, 4).

% ============================================================================
% TEAM COMPOSITION ARCHETYPES
% ============================================================================

%% Team composition roles needed
comp_role_needed(tank, 1, 'Frontline and crowd control').
comp_role_needed(fighter, 1, 'Side lane presence and durability').
comp_role_needed(assassin, 1, 'Jungle and burst damage').
comp_role_needed(mage, 1, 'Magic damage and crowd control').
comp_role_needed(marksman, 1, 'Sustained DPS and objective taking').

%% Synergy pairs - heroes that work well together
synergy(angela, aldous).
synergy(angela, yu_zhong).
synergy(angela, chou).
synergy(angela, paquito).

synergy(johnson, atlas).
synergy(johnson, vale).
synergy(johnson, gusion).
synergy(johnson, kagura).
synergy(johnson, odette).

synergy(atlas, vale).
synergy(atlas, valentina).
synergy(atlas, kagura).

synergy(tigreal, vale).
synergy(tigreal, kagura).
synergy(tigreal, valentina).

synergy(chip, fanny).
synergy(chip, lancelot).
synergy(chip, ling).
synergy(chip, hayabusa).

synergy(estes, yu_zhong).
synergy(estes, esmeralda).
synergy(estes, thamuz).

synergy(faramis, atlas).
synergy(faramis, tigreal).
synergy(faramis, chou).

synergy(mathilda, gusion).
synergy(mathilda, lancelot).
synergy(mathilda, joy).

synergy(diggie, fanny).
synergy(diggie, ling).

synergy(floryn, karrie).
synergy(floryn, claude).

% Bidirectional synergy check
has_synergy(A, B) :- synergy(A, B).
has_synergy(A, B) :- synergy(B, A).

% ============================================================================
% TIER LIST DISPLAY
% ============================================================================

%% tier_list/0 is det.
%  Displays the full tier list.
tier_list :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              CURRENT META TIER LIST                     ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n~n'),
    print_tier(s_plus, '★ S+ TIER (Must Ban/Pick)'),
    print_tier(s, '◆ S TIER (Top Meta Picks)'),
    print_tier(a, '● A TIER (Strong Picks)'),
    print_tier(b, '○ B TIER (Viable Picks)'),
    print_tier(c, '□ C TIER (Situational)'),
    nl.

print_tier(Tier, Label) :-
    heroes_by_tier(Tier, Heroes),
    ( Heroes \= []
    -> format('  ~w~n', [Label]),
       format('  '),
       print_hero_list_inline(Heroes),
       format('~n~n')
    ;  true
    ).

print_hero_list_inline([]).
print_hero_list_inline([H]) :-
    format_meta_name(H, FName),
    format('~w', [FName]).
print_hero_list_inline([H|T]) :-
    T \= [],
    format_meta_name(H, FName),
    format('~w, ', [FName]),
    print_hero_list_inline(T).

%% tier_list_by_role(+Role) is det.
%  Displays tier list filtered by role.
tier_list_by_role(Role) :-
    format('~n  ── ~w Tier List ──~n~n', [Role]),
    heroes_by_role(Role, RoleHeroes),
    findall(Rank-T-Hero,
            (member(Hero, RoleHeroes), hero_tier(Hero, T), tier_rank(T, Rank)),
            TierPairs),
    sort(1, @=<, TierPairs, Sorted),
    forall(
        member(_-T-H, Sorted),
        (   format_meta_name(H, FName),
            hero_difficulty(H, Diff),
            findall(L, hero_lane(H, L), Lanes),
            format('    [~w] ~w (Difficulty: ~w, Lanes: ~w)~n', [T, FName, Diff, Lanes])
        )
    ),
    nl.

% ============================================================================
% BAN RECOMMENDATIONS
% ============================================================================

%% ban_recommendations/0 is det.
%  Displays current ban recommendations.
ban_recommendations :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              BAN RECOMMENDATIONS                        ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n~n'),

    format('  ── MUST BAN (Priority 1) ──~n'),
    findall(H, ban_priority(H, 1), MustBans),
    forall(member(H, MustBans),
           (   format_meta_name(H, FName),
               findall(R, hero_role(H, R), Roles),
               format('    ✗ ~w (~w)~n', [FName, Roles])
           )),
    nl,

    format('  ── SHOULD BAN (Priority 2) ──~n'),
    findall(H, ban_priority(H, 2), ShouldBans),
    forall(member(H, ShouldBans),
           (   format_meta_name(H, FName),
               findall(R, hero_role(H, R), Roles),
               format('    ⚠ ~w (~w)~n', [FName, Roles])
           )),
    nl,

    format('  ── SITUATIONAL BAN (Priority 3) ──~n'),
    findall(H, ban_priority(H, 3), SitBans),
    forall(member(H, SitBans),
           (   format_meta_name(H, FName),
               findall(R, hero_role(H, R), Roles),
               format('    ○ ~w (~w)~n', [FName, Roles])
           )),
    nl.

% ============================================================================
% TEAM COMPOSITION ANALYSIS
% ============================================================================

%% team_comp_check(+Team) is det.
%  Analyzes a team composition for balance and issues.
team_comp_check(Team) :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              TEAM COMPOSITION CHECK                     ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n'),
    format('~n  Team: ~w~n~n', [Team]),

    % Role coverage
    format('  ── Role Coverage ──~n'),
    check_role_coverage(Team),
    nl,

    % Damage type balance
    format('  ── Damage Type Balance ──~n'),
    check_damage_balance(Team),
    nl,

    % Lane assignment
    format('  ── Suggested Lane Assignment ──~n'),
    suggest_lanes(Team),
    nl,

    % Synergies
    format('  ── Team Synergies ──~n'),
    check_synergies(Team),
    nl,

    % Weaknesses
    format('  ── Team Weaknesses ──~n'),
    check_team_weaknesses(Team),
    nl,

    % Power curve
    format('  ── Power Curve ──~n'),
    check_power_curve(Team),
    nl.

%% suggest_team_comp(+PartialTeam) is det.
%  Given some picked heroes, suggests remaining picks.
suggest_team_comp(PartialTeam) :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              TEAM COMPOSITION SUGGESTIONS               ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n'),
    format('~n  Current picks: ~w~n~n', [PartialTeam]),

    % Find missing roles
    findall(R, (comp_role_needed(R, _, _),
                \+ (member(H, PartialTeam), hero_role(H, R))),
            MissingRoles),
    sort(MissingRoles, UniqueMissing),
    format('  Missing roles: ~w~n~n', [UniqueMissing]),

    % Suggest heroes for missing roles
    forall(
        member(Role, UniqueMissing),
        (   format('  ── Suggestions for ~w ──~n', [Role]),
            findall(
                Score-Hero,
                (   hero_role(Hero, Role),
                    \+ member(Hero, PartialTeam),
                    team_fit_score(Hero, PartialTeam, Score),
                    Score > 0
                ),
                Candidates
            ),
            sort(1, @>=, Candidates, Sorted),
            take_n_meta(5, Sorted, Top5),
            forall(
                member(S-H, Top5),
                (   format_meta_name(H, FName),
                    hero_tier(H, Tier),
                    format('    ~w (Tier: ~w, Fit: ~w)~n', [FName, Tier, S])
                )
            ),
            nl
        )
    ).

%% draft_helper(+YourPicks, +EnemyPicks) is det.
%  Full drafting assistant for pick phase.
draft_helper(YourPicks, EnemyPicks) :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              DRAFT ASSISTANT                            ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n'),
    format('~n  Your picks  : ~w~n', [YourPicks]),
    format('  Enemy picks : ~w~n~n', [EnemyPicks]),

    % Counter pick recommendations
    format('  ── Counter Picks vs Enemy ──~n'),
    best_counter_for_team(EnemyPicks, CounterRecs),
    forall(
        member(Score-Hero, CounterRecs),
        (   format_meta_name(Hero, FName),
            hero_tier(Hero, Tier),
            findall(R, hero_role(Hero, R), Roles),
            format('    ~w (Tier: ~w, Roles: ~w, Counter Score: ~w)~n',
                   [FName, Tier, Roles, Score])
        )
    ),
    nl,

    % Missing roles in your team
    findall(R, (comp_role_needed(R, _, _),
                \+ (member(H, YourPicks), hero_role(H, R))),
            MissingRoles),
    sort(MissingRoles, UniqueMissing),
    ( UniqueMissing \= []
    -> format('  ── You still need: ~w ──~n~n', [UniqueMissing]),
       % Recommend heroes that both counter enemies AND fill missing roles
       forall(
           member(Role, UniqueMissing),
           (   format('  Best ~w picks (counter + role fit):~n', [Role]),
               findall(
                   Score-Hero,
                   (   hero_role(Hero, Role),
                       \+ member(Hero, YourPicks),
                       \+ member(Hero, EnemyPicks),
                       counter_score_against_team(Hero, EnemyPicks, CScore),
                       team_fit_score(Hero, YourPicks, FScore),
                       Score is CScore + FScore
                   ),
                   Candidates
               ),
               sort(1, @>=, Candidates, Sorted),
               take_n_meta(3, Sorted, Top3),
               forall(
                   member(S-H, Top3),
                   (   format_meta_name(H, FName),
                       hero_tier(H, Tier),
                       format('    ~w (Tier: ~w, Score: ~w)~n', [FName, Tier, S])
                   )
               ),
               nl
           )
       )
    ;  format('  ✓ All roles covered!~n~n')
    ).

% ============================================================================
% META ANALYSIS
% ============================================================================

%% meta_analysis/0 is det.
%  Prints comprehensive current meta analysis.
meta_analysis :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║              CURRENT META ANALYSIS                      ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n~n'),

    format('  ── Meta Overview ──~n'),
    format('    The current meta favors:~n'),
    format('    • High-mobility assassins with burst damage~n'),
    format('    • Heroes with CC immunity or invincibility frames~n'),
    format('    • Strong early-game roam aggression~n'),
    format('    • Anti-heal is essential due to sustain meta~n'),
    format('    • Tank/support with global presence or hard engage~n~n'),

    format('  ── Meta Strategies ──~n'),
    format('    1. Hyper Carry: Strong jungler + aggressive support~n'),
    format('       Core: Fanny/Ling/Lancelot + Mathilda/Chip~n'),
    format('    2. Sustain Comp: Healers + tanky fighters~n'),
    format('       Core: Estes/Floryn + Yu Zhong/Esmeralda~n'),
    format('    3. Dive Comp: Multiple engage + burst mage~n'),
    format('       Core: Atlas/Khufra + Vale/Kagura + Assassin jungle~n'),
    format('    4. Poke Comp: Long range + disengage~n'),
    format('       Core: Xavier/Pharsa/Cecilion + Lolita + Beatrix/Clint~n~n'),

    tier_list,
    ban_recommendations,

    format('  ── Role Meta Rankings ──~n~n'),
    forall(
        member(Role, [tank, fighter, assassin, mage, marksman, support]),
        tier_list_by_role(Role)
    ).

%% lane_recommendations(+Hero) is det.
%  Suggests the best lane for a hero.
lane_recommendations(Hero) :-
    hero(Hero),
    format_meta_name(Hero, FName),
    findall(L, hero_lane(Hero, L), Lanes),
    findall(R, hero_role(Hero, R), Roles),
    format('~n  ~w Lane Recommendations:~n', [FName]),
    format('  Roles: ~w~n', [Roles]),
    format('  Viable lanes: ~w~n', [Lanes]),
    ( member(jungle, Lanes)
    -> format('    → Can jungle: Yes~n')
    ;  format('    → Can jungle: No~n')
    ),
    ( member(roam, Lanes)
    -> format('    → Can roam: Yes~n')
    ;  format('    → Can roam: No~n')
    ),
    ( member(gold, Lanes)
    -> format('    → Gold lane: Yes~n')
    ;  true
    ),
    ( member(exp, Lanes)
    -> format('    → Exp lane: Yes~n')
    ;  true
    ),
    ( member(mid, Lanes)
    -> format('    → Mid lane: Yes~n')
    ;  true
    ),
    nl.

% ============================================================================
% INTERNAL HELPERS
% ============================================================================

check_role_coverage(Team) :-
    forall(
        comp_role_needed(Role, _, Desc),
        (   ( member(H, Team), hero_role(H, Role)
            -> format_meta_name(H, FName),
               format('    ✓ ~w: ~w (~w)~n', [Role, FName, Desc])
            ;  format('    ✗ ~w: MISSING (~w)~n', [Role, Desc])
            )
        )
    ).

check_damage_balance(Team) :-
    findall(E, (member(E, Team), hero_damage_type(E, physical)), PhysList),
    findall(E, (member(E, Team), hero_damage_type(E, magic)), MagList),
    findall(E, (member(E, Team), hero_damage_type(E, hybrid)), HybList),
    length(PhysList, PC),
    length(MagList, MC),
    length(HybList, HC),
    format('    Physical: ~w | Magic: ~w | Hybrid: ~w~n', [PC, MC, HC]),
    Total is PC + MC + HC,
    ( PC =:= Total, Total > 0
    -> format('    ⚠ WARNING: All physical damage! Enemy can stack armor!~n')
    ; MC =:= Total, Total > 0
    -> format('    ⚠ WARNING: All magic damage! Enemy can stack magic resist!~n')
    ; format('    ✓ Good damage type mix~n')
    ).

suggest_lanes(Team) :-
    forall(
        member(H, Team),
        (   format_meta_name(H, FName),
            findall(L, hero_lane(H, L), Lanes),
            findall(R, hero_role(H, R), Roles),
            format('    ~w (~w) → ~w~n', [FName, Roles, Lanes])
        )
    ).

check_synergies(Team) :-
    findall(A-B, (member(A, Team), member(B, Team), A @< B, has_synergy(A, B)), Pairs),
    ( Pairs = []
    -> format('    No notable synergies detected~n')
    ;  forall(
           member(A-B, Pairs),
           (   format_meta_name(A, AName),
               format_meta_name(B, BName),
               format('    ✦ ~w + ~w~n', [AName, BName])
           )
       )
    ).

check_team_weaknesses(Team) :-
    % Check for anti-heal vulnerability
    findall(H, (member(H, Team), hero_tag(H, sustain_hero)), SustainH),
    ( length(SustainH, SC), SC >= 2
    -> format('    ⚠ Vulnerable to anti-heal (many sustain heroes)~n')
    ;  true
    ),
    % Check for CC vulnerability
    findall(H, (member(H, Team), hero_tag(H, immobile_hero)), ImmobileH),
    ( length(ImmobileH, IC), IC >= 2
    -> format('    ⚠ Vulnerable to dive/engage (many immobile heroes)~n')
    ;  true
    ),
    % Check for late game dependency
    findall(H, (member(H, Team), hero_tag(H, late_game_carry)), LateH),
    findall(H, (member(H, Team), hero_tag(H, early_game)), EarlyH),
    ( length(LateH, LC), LC >= 2
    -> format('    ⚠ Late-game dependent team - may struggle early~n')
    ;  true
    ),
    ( length(EarlyH, EC), EC >= 3
    -> format('    ⚠ Early-game heavy - must end before late game~n')
    ;  true
    ),
    % Check for squishy team
    findall(H, (member(H, Team), (hero_role(H, tank) ; hero_tag(H, frontline))), TankyH),
    ( TankyH = []
    -> format('    ⚠ No frontline! Team lacks a tank or tanky fighter~n')
    ;  true
    ).

check_power_curve(Team) :-
    findall(H, (member(H, Team), hero_tag(H, early_game)), Early),
    findall(H, (member(H, Team), hero_tag(H, late_game_carry)), Late),
    findall(H, (member(H, Team), hero_tag(H, scaling_hero)), Scaling),
    length(Early, EC), length(Late, LC), length(Scaling, SC),
    TotalLate is LC + SC,
    ( EC >= 3
    -> format('    Power spike: EARLY GAME~n'),
       format('    Strategy: Aggressive early, end before 15 minutes~n')
    ; TotalLate >= 2
    -> format('    Power spike: LATE GAME~n'),
       format('    Strategy: Farm safely, avoid fights until core items~n')
    ; format('    Power spike: MID GAME~n'),
       format('    Strategy: Group for objectives after first core item~n')
    ).

%% synergy_analysis(+Team) is det.
synergy_analysis(Team) :-
    format('~n  ── Synergy Analysis for Team ──~n~n'),
    findall(A-B, (member(A, Team), member(B, Team), A @< B, has_synergy(A, B)), Pairs),
    ( Pairs = []
    -> format('    No synergies found. Consider swapping heroes for better synergy.~n')
    ;  forall(
           member(A-B, Pairs),
           (   format_meta_name(A, AName),
               format_meta_name(B, BName),
               format('    ✦ ~w + ~w synergize well together~n', [AName, BName])
           )
       )
    ),
    nl.

%% meta_heroes(-Heroes)
meta_heroes(Heroes) :-
    findall(H, meta_pick(H), Hs),
    sort(Hs, Heroes).

%% team_fit_score(+Hero, +ExistingTeam, -Score)
team_fit_score(Hero, Team, Score) :-
    % Tier bonus
    ( hero_tier(Hero, s_plus) -> TierScore = 4
    ; hero_tier(Hero, s)      -> TierScore = 3
    ; hero_tier(Hero, a)      -> TierScore = 2
    ; TierScore = 1
    ),
    % Meta bonus
    ( meta_pick(Hero) -> MetaScore = 2 ; MetaScore = 0 ),
    % Synergy bonus
    findall(1, (member(T, Team), has_synergy(Hero, T)), SynList),
    sum_list(SynList, SynScore),
    % Damage type diversity bonus
    hero_damage_type(Hero, DmgType),
    findall(D, (member(T, Team), hero_damage_type(T, D)), TeamDmg),
    ( \+ member(DmgType, TeamDmg) -> DivScore = 2 ; DivScore = 0 ),
    Score is TierScore + MetaScore + SynScore + DivScore.

take_n_meta(_, [], []).
take_n_meta(0, _, []) :- !.
take_n_meta(N, [H|T], [H|R]) :-
    N > 0, N1 is N - 1,
    take_n_meta(N1, T, R).

format_meta_name(Hero, FName) :-
    atom_string(Hero, Str),
    split_string(Str, "_", "", Parts),
    maplist(cap_meta_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', FName).

cap_meta_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).
