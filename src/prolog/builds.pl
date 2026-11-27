% ============================================================================
% Mobile Legends: Bang Bang - Counter Building Engine
% builds.pl - Item build recommendations based on enemy composition
% ============================================================================
:- module(builds, [
    recommend_build/3,
    counter_build_for_team/2,
    recommend_boots/2,
    recommend_anti_heal/2,
    recommend_defense/3,
    build_analysis/2
]).

:- use_module(heroes).
:- use_module(items).

% ===========================================================================
% BUILD TEMPLATES
% base_build(Role, DamageType, CoreItems)
% ============================================================================

base_build(marksman, physical, [swift_boots, berserkers_fury, windtalker, blade_of_despair]).
base_build(marksman, attack_speed, [swift_boots, demon_hunter_sword, golden_staff, corrosion_scythe]).
base_build(assassin, physical, [warrior_boots, blade_of_heptaseas, endless_battle, blade_of_despair]).
base_build(assassin, magic, [arcane_boots, lightning_truncheon, holy_crystal, genius_wand]).
base_build(fighter, physical, [warrior_boots, war_axe, haas_claws, hunter_strike]).
base_build(fighter, sustain, [warrior_boots, haas_claws, war_axe, queens_wings]).
base_build(mage, magic, [arcane_boots, lightning_truncheon, holy_crystal, divine_glaive]).
base_build(mage, poke, [magic_shoes, glowing_wand, ice_queen_wand, holy_crystal]).
base_build(tank, physical_def, [tough_boots, dominance_ice, antique_cuirass, blade_armor]).
base_build(tank, magic_def, [tough_boots, athenas_shield, radiant_armor, oracle]).
base_build(support, heal, [magic_shoes, oracle, athenas_shield, dominance_ice]).
base_build(support, utility, [tough_boots, dominance_ice, athenas_shield, immortality]).

% ============================================================================
% MAIN BUILD RECOMMENDATION
% ============================================================================

%% recommend_build(+YourHero, +EnemyTeam, -Build) is det.
%  Recommends a full 6-item build for your hero against the enemy team.
recommend_build(YourHero, EnemyTeam, Build) :-
    hero(YourHero),
    hero_role(YourHero, Role),
    hero_damage_type(YourHero, _DmgType),

    % Determine enemy damage composition
    count_enemy_damage_types(EnemyTeam, PhysCount, MagCount),

    % Choose boots
    recommend_boots(EnemyTeam, Boots),

    % Choose core items based on role
    get_core_items(YourHero, Role, CoreItems),

    % Choose defensive item
    recommend_defense(PhysCount, MagCount, DefItem),

    % Check for anti-heal need
    recommend_anti_heal(EnemyTeam, AntiHealItem),

    % Choose situational item
    recommend_situational(YourHero, EnemyTeam, SitItem),

    % Assemble build (remove duplicates, limit to 6)
    flatten([Boots, CoreItems, AntiHealItem, DefItem, SitItem], RawBuild),
    remove_nones(RawBuild, FilteredBuild),
    list_to_set(FilteredBuild, UniqueBuild),
    take_items(6, UniqueBuild, Build).

%% counter_build_for_team(+EnemyTeam, -BuildAdvice) is det.
%  Provides general build advice against an enemy team.
counter_build_for_team(EnemyTeam, BuildAdvice) :-
    count_enemy_damage_types(EnemyTeam, PhysCount, MagCount),
    check_sustain_threats(EnemyTeam, SustainAdvice),
    check_mobility_threats(EnemyTeam, MobilityAdvice),
    check_shield_threats(EnemyTeam, ShieldAdvice),
    check_dps_threats(EnemyTeam, DPSAdvice),
    check_burst_threats(EnemyTeam, BurstAdvice),
    BuildAdvice = build_advice{
        physical_threats: PhysCount,
        magic_threats: MagCount,
        sustain_advice: SustainAdvice,
        mobility_advice: MobilityAdvice,
        shield_advice: ShieldAdvice,
        dps_advice: DPSAdvice,
        burst_advice: BurstAdvice
    }.

