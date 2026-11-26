% ============================================================================
% Mobile Legends: Bang Bang - Assistant System
% main.pl - Main entry point and interactive menu system
%
% Title: Mobile Legends Assistant for Counter Picking,
%        Counter-Building, and Current Meta Analysis
%
% Usage: Load in SWI-Prolog with: ?- [main].
%        Then start with:         ?- start.
% ============================================================================

:- use_module(heroes).
:- use_module(items).
:- use_module(counters).
:- use_module(builds).
:- use_module(meta).

% ============================================================================
% MAIN MENU SYSTEM
% ============================================================================

%% start/0 is det.
%  Launches the Mobile Legends Assistant.
start :-
    print_banner,
    main_menu.

%% print_banner/0 is det.
print_banner :-
    nl,
    format('  ╔══════════════════════════════════════════════════════════════╗~n'),
    format('  ║                                                            ║~n'),
    format('  ║      ███╗   ███╗ ██╗         █████╗ ███████╗███████╗████╗  ║~n'),
    format('  ║      ████╗ ████║ ██║        ██╔══██╗██╔════╝██╔════╝╚██╔╝  ║~n'),
    format('  ║      ██╔████╔██║ ██║        ███████║███████╗███████╗ ██║   ║~n'),
    format('  ║      ██║╚██╔╝██║ ██║        ██╔══██║╚════██║╚════██║ ██║   ║~n'),
    format('  ║      ██║ ╚═╝ ██║ ███████╗   ██║  ██║███████║███████║ ██║   ║~n'),
    format('  ║      ╚═╝     ╚═╝ ╚══════╝   ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═╝   ║~n'),
    format('  ║                                                            ║~n'),
    format('  ║      Mobile Legends: Bang Bang - Game Assistant            ║~n'),
    format('  ║      Counter Picking | Counter Building | Meta Analysis    ║~n'),
    format('  ║                                                            ║~n'),
    format('  ╚══════════════════════════════════════════════════════════════╝~n'),
    nl.

