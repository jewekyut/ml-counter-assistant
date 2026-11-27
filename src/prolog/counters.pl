% ============================================================================
% Mobile Legends: Bang Bang - Counter Picking Engine
% counters.pl - Hero counter relationships and counter-pick recommendations
% ============================================================================
:- module(counters, [
    counters/2,
    soft_counter/2,
    hard_counter/2,
    counter_reason/3,
    get_counter_picks/2,
    get_countered_by/2,
    best_counter_for_team/2,
    counter_pick_analysis/1,
    why_counter/2,
    counter_score_against_team/3
]).

:- use_module(heroes).
:- use_module(items).

:- discontiguous hard_counter/2, soft_counter/2, counter_reason/3.

% ============================================================================
% HARD COUNTERS - Strong matchup advantages
% hard_counter(Counter, Target) - Counter strongly beats Target
% ===========================================================================

% --- Anti-dash heroes countered by Khufra ---
hard_counter(khufra, fanny).
counter_reason(khufra, fanny, 'Khufra ball bouncing stops Fanny cables completely').
hard_counter(khufra, lancelot).
counter_reason(khufra, lancelot, 'Khufra ball cancels Lancelot dashes').
hard_counter(khufra, benedetta).
counter_reason(khufra, benedetta, 'Khufra ball bouncing interrupts Benedetta dashes').
hard_counter(khufra, guinevere).
counter_reason(khufra, guinevere, 'Khufra ball stops Guinevere jump engage').
hard_counter(khufra, ling).
counter_reason(khufra, ling, 'Khufra ball prevents Ling from dashing away').

% --- Anti-heal counters sustain heroes ---
hard_counter(x_borg, yu_zhong).
counter_reason(x_borg, yu_zhong, 'X.Borg built-in anti-heal and true damage counters Yu Zhong sustain').
hard_counter(x_borg, esmeralda).
counter_reason(x_borg, esmeralda, 'X.Borg true damage ignores Esmeralda shields').
hard_counter(x_borg, thamuz).
counter_reason(x_borg, thamuz, 'X.Borg anti-heal reduces Thamuz sustain significantly').

% --- Burst counters squishy heroes ---
hard_counter(saber, pharsa).
counter_reason(saber, pharsa, 'Saber ult suppression stops Pharsa ult and kills her instantly').
hard_counter(saber, yve).
counter_reason(saber, yve, 'Saber ult cancels Yve ult and eliminates her').
hard_counter(saber, cecilion).
counter_reason(saber, cecilion, 'Saber suppression kills immobile Cecilion easily').

% --- Lolita vs projectile heroes ---
hard_counter(lolita, beatrix).
counter_reason(lolita, beatrix, 'Lolita shield blocks all Beatrix weapon projectiles').
hard_counter(lolita, clint).
counter_reason(lolita, clint, 'Lolita shield blocks Clint enhanced attacks and skills').
hard_counter(lolita, irithel).
counter_reason(lolita, irithel, 'Lolita shield blocks Irithel basic attacks entirely').
hard_counter(lolita, bruno).
counter_reason(lolita, bruno, 'Lolita shield blocks Bruno bouncing ball and attacks').
hard_counter(lolita, pharsa).
counter_reason(lolita, pharsa, 'Lolita shield blocks Pharsa ult projectiles').
hard_counter(lolita, xavier).
counter_reason(lolita, xavier, 'Lolita shield blocks Xavier skill projectiles').
hard_counter(lolita, cecilion).
counter_reason(lolita, cecilion, 'Lolita shield blocks Cecilion bat projectiles').

% --- CC counters mobile assassins ---
hard_counter(franco, fanny).
counter_reason(franco, fanny, 'Franco ult suppression stops Fanny completely').
hard_counter(franco, ling).
counter_reason(franco, ling, 'Franco hook pulls Ling off walls, ult suppresses him').

% --- Karrie vs tanks ---
hard_counter(karrie, hylos).
counter_reason(karrie, hylos, 'Karrie true damage passive shreds Hylos massive HP pool').
hard_counter(karrie, belerick).
counter_reason(karrie, belerick, 'Karrie true damage ignores Belerick defenses').
hard_counter(karrie, atlas).
counter_reason(karrie, atlas, 'Karrie true damage destroys high-HP tanks quickly').
hard_counter(karrie, grock).
counter_reason(karrie, grock, 'Karrie true damage penetrates Grock defenses easily').
hard_counter(karrie, johnson).
counter_reason(karrie, johnson, 'Karrie percent-based true damage melts Johnson armor').