%% build_analysis(+YourHero, +EnemyTeam) is det.
%  Prints comprehensive build analysis.
build_analysis(YourHero, EnemyTeam) :-
    format('~n╔══════════════════════════════════════════════════════════╗~n'),
    format('║           COUNTER-BUILD ANALYSIS                        ║~n'),
    format('╚══════════════════════════════════════════════════════════╝~n'),
    format_build_hero_name(YourHero, YName),
    format('~n  Your Hero  : ~w~n', [YName]),
    format('  Enemy Team : ~w~n~n', [EnemyTeam]),

    % Damage type analysis
    count_enemy_damage_types(EnemyTeam, PhysCount, MagCount),
    format('  ── Enemy Damage Breakdown ──~n'),
    format('    Physical damage dealers: ~w~n', [PhysCount]),
    format('    Magic damage dealers   : ~w~n', [MagCount]),
    nl,

    % Boots recommendation
    format('  ── Boots Recommendation ──~n'),
    recommend_boots(EnemyTeam, Boots),
    format_build_item_name(Boots, BName),
    format('    Recommended: ~w~n', [BName]),
    ( Boots = tough_boots
    -> format('    Reason: Heavy CC in enemy team~n')
    ; Boots = warrior_boots
    -> format('    Reason: Heavy physical damage in enemy team~n')
    ; format('    Reason: Best general option for your role~n')
    ),
    nl,

    % Anti-heal check
    format('  ── Anti-Heal Assessment ──~n'),
    findall(E, (member(E, EnemyTeam), hero_tag(E, sustain_hero)), SustainEnemies),
    findall(E, (member(E, EnemyTeam), hero_tag(E, healer)), HealerEnemies),
    append(SustainEnemies, HealerEnemies, AllSustain),
    sort(AllSustain, UniqueSustain),
    ( UniqueSustain \= []
    -> format('    ⚠ ANTI-HEAL REQUIRED!~n'),
       format('    Sustain/Heal threats: ~w~n', [UniqueSustain]),
       hero_role(YourHero, Role),
       ( (Role = mage ; Role = support ; hero_damage_type(YourHero, magic))
       -> format('    → Build Dominance Ice (aura anti-heal, works for magic users)~n')
       ; (Role = marksman ; Role = assassin ; Role = fighter)
       -> format('    → Build Sea Halberd (physical attacker)~n')
       ; format('    → Build Dominance Ice (tank/roamer)~n')
       )
    ;  format('    ✓ No significant sustain threats detected~n')
    ),
    nl,

    % Defense recommendation
    format('  ── Defense Recommendation ──~n'),
    recommend_defense(PhysCount, MagCount, DefItem),
    ( DefItem = none
    -> format('    No specific defense item needed~n')
    ;  format_build_item_name(DefItem, DName),
       format('    Recommended: ~w~n', [DName])
    ),
    nl,

    % Threat-specific items
    format('  ── Threat-Specific Items ──~n'),
    print_threat_items(EnemyTeam),
    nl,

    % Full build recommendation
    format('  ── Recommended Full Build ──~n'),
    ( recommend_build(YourHero, EnemyTeam, Build)
    -> print_build_list(Build, 1)
    ;  format('    Could not generate specific build. Use base build for your role.~n')
    ),
    nl.

% ============================================================================
% INTERNAL PREDICATES
% ============================================================================

%% count_enemy_damage_types(+EnemyTeam, -PhysCount, -MagCount)
count_enemy_damage_types(EnemyTeam, PhysCount, MagCount) :-
    findall(E, (member(E, EnemyTeam), hero_damage_type(E, physical)), PhysList),
    findall(E, (member(E, EnemyTeam), hero_damage_type(E, magic)), MagList),
    length(PhysList, PhysCount),
    length(MagList, MagCount).

%% recommend_boots(+EnemyTeam, -Boots)
recommend_boots(EnemyTeam, Boots) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, cc_heavy)), CCList),
    length(CCList, CCCount),
    count_enemy_damage_types(EnemyTeam, PhysCount, MagCount),
    ( CCCount >= 2 -> Boots = tough_boots
    ; PhysCount >= 3 -> Boots = warrior_boots
    ; MagCount >= 3 -> Boots = tough_boots
    ; PhysCount > MagCount -> Boots = warrior_boots
    ; Boots = tough_boots
    ).

%% recommend_anti_heal(+EnemyTeam, -Item)
recommend_anti_heal(EnemyTeam, Item) :-
    findall(E, (member(E, EnemyTeam),
                (hero_tag(E, sustain_hero) ; hero_tag(E, healer) ; hero_tag(E, lifesteal_hero))),
            SustainList),
    sort(SustainList, UniqueSustain),
    length(UniqueSustain, SCount),
    ( SCount >= 1
    -> Item = dominance_ice  % Default anti-heal; role-specific chosen in full build
    ;  Item = none
    ).

%% recommend_defense(+PhysCount, +MagCount, -Item)
recommend_defense(PhysCount, MagCount, Item) :-
    ( PhysCount >= 3 -> Item = antique_cuirass
    ; MagCount >= 3 -> Item = athenas_shield
    ; PhysCount > MagCount -> Item = antique_cuirass
    ; MagCount > PhysCount -> Item = athenas_shield
    ; Item = immortality
    ).