%% main_menu/0 is det.
%  Displays the main menu and handles user input.
main_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │          MAIN MENU                   │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Counter Pick Assistant           │~n'),
    format('  │  2. Counter Build Assistant          │~n'),
    format('  │  3. Meta Analysis                    │~n'),
    format('  │  4. Hero Database                    │~n'),
    format('  │  5. Item Database                    │~n'),
    format('  │  6. Team Composition Helper          │~n'),
    format('  │  7. Draft Assistant                  │~n'),
    format('  │  8. Quick Guides                     │~n'),
    format('  │  0. Exit                             │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_main_choice(Input).

handle_main_choice("1") :- !, counter_pick_menu, main_menu.
handle_main_choice("2") :- !, counter_build_menu, main_menu.
handle_main_choice("3") :- !, meta_menu, main_menu.
handle_main_choice("4") :- !, hero_database_menu, main_menu.
handle_main_choice("5") :- !, item_database_menu, main_menu.
handle_main_choice("6") :- !, team_comp_menu, main_menu.
handle_main_choice("7") :- !, draft_menu, main_menu.
handle_main_choice("8") :- !, quick_guide_menu, main_menu.
handle_main_choice("0") :- !, format('~n  Thank you for using ML Assistant! Good luck on the Land of Dawn!~n~n').
handle_main_choice(_) :-
    format('~n  ⚠ Invalid choice. Please try again.~n'),
    main_menu.

% ============================================================================
% 1. COUNTER PICK ASSISTANT
% ============================================================================

counter_pick_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      COUNTER PICK ASSISTANT          │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Counter a single enemy hero      │~n'),
    format('  │  2. Counter entire enemy team        │~n'),
    format('  │  3. What counters my hero?           │~n'),
    format('  │  4. Why does X counter Y?            │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_counter_pick(Input).

handle_counter_pick("1") :- !,
    format('~n  Enter enemy hero name (e.g., fanny, yu_zhong): '),
    read_line_to_string(user_input, HeroStr),
    normalize_hero_input(HeroStr, Hero),
    ( hero(Hero)
    -> format('~n  ── Counter Picks for '),
       format_display_name(Hero),
       format(' ──~n'),
       get_counter_picks(Hero, Picks),
       ( Picks = []
       -> format('~n  No specific counters found in database.~n')
       ;  forall(member(counter(H, Type), Picks),
                 (   format_display_name(H),
                     format(' [~w]~n', [Type]),
                     ( counter_reason(H, Hero, Reason)
                     -> format('      └─ ~w~n', [Reason])
                     ;  true
                     )
                 ))
       )
    ;  format('~n  ⚠ Hero "~w" not found. Use underscores (e.g., yu_zhong).~n', [Hero])
    ),
    counter_pick_menu.

handle_counter_pick("2") :- !,
    format('~n  Enter enemy team (comma-separated, e.g., fanny,atlas,vale,beatrix,yu_zhong): '),
    read_line_to_string(user_input, TeamStr),
    parse_team_input(TeamStr, Team),
    ( validate_team(Team)
    -> counter_pick_analysis(Team)
    ;  format('~n  ⚠ Some heroes not found. Check spelling and use underscores.~n')
    ),
    counter_pick_menu.

handle_counter_pick("3") :- !,
    format('~n  Enter your hero name: '),
    read_line_to_string(user_input, HeroStr),
    normalize_hero_input(HeroStr, Hero),
    ( hero(Hero)
    -> format('~n  ── What counters '),
       format_display_name(Hero),
       format(' ──~n'),
       get_countered_by(Hero, Counters),
       ( Counters = []
       -> format('~n  No specific counters recorded.~n')
       ;  forall(member(counter(H, Type), Counters),
                 (   format('    [~w] ', [Type]),
                     format_display_name(H),
                     ( counter_reason(H, Hero, Reason)
                     -> format('~n      └─ ~w~n', [Reason])
                     ;  nl
                     )
                 ))
       )
    ;  format('~n  ⚠ Hero "~w" not found.~n', [Hero])
    ),
    counter_pick_menu.

handle_counter_pick("4") :- !,
    format('~n  Enter counter hero: '),
    read_line_to_string(user_input, CStr),
    normalize_hero_input(CStr, Counter),
    format('  Enter target hero: '),
    read_line_to_string(user_input, TStr),
    normalize_hero_input(TStr, Target),
    ( hero(Counter), hero(Target)
    -> why_counter(Counter, Target)
    ;  format('~n  ⚠ One or both heroes not found.~n')
    ),
    counter_pick_menu.

handle_counter_pick("0") :- !.
handle_counter_pick(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    counter_pick_menu.

% ============================================================================
% 2. COUNTER BUILD ASSISTANT
% ============================================================================

counter_build_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      COUNTER BUILD ASSISTANT         │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Build for hero vs enemy team     │~n'),
    format('  │  2. General counter items            │~n'),
    format('  │  3. Anti-heal items                  │~n'),
    format('  │  4. Defense items guide              │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_counter_build(Input).

handle_counter_build("1") :- !,
    format('~n  Enter your hero: '),
    read_line_to_string(user_input, HeroStr),
    normalize_hero_input(HeroStr, Hero),
    format('  Enter enemy team (comma-separated): '),
    read_line_to_string(user_input, TeamStr),
    parse_team_input(TeamStr, Team),
    ( hero(Hero), validate_team(Team)
    -> build_analysis(Hero, Team)
    ;  format('~n  ⚠ Invalid hero or team. Check spelling.~n')
    ),
    counter_build_menu.

handle_counter_build("2") :- !,
    format('~n  ── General Counter Items Guide ──~n~n'),
    format('  vs Sustain/Healing:~n'),
    format('    • Sea Halberd (physical heroes)~n'),
    format('    • Dominance Ice (magic heroes, tanks, supports - also anti-shield)~n~n'),
    format('  vs Physical DPS:~n'),
    format('    • Antique Cuirass (reduces attacker physical attack)~n'),
    format('    • Blade Armor (reflects basic attack damage)~n'),
    format('    • Wind of Nature (brief physical immunity)~n~n'),
    format('  vs Magic Burst:~n'),
    format('    • Athenas Shield (magic shield passive)~n'),
    format('    • Radiant Armor (stacking magic defense)~n'),
    format('    • Tough Boots (CC duration reduction)~n~n'),
    format('  vs High HP Tanks:~n'),
    format('    • Demon Hunter Sword (% current HP damage)~n'),
    format('    • Glowing Wand (% max HP burn)~n'),
    format('    • Malefic Roar (armor penetration)~n'),
    format('    • Divine Glaive (magic penetration)~n~n'),
    format('  vs Shields:~n'),
    format('    • Dominance Ice (reduces shield absorption)~n~n'),
    format('  vs Critical Hits:~n'),
    format('    • Blade Armor (reflects damage)~n'),
    format('    • Wind of Nature (brief physical immunity)~n~n'),
    counter_build_menu.

handle_counter_build("3") :- !,
    format('~n  ── Anti-Heal Items ──~n~n'),
    format('  For PHYSICAL damage heroes:~n'),
    item_info(sea_halberd),
    format('  For MAGIC heroes, TANKS and SUPPORTS:~n'),
    item_info(dominance_ice),
    counter_build_menu.

handle_counter_build("4") :- !,
    format('~n  ── Defense Items by Category ──~n~n'),
    format('  PHYSICAL DEFENSE:~n'),
    physical_defense_items(PItems),
    forall(member(I, PItems), item_info(I)),
    format('  MAGIC DEFENSE:~n'),
    magic_defense_items(MItems),
    forall(member(I, MItems), item_info(I)),
    counter_build_menu.

handle_counter_build("0") :- !.
handle_counter_build(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    counter_build_menu.

% ============================================================================
% 3. META ANALYSIS MENU
% ============================================================================

meta_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      META ANALYSIS                   │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Full meta analysis               │~n'),
    format('  │  2. Tier list                        │~n'),
    format('  │  3. Tier list by role                │~n'),
    format('  │  4. Ban recommendations              │~n'),
    format('  │  5. Meta heroes list                 │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_meta(Input).

handle_meta("1") :- !, meta_analysis, meta_menu.
handle_meta("2") :- !, tier_list, meta_menu.
handle_meta("3") :- !,
    format('~n  Enter role (tank/fighter/assassin/mage/marksman/support): '),
    read_line_to_string(user_input, RoleStr),
    normalize_hero_input(RoleStr, Role),
    ( member(Role, [tank, fighter, assassin, mage, marksman, support])
    -> tier_list_by_role(Role)
    ;  format('~n  ⚠ Invalid role.~n')
    ),
    meta_menu.
handle_meta("4") :- !, ban_recommendations, meta_menu.
handle_meta("5") :- !,
    meta_heroes(Heroes),
    format('~n  ── Current Meta Heroes ──~n~n'),
    forall(member(H, Heroes),
           (   format('    • '),
               format_display_name(H),
               hero_tier(H, Tier),
               findall(R, hero_role(H, R), Roles),
               format(' (Tier: ~w, Roles: ~w)~n', [Tier, Roles])
           )),
    nl,
    meta_menu.
handle_meta("0") :- !.
handle_meta(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    meta_menu.

% ============================================================================
% 4. HERO DATABASE MENU
% ============================================================================

hero_database_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      HERO DATABASE                   │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Look up a hero                   │~n'),
    format('  │  2. List heroes by role              │~n'),
    format('  │  3. List heroes by lane              │~n'),
    format('  │  4. List all heroes                  │~n'),
    format('  │  5. Search by tag                    │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_hero_db(Input).

handle_hero_db("1") :- !,
    format('~n  Enter hero name: '),
    read_line_to_string(user_input, HeroStr),
    normalize_hero_input(HeroStr, Hero),
    ( hero(Hero)
    -> hero_info(Hero)
    ;  format('~n  ⚠ Hero "~w" not found.~n', [Hero])
    ),
    hero_database_menu.

handle_hero_db("2") :- !,
    format('~n  Enter role (tank/fighter/assassin/mage/marksman/support): '),
    read_line_to_string(user_input, RoleStr),
    normalize_hero_input(RoleStr, Role),
    heroes_by_role(Role, Heroes),
    ( Heroes \= []
    -> format('~n  ── ~w Heroes ──~n~n', [Role]),
       forall(member(H, Heroes),
              (   format('    • '),
                  format_display_name(H),
                  hero_tier(H, Tier),
                  format(' [~w]~n', [Tier])
              ))
    ;  format('~n  No heroes found for role: ~w~n', [Role])
    ),
    nl,
    hero_database_menu.

handle_hero_db("3") :- !,
    format('~n  Enter lane (gold/exp/mid/roam/jungle): '),
    read_line_to_string(user_input, LaneStr),
    normalize_hero_input(LaneStr, Lane),
    heroes_by_lane(Lane, Heroes),
    ( Heroes \= []
    -> format('~n  ── ~w Lane Heroes ──~n~n', [Lane]),
       forall(member(H, Heroes),
              (   format('    • '),
                  format_display_name(H),
                  findall(R, hero_role(H, R), Roles),
                  format(' (~w)~n', [Roles])
              ))
    ;  format('~n  No heroes found for lane: ~w~n', [Lane])
    ),
    nl,
    hero_database_menu.

handle_hero_db("4") :- !,
    all_heroes(Heroes),
    length(Heroes, Count),
    format('~n  ── All Heroes (~w total) ──~n~n', [Count]),
    forall(member(H, Heroes),
           (   format('    • '),
               format_display_name(H),
               findall(R, hero_role(H, R), Roles),
               hero_tier(H, Tier),
               format(' (~w, Tier: ~w)~n', [Roles, Tier])
           )),
    nl,
    hero_database_menu.

handle_hero_db("5") :- !,
    format('~n  Available tags:~n'),
    format('    sustain_hero, burst_hero, cc_heavy, mobile_hero, immobile_hero,~n'),
    format('    frontline, healer, pick_off, dash_hero, anti_dash, anti_tank,~n'),
    format('    scaling_hero, early_game, late_game_carry, global_presence,~n'),
    format('    immune_frames, silence_hero, suppression, true_damage~n'),
    format('~n  Enter tag to search: '),
    read_line_to_string(user_input, TagStr),
    normalize_hero_input(TagStr, Tag),
    findall(H, hero_tag(H, Tag), Heroes),
    sort(Heroes, Sorted),
    ( Sorted \= []
    -> format('~n  ── Heroes with tag "~w" ──~n~n', [Tag]),
       forall(member(H, Sorted),
              (   format('    • '),
                  format_display_name(H),
                  findall(R, hero_role(H, R), Roles),
                  format(' (~w)~n', [Roles])
              ))
    ;  format('~n  No heroes found with tag: ~w~n', [Tag])
    ),
    nl,
    hero_database_menu.

handle_hero_db("0") :- !.
handle_hero_db(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    hero_database_menu.

% ============================================================================
% 5. ITEM DATABASE MENU
% ============================================================================

item_database_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      ITEM DATABASE                   │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Look up an item                  │~n'),
    format('  │  2. List items by type               │~n'),
    format('  │  3. List items by category           │~n'),
    format('  │  4. Items good against (tag)         │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_item_db(Input).

handle_item_db("1") :- !,
    format('~n  Enter item name (use underscores, e.g., blade_of_despair): '),
    read_line_to_string(user_input, ItemStr),
    normalize_hero_input(ItemStr, Item),
    ( item(Item)
    -> item_info(Item)
    ;  format('~n  ⚠ Item "~w" not found.~n', [Item])
    ),
    item_database_menu.

handle_item_db("2") :- !,
    format('~n  Enter type (offense/defense/movement): '),
    read_line_to_string(user_input, TypeStr),
    normalize_hero_input(TypeStr, Type),
    items_by_type(Type, Items),
    ( Items \= []
    -> format('~n  ── ~w Items ──~n', [Type]),
       forall(member(I, Items), item_info(I))
    ;  format('~n  No items found for type: ~w~n', [Type])
    ),
    item_database_menu.

handle_item_db("3") :- !,
    format('~n  Categories: physical_attack, magic_power, attack_speed,~n'),
    format('  crit, lifesteal, spell_vamp, penetration, physical_defense,~n'),
    format('  magic_defense, hp, mana, cooldown_reduction, movement_speed~n'),
    format('~n  Enter category: '),
    read_line_to_string(user_input, CatStr),
    normalize_hero_input(CatStr, Cat),
    items_by_category(Cat, Items),
    ( Items \= []
    -> format('~n  ── ~w Items ──~n', [Cat]),
       forall(member(I, Items), item_info(I))
    ;  format('~n  No items found for category: ~w~n', [Cat])
    ),
    item_database_menu.

handle_item_db("4") :- !,
    format('~n  Tags: sustain_hero, healer, lifesteal_hero, frontline,~n'),
    format('  hp_based, physical_carry, dps_hero, crit_hero,~n'),
    format('  attack_speed_hero, mobile_hero, cc_heavy, magic_damage_dealer,~n'),
    format('  burst_hero, shield_hero, squishy~n'),
    format('~n  Enter tag: '),
    read_line_to_string(user_input, TagStr),
    normalize_hero_input(TagStr, Tag),
    findall(I, item_good_against(I, Tag), Items),
    sort(Items, Sorted),
    ( Sorted \= []
    -> format('~n  ── Items good against "~w" ──~n', [Tag]),
       forall(member(I, Sorted), item_info(I))
    ;  format('~n  No items specifically tagged for: ~w~n', [Tag])
    ),
    item_database_menu.

handle_item_db("0") :- !.
handle_item_db(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    item_database_menu.

% ============================================================================
% 6. TEAM COMPOSITION HELPER
% ============================================================================

team_comp_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      TEAM COMPOSITION HELPER         │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. Check team composition           │~n'),
    format('  │  2. Suggest picks for partial team   │~n'),
    format('  │  3. Synergy analysis                 │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_team_comp(Input).

handle_team_comp("1") :- !,
    format('~n  Enter full team (5 heroes, comma-separated): '),
    read_line_to_string(user_input, TeamStr),
    parse_team_input(TeamStr, Team),
    ( validate_team(Team)
    -> team_comp_check(Team)
    ;  format('~n  ⚠ Some heroes not found. Check spelling.~n')
    ),
    team_comp_menu.

handle_team_comp("2") :- !,
    format('~n  Enter current picks (comma-separated): '),
    read_line_to_string(user_input, TeamStr),
    parse_team_input(TeamStr, Team),
    ( validate_team(Team)
    -> suggest_team_comp(Team)
    ;  format('~n  ⚠ Some heroes not found.~n')
    ),
    team_comp_menu.

handle_team_comp("3") :- !,
    format('~n  Enter team (comma-separated): '),
    read_line_to_string(user_input, TeamStr),
    parse_team_input(TeamStr, Team),
    ( validate_team(Team)
    -> synergy_analysis(Team)
    ;  format('~n  ⚠ Some heroes not found.~n')
    ),
    team_comp_menu.

handle_team_comp("0") :- !.
handle_team_comp(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    team_comp_menu.

% ============================================================================
% 7. DRAFT ASSISTANT
% ============================================================================

draft_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      DRAFT ASSISTANT                 │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  Helps you during pick/ban phase     │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter your team picks so far (comma-separated, or "none"): '),
    read_line_to_string(user_input, YourStr),
    format('  Enter enemy picks so far (comma-separated): '),
    read_line_to_string(user_input, EnemyStr),
    ( YourStr = "none"
    -> YourTeam = []
    ;  parse_team_input(YourStr, YourTeam)
    ),
    parse_team_input(EnemyStr, EnemyTeam),
    ( validate_team_or_empty(YourTeam), validate_team(EnemyTeam)
    -> draft_helper(YourTeam, EnemyTeam)
    ;  format('~n  ⚠ Some heroes not found. Check spelling.~n')
    ).

% ============================================================================
% 8. QUICK GUIDES
% ============================================================================

quick_guide_menu :-
    format('~n  ┌──────────────────────────────────────┐~n'),
    format('  │      QUICK GUIDES                    │~n'),
    format('  ├──────────────────────────────────────┤~n'),
    format('  │  1. When to pick anti-heal           │~n'),
    format('  │  2. When to pick Diggie              │~n'),
    format('  │  3. How to counter Fanny             │~n'),
    format('  │  4. How to counter tank-heavy teams  │~n'),
    format('  │  5. How to counter burst assassins   │~n'),
    format('  │  6. How to counter sustain comps     │~n'),
    format('  │  0. Back to main menu                │~n'),
    format('  └──────────────────────────────────────┘~n'),
    format('~n  Enter choice: '),
    read_line_to_string(user_input, Input),
    handle_quick_guide(Input).

handle_quick_guide("1") :- !,
    format('~n  ══ WHEN TO BUILD ANTI-HEAL ══~n~n'),
    format('  Build anti-heal when enemy has ANY of these:~n~n'),
    findall(H, hero_tag(H, sustain_hero), Sustain),
    sort(Sustain, SSustain),
    format('  Sustain heroes to watch for:~n'),
    forall(member(H, SSustain),
           (format('    • '), format_display_name(H), nl)),
    nl,
    findall(H, hero_tag(H, healer), Healers),
    sort(Healers, SHealers),
    format('  Healers to watch for:~n'),
    forall(member(H, SHealers),
           (format('    • '), format_display_name(H), nl)),
    nl,
    format('  Anti-heal items:~n'),
    format('    Physical → Sea Halberd~n'),
    format('    Magic    → Dominance Ice~n'),
    format('    Tank     → Dominance Ice~n~n'),
    quick_guide_menu.

handle_quick_guide("2") :- !,
    format('~n  ══ WHEN TO PICK DIGGIE ══~n~n'),
    format('  Pick Diggie when the enemy team has 2+ CC-heavy heroes.~n~n'),
    format('  Diggie ult removes ALL CC from nearby allies!~n~n'),
    format('  Best against:~n'),
    findall(H, hero_tag(H, cc_heavy), CCHeroes),
    sort(CCHeroes, SCCHeroes),
    forall(member(H, SCCHeroes),
           (format('    • '), format_display_name(H), nl)),
    nl,
    format('  Diggie is especially good vs:~n'),
    format('    • Atlas (cleanses Fatal Links)~n'),
    format('    • Tigreal (prevents full combo lock)~n'),
    format('    • Franco (removes hook CC)~n~n'),
    quick_guide_menu.

handle_quick_guide("3") :- !,
    format('~n  ══ HOW TO COUNTER FANNY ══~n~n'),
    format('  Fanny is the most mobile hero. Here is how to stop her:~n~n'),
    format('  1. HERO COUNTERS:~n'),
    get_counter_picks(fanny, Picks),
    forall(member(counter(H, Type), Picks),
           (   format('     [~w] ', [Type]),
               format_display_name(H),
               ( counter_reason(H, fanny, Reason)
               -> format('~n       └─ ~w~n', [Reason])
               ;  nl
               )
           )),
    nl,
    format('  2. STRATEGY:~n'),
    format('     • Invade her jungle early to deny blue buff~n'),
    format('     • Without energy (blue buff), Fanny is useless~n'),
    format('     • Group as 5 to avoid being picked off~n'),
    format('     • Save CC skills for when she cables in~n~n'),
    format('  3. ITEMS:~n'),
    format('     • Tough Boots (reduce her CC)~n'),
    format('     • Antique Cuirass (reduce her physical damage)~n'),
    format('     • Blade Armor (reflect her basic attack damage)~n~n'),
    quick_guide_menu.

handle_quick_guide("4") :- !,
    format('~n  ══ HOW TO COUNTER TANK-HEAVY TEAMS ══~n~n'),
    format('  When enemy has 2+ tanks or tanky fighters:~n~n'),
    format('  1. HERO PICKS:~n'),
    format('     • Karrie - True damage passive shreds tanks~n'),
    format('     • Lunox  - Penetration bypass in dark mode~n'),
    format('     • Claude - DHS + ult destroys grouped tanks~n~n'),
    format('  2. ITEMS:~n'),
    format('     Physical: Demon Hunter Sword + Malefic Roar~n'),
    format('     Magic:    Glowing Wand + Divine Glaive~n~n'),
    format('  3. STRATEGY:~n'),
    format('     • Focus on objectives, not kills~n'),
    format('     • Tank-heavy teams lack damage - outfarm them~n'),
    format('     • Build penetration items early~n~n'),
    quick_guide_menu.

handle_quick_guide("5") :- !,
    format('~n  ══ HOW TO COUNTER BURST ASSASSINS ══~n~n'),
    format('  Against Lancelot, Gusion, Saber, Ling, etc:~n~n'),
    format('  1. ITEMS:~n'),
    format('     • Immortality (revive after being burst)~n'),
    format('     • Antique Cuirass (reduces their attack)~n'),
    format('     • Wind of Nature (physical immunity - marksmen)~n~n'),
    format('  2. HEROES:~n'),
    format('     • Khufra (anti-dash, disrupts assassin engage)~n'),
    format('     • Lolita (blocks projectiles, stun ult)~n'),
    format('     • Melissa (anti-melee zone)~n'),
    format('     • Franco (hook and suppress before they engage)~n~n'),
    format('  3. STRATEGY:~n'),
    format('     • Stay grouped - assassins target isolated heroes~n'),
    format('     • Ward jungle entrances~n'),
    format('     • Build one defense item even on damage heroes~n~n'),
    quick_guide_menu.

handle_quick_guide("6") :- !,
    format('~n  ══ HOW TO COUNTER SUSTAIN COMPOSITIONS ══~n~n'),
    format('  Against Estes, Yu Zhong, Esmeralda, Thamuz, etc:~n~n'),
    format('  1. ANTI-HEAL IS MANDATORY:~n'),
    format('     • Sea Halberd (physical heroes)~n'),
    format('     • Dominance Ice (magic heroes and tanks - aura anti-heal + anti-shield)~n~n'),
    format('  2. HERO PICKS:~n'),
    format('     • X.Borg (built-in anti-heal + true damage)~n'),
    format('     • Baxia (passive reduces all regen)~n'),
    format('     • Esmeralda (absorbs shields)~n~n'),
    format('  3. STRATEGY:~n'),
    format('     • Build anti-heal FIRST, before damage items~n'),
    format('     • Focus burst on the healer (Estes/Rafaela)~n'),
    format('     • Avoid prolonged fights where sustain wins~n'),
    format('     • Pick assassins to delete healers quickly~n~n'),
    quick_guide_menu.

handle_quick_guide("0") :- !.
handle_quick_guide(_) :-
    format('~n  ⚠ Invalid choice.~n'),
    quick_guide_menu.

% ============================================================================
% INPUT PARSING UTILITIES
% ============================================================================

%% normalize_hero_input(+String, -Atom) is det.
%  Converts user input string to a normalized atom.
normalize_hero_input(Str, Atom) :-
    string_lower(Str, Lower),
    split_string(Lower, " ", " \t\n\r", Parts),
    atomics_to_string(Parts, "_", Joined),
    atom_string(Atom, Joined).

atomics_to_string([], _, "").
atomics_to_string([H], _, H).
atomics_to_string([H|T], Sep, Result) :-
    T \= [],
    atomics_to_string(T, Sep, Rest),
    string_concat(H, Sep, HSep),
    string_concat(HSep, Rest, Result).

%% parse_team_input(+String, -Team) is det.
%  Parses comma-separated hero names into a list.
parse_team_input(Str, Team) :-
    split_string(Str, ",", " \t\n\r", Parts),
    maplist(normalize_part, Parts, Team).

normalize_part(Part, Atom) :-
    split_string(Part, " ", " \t\n\r", Words),
    exclude(empty_string, Words, NonEmpty),
    atomics_to_string(NonEmpty, "_", Joined),
    atom_string(Atom, Joined).

empty_string("").

%% validate_team(+Team) is semidet.
validate_team([]).
validate_team([H|T]) :-
    hero(H),
    validate_team(T).

%% validate_team_or_empty(+Team) is semidet.
validate_team_or_empty([]).
validate_team_or_empty(Team) :- validate_team(Team).

%% format_display_name(+Hero) is det.
%  Prints a formatted hero name.
format_display_name(Hero) :-
    atom_string(Hero, Str),
    split_string(Str, "_", "", Parts),
    maplist(cap_display_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', FName),
    format('~w', [FName]).

cap_display_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).

% ============================================================================
% DIRECT QUERY INTERFACE (for use without menus)
% ============================================================================

%% counter(+EnemyHero) is det.
%  Quick counter lookup.
counter(Enemy) :-
    format('~n  Quick counter lookup for: '),
    format_display_name(Enemy),
    nl,
    get_counter_picks(Enemy, Picks),
    forall(member(counter(H, Type), Picks),
           (   format('    [~w] ', [Type]),
               format_display_name(H),
               nl
           )),
    nl.

%% build(+YourHero, +EnemyTeam) is det.
%  Quick build recommendation.
build(Hero, EnemyTeam) :-
    build_analysis(Hero, EnemyTeam).

%% draft(+YourTeam, +EnemyTeam) is det.
%  Quick draft helper.
draft(YourTeam, EnemyTeam) :-
    draft_helper(YourTeam, EnemyTeam).

%% check(+Team) is det.
%  Quick team comp check.
check(Team) :-
    team_comp_check(Team).

%% bans/0 is det.
%  Quick ban recommendations.
bans :- ban_recommendations.

%% tiers/0 is det.
%  Quick tier list.
tiers :- tier_list.

%% info(+HeroOrItem) is det.
%  Quick info lookup.
info(X) :-
    ( hero(X) -> hero_info(X)
    ; item(X) -> item_info(X)
    ; format('~n  ⚠ "~w" not found in hero or item database.~n', [X])
    ).