% --- Diggie anti-CC counters CC-heavy teams ---
hard_counter(diggie, atlas).
counter_reason(diggie, atlas, 'Diggie ult cleanses Atlas ult pull on entire team').
hard_counter(diggie, tigreal).
counter_reason(diggie, tigreal, 'Diggie ult prevents Tigreal combo from locking down team').
hard_counter(diggie, franco).
counter_reason(diggie, franco, 'Diggie ult can remove CC from Franco hook target').

% --- Valentina special counters ---
hard_counter(valentina, atlas).
counter_reason(valentina, atlas, 'Valentina can steal Atlas devastating AoE ult').
hard_counter(valentina, johnson).
counter_reason(valentina, johnson, 'Valentina can steal Johnson car ult for her own engages').

% --- Melissa anti-melee zone ---
hard_counter(melissa, yu_zhong).
counter_reason(melissa, yu_zhong, 'Melissa binding zone prevents Yu Zhong from engaging').
hard_counter(melissa, paquito).
counter_reason(melissa, paquito, 'Melissa zone keeps melee Paquito at bay').
hard_counter(melissa, chou).
counter_reason(melissa, chou, 'Melissa zone punishes Chou for diving in').

% --- Wanwan purify vs CC-reliant heroes ---
hard_counter(wanwan, guinevere).
counter_reason(wanwan, guinevere, 'Wanwan passive purifies Guinevere knock-up combo').
hard_counter(wanwan, franco).
counter_reason(wanwan, franco, 'Wanwan can purify Franco hook with dash passive').

% --- Split push counters teamfight comps ---
hard_counter(hayabusa, tigreal).
counter_reason(hayabusa, tigreal, 'Hayabusa split push avoids Tigreal teamfight strength').

% --- Helcurt silence counters combo-dependent heroes ---
hard_counter(helcurt, gusion).
counter_reason(helcurt, gusion, 'Helcurt silence prevents Gusion combo execution').
hard_counter(helcurt, kagura).
counter_reason(helcurt, kagura, 'Helcurt silence stops Kagura umbrella combo').
hard_counter(helcurt, guinevere).
counter_reason(helcurt, guinevere, 'Helcurt silence prevents Guinevere ult after knock-up').

% --- Faramis resurrection vs burst comps ---
hard_counter(faramis, saber).
counter_reason(faramis, saber, 'Faramis can resurrect ally after Saber ult assassination').

% ============================================================================
% SOFT COUNTERS - Moderate matchup advantages
% soft_counter(Counter, Target) - Counter has advantage vs Target
% ============================================================================

soft_counter(esmeralda, lolita).
counter_reason(esmeralda, lolita, 'Esmeralda absorbs Lolita shields for sustain').
soft_counter(esmeralda, angela).
counter_reason(esmeralda, angela, 'Esmeralda absorbs Angela shields').

soft_counter(vale, fanny).
counter_reason(vale, fanny, 'Vale CC-enhanced skills can interrupt Fanny cables').
soft_counter(vale, ling).
counter_reason(vale, ling, 'Vale knock-up can disrupt Ling wall walking').

soft_counter(chou, cecilion).
counter_reason(chou, cecilion, 'Chou can easily engage and kick immobile Cecilion').
soft_counter(chou, pharsa).
counter_reason(chou, pharsa, 'Chou can dash in and kick Pharsa out of ult').

soft_counter(paquito, esmeralda).
counter_reason(paquito, esmeralda, 'Paquito burst can overcome Esmeralda shield sustain').
soft_counter(paquito, thamuz).
counter_reason(paquito, thamuz, 'Paquito can burst Thamuz before sustain kicks in').

soft_counter(akai, fanny).
counter_reason(akai, fanny, 'Akai ult pins Fanny to wall, stopping her cables').

soft_counter(johnson, gusion).
counter_reason(johnson, gusion, 'Johnson car stun catches Gusion before combo').

soft_counter(aldous, pharsa).
counter_reason(aldous, pharsa, 'Aldous ult global targets immobile Pharsa easily').
soft_counter(aldous, xavier).
counter_reason(aldous, xavier, 'Aldous ult targets immobile Xavier easily').

soft_counter(kagura, yu_zhong).
counter_reason(kagura, yu_zhong, 'Kagura umbrella poke and purify keep distance from Yu Zhong').

soft_counter(benedetta, esmeralda).
counter_reason(benedetta, esmeralda, 'Benedetta burst and dashes can outplay Esmeralda').