%% get_core_items(+Hero, +Role, -Items)
get_core_items(Hero, Role, Items) :-
    ( Role = marksman
    -> ( hero_damage_type(Hero, magic)
       -> Items = [lightning_truncheon, holy_crystal, divine_glaive]
       ;  hero_tag(Hero, dps_hero)
       -> Items = [demon_hunter_sword, golden_staff, great_dragon_spear]
       ;  Items = [berserkers_fury, windtalker, blade_of_despair]
       )
    ; Role = assassin
    -> ( hero_damage_type(Hero, magic)
       -> Items = [lightning_truncheon, holy_crystal, genius_wand]
       ;  Items = [blade_of_heptaseas, endless_battle, blade_of_despair]
       )
    ; Role = fighter
    -> ( hero_tag(Hero, sustain_hero)
       -> Items = [haas_claws, war_axe, queens_wings]
       ;  Items = [war_axe, hunter_strike, blade_of_despair]
       )
    ; Role = mage
    -> ( hero_tag(Hero, poke_hero)
       -> Items = [glowing_wand, ice_queen_wand, holy_crystal]
       ;  Items = [lightning_truncheon, holy_crystal, divine_glaive]
       )
    ; Role = tank
    -> Items = [dominance_ice, antique_cuirass, athenas_shield]
    ; Role = support
    -> Items = [oracle, athenas_shield, dominance_ice]
    ; Items = [immortality]
    ).

%% recommend_situational(+Hero, +EnemyTeam, -Item)
recommend_situational(_Hero, EnemyTeam, Item) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, burst_hero)), BurstList),
    findall(E, (member(E, EnemyTeam), hero_tag(E, dps_hero)), DPSList),
    findall(E, (member(E, EnemyTeam), hero_tag(E, crit_hero)), CritList),
    length(BurstList, BurstCount),
    length(DPSList, DPSCount),
    length(CritList, CritCount),
    ( CritCount >= 2 -> Item = blade_armor
    ; DPSCount >= 2 -> Item = blade_armor
    ; BurstCount >= 2 -> Item = immortality
    ; Item = immortality
    ).

%% check helpers
check_sustain_threats(EnemyTeam, Advice) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, sustain_hero)), List),
    ( List \= []
    -> Advice = need_anti_heal(List)
    ;  Advice = no_sustain_threat
    ).

check_mobility_threats(EnemyTeam, Advice) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, mobile_hero)), List),
    ( List \= []
    -> Advice = need_slow_items(List)
    ;  Advice = no_mobility_threat
    ).

check_shield_threats(EnemyTeam, Advice) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, shield_hero)), List),
    ( List \= []
    -> Advice = need_shield_counter(List)
    ;  Advice = no_shield_threat
    ).

check_dps_threats(EnemyTeam, Advice) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, dps_hero)), List),
    ( List \= []
    -> Advice = need_armor_items(List)
    ;  Advice = no_dps_threat
    ).

check_burst_threats(EnemyTeam, Advice) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, burst_hero)), List),
    ( List \= []
    -> Advice = need_hp_defense(List)
    ;  Advice = no_burst_threat
    ).

%% Printing helpers
print_threat_items(EnemyTeam) :-
    findall(E, (member(E, EnemyTeam), hero_tag(E, sustain_hero)), Sustain),
    findall(E, (member(E, EnemyTeam), hero_tag(E, dps_hero)), DPS),
    findall(E, (member(E, EnemyTeam), hero_tag(E, burst_hero)), Burst),
    findall(E, (member(E, EnemyTeam), hero_tag(E, crit_hero)), Crit),
    findall(E, (member(E, EnemyTeam), hero_tag(E, shield_hero)), Shield),
    ( Sustain \= []
    -> format('    vs Sustain (~w): Sea Halberd / Dominance Ice~n', [Sustain])
    ; true ),
    ( DPS \= []
    -> format('    vs DPS (~w): Blade Armor / Antique Cuirass~n', [DPS])
    ; true ),
    ( Burst \= []
    -> format('    vs Burst (~w): Immortality / Wind of Nature~n', [Burst])
    ; true ),
    ( Crit \= []
    -> format('    vs Crit (~w): Blade Armor / Wind of Nature~n', [Crit])
    ; true ),
    ( Shield \= []
    -> format('    vs Shield (~w): Dominance Ice~n', [Shield])
    ; true ).

print_build_list([], _).
print_build_list([Item|Rest], N) :-
    format_build_item_name(Item, FName),
    ( item_passive(Item, Passive)
    -> format('    ~w. ~w~n       └─ ~w~n', [N, FName, Passive])
    ;  format('    ~w. ~w~n', [N, FName])
    ),
    N1 is N + 1,
    print_build_list(Rest, N1).

remove_nones([], []).
remove_nones([none|T], R) :- !, remove_nones(T, R).
remove_nones([H|T], [H|R]) :- remove_nones(T, R).

take_items(_, [], []).
take_items(0, _, []) :- !.
take_items(N, [H|T], [H|R]) :-
    N > 0, N1 is N - 1,
    take_items(N1, T, R).

format_build_hero_name(Hero, FName) :-
    atom_string(Hero, Str),
    split_string(Str, "_", "", Parts),
    maplist(cap_build_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', FName).

format_build_item_name(Item, FName) :-
    atom_string(Item, Str),
    split_string(Str, "_", "", Parts),
    maplist(cap_build_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', FName).

cap_build_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).