soft_counter(lunox, hylos).
counter_reason(lunox, hylos, 'Lunox dark ult ignores defense and shreds high HP').
soft_counter(lunox, belerick).
counter_reason(lunox, belerick, 'Lunox penetration bypass deals consistent damage to tanks').

soft_counter(joy, franco).
counter_reason(joy, franco, 'Joy CC immunity during ult avoids Franco suppression').
soft_counter(joy, saber).
counter_reason(joy, saber, 'Joy can dash away and become CC immune vs Saber ult').

soft_counter(ruby, tigreal).
counter_reason(ruby, tigreal, 'Ruby CC chain can interrupt and outplay Tigreal combos').

soft_counter(arlott, thamuz).
counter_reason(arlott, thamuz, 'Arlott burst and CC can overwhelm Thamuz early').

soft_counter(gusion, clint).
counter_reason(gusion, clint, 'Gusion burst combo one-shots immobile Clint').
soft_counter(gusion, beatrix).
counter_reason(gusion, beatrix, 'Gusion quick combo can delete Beatrix before she reacts').

soft_counter(lancelot, brody).
counter_reason(lancelot, brody, 'Lancelot invincibility frames dodge Brody stacking').
soft_counter(lancelot, clint).
counter_reason(lancelot, clint, 'Lancelot mobility overwhelms immobile Clint').

% ============================================================================
% NOVEMBER 2026 META ADDITIONS
% ============================================================================

hard_counter(phoveus, yi_sun_shin).
counter_reason(phoveus, yi_sun_shin, 'Phoveus cooldowns shrink whenever nearby enemies dash, which shuts down Yi Sun-shin mobility').
hard_counter(phoveus, freya).
counter_reason(phoveus, freya, 'Phoveus punishes Freya dashes by cutting his own skill cooldowns').
hard_counter(phoveus, wanwan).
counter_reason(phoveus, wanwan, 'Phoveus thrives against dash-heavy heroes like Wanwan').

hard_counter(karrie, phoveus).
counter_reason(karrie, phoveus, 'Karrie true damage and percent-HP hits ignore Phoveus defenses').
hard_counter(karrie, gloo).
counter_reason(karrie, gloo, 'Gloo is weak to true damage and percent-HP damage, which Karrie delivers').
soft_counter(karrie, uranus).
counter_reason(karrie, uranus, 'Karrie true damage cuts through Uranus sustain and HP pool').
soft_counter(karrie, minotaur).
counter_reason(karrie, minotaur, 'Karrie true damage melts tanks that stack health').

hard_counter(saber, hirara).
counter_reason(saber, hirara, 'Saber ult picks off agile assassins like Hirara before they escape').
hard_counter(saber, nolan).
counter_reason(saber, nolan, 'Saber ult stops Nolan mobility and kills him in a single lock').
hard_counter(saber, obsidia).
counter_reason(saber, obsidia, 'Saber ult catches Obsidia before she reaches her power spike').

soft_counter(ling, kimmy).
counter_reason(ling, kimmy, 'Ling can reach and kill Kimmy faster than she can react').
soft_counter(lancelot, kimmy).
counter_reason(lancelot, kimmy, 'Lancelot dives backliners such as Kimmy with invincibility frames').

soft_counter(tigreal, julian).
counter_reason(tigreal, julian, 'Julian struggles against heavy crowd control, which Tigreal provides').
soft_counter(jawhead, julian).
counter_reason(jawhead, julian, 'Jawhead throw and CC catch Julian before he can snowball').

soft_counter(belerick, miya).
counter_reason(belerick, miya, 'Belerick taunt and thorns punish basic-attack heroes like Miya').
soft_counter(belerick, bruno).
counter_reason(belerick, bruno, 'Belerick thorns reflect damage from Bruno basic attacks').
soft_counter(atlas, eudora).
counter_reason(atlas, eudora, 'High-sustain tank lines with Atlas make it hard for Eudora to finish her combo').

% ============================================================================
% GENERAL TAG-BASED COUNTERS (rule-based)
% ============================================================================

%% counters(Counter, Target) is nondet.
%  True if Counter hero has an advantage against Target hero.
counters(Counter, Target) :-
    hard_counter(Counter, Target).
counters(Counter, Target) :-
    soft_counter(Counter, Target).

% Tag-based counter logic
counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, anti_dash),
    hero_tag(Target, dash_hero).

counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, anti_projectile),
    hero_tag(Target, long_range).

counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, anti_tank),
    hero_tag(Target, frontline).

counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, anti_cc),
    hero_tag(Target, cc_heavy).

counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, silence_hero),
    hero_tag(Target, combo_hero).

counters(Counter, Target) :-
    hero(Counter),
    hero(Target),
    Counter \= Target,
    hero_tag(Counter, anti_melee),
    hero_tag(Target, frontline),
    \+ hero_tag(Target, long_range).

% ============================================================================
% COUNTER-PICK RECOMMENDATION PREDICATES
% ============================================================================

%% get_counter_picks(+EnemyHero, -Counters) is det.
%  Returns a list of Counter-Type pairs for the given enemy hero.
get_counter_picks(Enemy, Counters) :-
    hero(Enemy),
    findall(
        counter(Hero, hard),
        hard_counter(Hero, Enemy),
        HardCounters
    ),
    findall(
        counter(Hero, soft),
        soft_counter(Hero, Enemy),
        SoftCounters
    ),
    findall(
        counter(Hero, tag_based),
        (   counters(Hero, Enemy),
            \+ hard_counter(Hero, Enemy),
            \+ soft_counter(Hero, Enemy)
        ),
        TagCounters
    ),
    append([HardCounters, SoftCounters, TagCounters], AllCounters),
    sort(2, @=<, AllCounters, Sorted),
    remove_duplicates_counter(Sorted, Counters).

remove_duplicates_counter([], []).
remove_duplicates_counter([counter(H,T)|Rest], [counter(H,T)|Filtered]) :-
    exclude(same_hero(H), Rest, Remaining),
    remove_duplicates_counter(Remaining, Filtered).

same_hero(H, counter(H, _)).

%% get_countered_by(+Hero, -Counters) is det.
%  Returns what counters the given hero.
get_countered_by(Hero, Counters) :-
    hero(Hero),
    findall(
        counter(Enemy, hard),
        hard_counter(Enemy, Hero),
        HardCounters
    ),
    findall(
        counter(Enemy, soft),
        soft_counter(Enemy, Hero),
        SoftCounters
    ),
    append(HardCounters, SoftCounters, Counters).

%% best_counter_for_team(+EnemyTeam, -Recommendations) is det.
%  Given a list of enemy heroes, recommends the best counter picks.
best_counter_for_team(EnemyTeam, Recommendations) :-
    findall(
        Score-Hero,
        (   hero(Hero),
            \+ member(Hero, EnemyTeam),
            counter_score_against_team(Hero, EnemyTeam, Score),
            Score > 0
        ),
        ScoredHeroes
    ),
    sort(1, @>=, ScoredHeroes, Sorted),
    take_n(10, Sorted, Recommendations).

%% counter_score_against_team(+Hero, +EnemyTeam, -Score) is det.
%  Calculates how well a hero counters the enemy team.
counter_score_against_team(Hero, EnemyTeam, Score) :-
    findall(3, (member(E, EnemyTeam), hard_counter(Hero, E)), HardScores),
    findall(2, (member(E, EnemyTeam), soft_counter(Hero, E)), SoftScores),
    findall(1, (member(E, EnemyTeam),
                counters(Hero, E),
                \+ hard_counter(Hero, E),
                \+ soft_counter(Hero, E)), TagScores),
    sum_list(HardScores, HS),
    sum_list(SoftScores, SS),
    sum_list(TagScores, TS),
    % Bonus for meta tier
    ( hero_tier(Hero, s_plus) -> TierBonus = 2
    ; hero_tier(Hero, s)      -> TierBonus = 1
    ; TierBonus = 0
    ),
    Score is HS + SS + TS + TierBonus.

%% counter_pick_analysis(+EnemyTeam) is det.
%  Prints a full counter-pick analysis for the enemy team.
counter_pick_analysis(EnemyTeam) :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║           COUNTER-PICK ANALYSIS                         ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n'),
    format('~n  Enemy Team: ~w~n~n', [EnemyTeam]),

    % Analyze each enemy
    format('  ── Individual Hero Counters ──~n~n'),
    forall(
        member(Enemy, EnemyTeam),
        (   format_hero_name_counter(Enemy, FName),
            format('  ▸ Counters for ~w:~n', [FName]),
            get_counter_picks(Enemy, Picks),
            ( Picks = []
            -> format('      No specific counters found~n')
            ;  forall(
                   member(counter(H, Type), Picks),
                   (   format_hero_name_counter(H, HName),
                       ( counter_reason(H, Enemy, Reason)
                       -> format('      [~w] ~w - ~w~n', [Type, HName, Reason])
                       ;  format('      [~w] ~w~n', [Type, HName])
                       )
                   )
               )
            ),
            nl
        )
    ),

    % Team-wide recommendations
    format('  ── Best Overall Counter Picks ──~n~n'),
    best_counter_for_team(EnemyTeam, Recs),
    print_recommendations(Recs, 1),
    nl,

    % Team composition analysis
    analyze_enemy_comp_tags(EnemyTeam).

%% why_counter(+Counter, +Target) is det.
%  Explains why one hero counters another.
why_counter(Counter, Target) :-
    format_hero_name_counter(Counter, CName),
    format_hero_name_counter(Target, TName),
    format('~n  Why ~w counters ~w:~n~n', [CName, TName]),
    ( hard_counter(Counter, Target)
    -> format('    ★ HARD COUNTER~n'),
       counter_reason(Counter, Target, Reason),
       format('    Reason: ~w~n', [Reason])
    ; soft_counter(Counter, Target)
    -> format('    ◆ SOFT COUNTER~n'),
       counter_reason(Counter, Target, Reason),
       format('    Reason: ~w~n', [Reason])
    ; counters(Counter, Target)
    -> format('    ○ TAG-BASED COUNTER~n'),
       findall(T, (hero_tag(Counter, T)), CTags),
       findall(T, (hero_tag(Target, T)), TTags),
       format('    ~w tags: ~w~n', [CName, CTags]),
       format('    ~w tags: ~w~n', [TName, TTags])
    ; format('    ✗ ~w does not counter ~w~n', [CName, TName])
    ),
    nl.

% ============================================================================
% INTERNAL HELPERS
% ============================================================================

analyze_enemy_comp_tags(EnemyTeam) :-
    format('  ── Enemy Team Characteristics ──~n~n'),
    % Count damage types
    findall(physical, (member(E, EnemyTeam), hero_damage_type(E, physical)), PhysList),
    findall(magic, (member(E, EnemyTeam), hero_damage_type(E, magic)), MagList),
    findall(hybrid, (member(E, EnemyTeam), hero_damage_type(E, hybrid)), HybList),
    length(PhysList, PhysCount),
    length(MagList, MagCount),
    length(HybList, HybCount),
    format('    Physical damage dealers: ~w~n', [PhysCount]),
    format('    Magic damage dealers   : ~w~n', [MagCount]),
    format('    Hybrid damage dealers  : ~w~n', [HybCount]),
    nl,

    % Check for sustain heroes
    findall(E, (member(E, EnemyTeam), hero_tag(E, sustain_hero)), SustainHeroes),
    ( SustainHeroes \= []
    -> format('    ⚠ SUSTAIN DETECTED: ~w~n', [SustainHeroes]),
       format('      → Build anti-heal items (Sea Halberd / Dominance Ice)~n~n')
    ;  true
    ),

    % Check for high mobility
    findall(E, (member(E, EnemyTeam), hero_tag(E, mobile_hero)), MobileHeroes),
    ( MobileHeroes \= []
    -> format('    ⚠ HIGH MOBILITY DETECTED: ~w~n', [MobileHeroes]),
       format('      → Pick CC-heavy heroes or Khufra to counter dashes~n~n')
    ;  true
    ),

    % Check for CC-heavy team
    findall(E, (member(E, EnemyTeam), hero_tag(E, cc_heavy)), CCHeroes),
    ( length(CCHeroes, CCCount), CCCount >= 2
    -> format('    ⚠ CC-HEAVY TEAM: ~w~n', [CCHeroes]),
       format('      → Consider Diggie or Tough Boots / Purify battle spell~n~n')
    ;  true
    ).

print_recommendations([], _).
print_recommendations([Score-Hero|Rest], N) :-
    N =< 10,
    format_hero_name_counter(Hero, FName),
    hero_tier(Hero, Tier),
    findall(R, hero_role(Hero, R), Roles),
    format('    ~w. ~w (Tier: ~w, Role: ~w, Score: ~w)~n', [N, FName, Tier, Roles, Score]),
    N1 is N + 1,
    print_recommendations(Rest, N1).
print_recommendations(_, N) :- N > 10.

take_n(_, [], []).
take_n(0, _, []) :- !.
take_n(N, [H|T], [H|R]) :-
    N > 0,
    N1 is N - 1,
    take_n(N1, T, R).

format_hero_name_counter(Hero, FName) :-
    atom_string(Hero, Str),
    split_string(Str, "_", "", Parts),
    maplist(cap_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', FName).

cap_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).
