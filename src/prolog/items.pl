% ============================================================================
% Mobile Legends: Bang Bang - Item Knowledge Base
% items.pl - Comprehensive item database with stats, passives, and categories
% ============================================================================
:- module(items, [
    item/1,
    item_type/2,
    item_category/2,
    item_stat/3,
    item_passive/2,
    item_good_against/2,
    item_price/2,
    items_by_type/2,
    items_by_category/2,
    anti_heal_items/1,
    physical_defense_items/1,
    magic_defense_items/1,
    penetration_items/1,
    item_info/1
]).

:- discontiguous item/1, item_type/2, item_category/2, item_stat/3,
                 item_passive/2, item_good_against/2, item_price/2.

% ============================================================================
% ITEM DEFINITIONS
% item(Name).
% item_type(Name, Type) - offense, defense, movement, jungle, roam
% item_category(Name, Cat) - physical_attack, magic_power, attack_speed,
%     crit, lifesteal, spell_vamp, penetration, physical_defense,
%     magic_defense, hp, mana, cooldown_reduction, movement_speed
% item_stat(Name, Stat, Value) - specific stat values
% item_passive(Name, Passive) - passive effect description
% item_good_against(Name, Tag) - hero tags this item counters
% ============================================================================

% ----------------------------------------------------------------------------
% PHYSICAL ATTACK ITEMS
% ----------------------------------------------------------------------------
item(blade_of_despair).
item_type(blade_of_despair, offense).
item_category(blade_of_despair, physical_attack).
item_stat(blade_of_despair, physical_attack, 160).
item_stat(blade_of_despair, movement_speed, 5).
item_passive(blade_of_despair, 'Despair: +25% damage against enemies below 50% HP').
item_price(blade_of_despair, 3010).
item_good_against(blade_of_despair, squishy).

item(malefic_roar).
item_type(malefic_roar, offense).
item_category(malefic_roar, penetration).
item_category(malefic_roar, physical_attack).
item_stat(malefic_roar, physical_attack, 60).
item_stat(malefic_roar, physical_penetration_pct, 20).
item_passive(malefic_roar, 'Armor Buster: Extra penetration based on target armor').
item_price(malefic_roar, 2060).
item_good_against(malefic_roar, frontline).
item_good_against(malefic_roar, hp_based).

item(hunter_strike).
item_type(hunter_strike, offense).
item_category(hunter_strike, physical_attack).
item_category(hunter_strike, cooldown_reduction).
item_stat(hunter_strike, physical_attack, 80).
item_stat(hunter_strike, cooldown_reduction, 10).
item_passive(hunter_strike, 'Retribution: Movement speed boost after hitting same target 5 times').
item_price(hunter_strike, 2010).

item(endless_battle).
item_type(endless_battle, offense).
item_category(endless_battle, physical_attack).
item_category(endless_battle, lifesteal).
item_category(endless_battle, cooldown_reduction).
item_stat(endless_battle, physical_attack, 65).
item_stat(endless_battle, hp, 250).
item_stat(endless_battle, mana, 400).
item_stat(endless_battle, lifesteal, 10).
item_stat(endless_battle, cooldown_reduction, 10).
item_stat(endless_battle, movement_speed, 5).
item_passive(endless_battle, 'Divine Justice: After skill, next basic attack deals 60% physical attack as true damage').
item_price(endless_battle, 2470).
item_good_against(endless_battle, frontline).


item(blade_of_heptaseas).
item_type(blade_of_heptaseas, offense).
item_category(blade_of_heptaseas, physical_attack).
item_category(blade_of_heptaseas, penetration).
item_stat(blade_of_heptaseas, physical_attack, 70).
item_stat(blade_of_heptaseas, physical_penetration, 15).
item_passive(blade_of_heptaseas, 'Ambush: If no damage taken for 5s, next basic attack deals extra damage and slows').
item_price(blade_of_heptaseas, 1950).
item_good_against(blade_of_heptaseas, squishy).

item(war_axe).
item_type(war_axe, offense).
item_category(war_axe, physical_attack).
item_category(war_axe, cooldown_reduction).
item_category(war_axe, hp).
item_stat(war_axe, physical_attack, 35).
item_stat(war_axe, hp, 550).
item_stat(war_axe, cooldown_reduction, 10).
item_passive(war_axe, 'Fighting Spirit: Stacking physical attack and penetration in combat (max 8 stacks)').
item_price(war_axe, 2100).

item(sea_halberd).
item_type(sea_halberd, offense).
item_category(sea_halberd, physical_attack).
item_category(sea_halberd, attack_speed).
item_stat(sea_halberd, physical_attack, 80).
item_stat(sea_halberd, attack_speed, 20).
item_passive(sea_halberd, 'Punish: Attacks reduce target HP regen by 50%').
item_price(sea_halberd, 2050).
item_good_against(sea_halberd, sustain_hero).
item_good_against(sea_halberd, healer).
item_good_against(sea_halberd, lifesteal_hero).

% ----------------------------------------------------------------------------
% MAGIC POWER ITEMS
% ----------------------------------------------------------------------------
item(holy_crystal).
item_type(holy_crystal, offense).
item_category(holy_crystal, magic_power).
item_stat(holy_crystal, magic_power, 100).
item_passive(holy_crystal, 'Mystery: Increases magic power by 21-35% based on level').
item_price(holy_crystal, 2180).

item(divine_glaive).
item_type(divine_glaive, offense).
item_category(divine_glaive, penetration).
item_category(divine_glaive, magic_power).
item_stat(divine_glaive, magic_power, 65).
item_stat(divine_glaive, magic_penetration_pct, 30).
item_passive(divine_glaive, 'Spellbreaker: Extra magic penetration when enemy magic defense is high').
item_price(divine_glaive, 1970).
item_good_against(divine_glaive, frontline).
item_good_against(divine_glaive, hp_based).

item(genius_wand).
item_type(genius_wand, offense).
item_category(genius_wand, magic_power).
item_category(genius_wand, penetration).
item_category(genius_wand, movement_speed).
item_stat(genius_wand, magic_power, 75).
item_stat(genius_wand, movement_speed, 5).
item_passive(genius_wand, 'Magic: Skills reduce target magic defense by 2-9 (stacks 3 times)').
item_price(genius_wand, 2000).
item_good_against(genius_wand, frontline).

item(lightning_truncheon).
item_type(lightning_truncheon, offense).
item_category(lightning_truncheon, magic_power).
item_category(lightning_truncheon, mana).
item_category(lightning_truncheon, cooldown_reduction).
item_stat(lightning_truncheon, magic_power, 75).
item_stat(lightning_truncheon, mana, 400).
item_stat(lightning_truncheon, cooldown_reduction, 10).
item_passive(lightning_truncheon, 'Resonate: Every 6s, skill deals bouncing damage').
item_price(lightning_truncheon, 2250).

item(glowing_wand).
item_type(glowing_wand, offense).
item_category(glowing_wand, magic_power).
item_category(glowing_wand, hp).
item_stat(glowing_wand, magic_power, 75).
item_stat(glowing_wand, hp, 400).
item_passive(glowing_wand, 'Scorch: Skills burn target for 1% max HP over 3s (3 stacks max)').
item_price(glowing_wand, 2200).
item_good_against(glowing_wand, hp_based).
item_good_against(glowing_wand, frontline).

item(ice_queen_wand).
item_type(ice_queen_wand, offense).
item_category(ice_queen_wand, magic_power).
item_category(ice_queen_wand, spell_vamp).
item_category(ice_queen_wand, movement_speed).
item_stat(ice_queen_wand, magic_power, 75).
item_stat(ice_queen_wand, spell_vamp, 10).
item_stat(ice_queen_wand, movement_speed, 10).
item_passive(ice_queen_wand, 'Ice Bound: Skills slow enemy by 15%, stacking').
item_price(ice_queen_wand, 2240).
item_good_against(ice_queen_wand, mobile_hero).


item(blood_wings).
item_type(blood_wings, offense).
item_category(blood_wings, magic_power).
item_category(blood_wings, hp).
item_stat(blood_wings, magic_power, 150).
item_stat(blood_wings, hp, 500).
item_passive(blood_wings, 'Covenant: Adds shield based on magic power').
item_price(blood_wings, 3000).

% ----------------------------------------------------------------------------
% ATTACK SPEED / CRIT ITEMS
% ----------------------------------------------------------------------------
item(berserkers_fury).
item_type(berserkers_fury, offense).
item_category(berserkers_fury, physical_attack).
item_category(berserkers_fury, crit).
item_stat(berserkers_fury, physical_attack, 65).
item_stat(berserkers_fury, crit_chance, 25).
item_passive(berserkers_fury, 'Doom: +40% crit damage. Crits increase physical attack by 5% for 2s').
item_price(berserkers_fury, 2350).


item(windtalker).
item_type(windtalker, offense).
item_category(windtalker, attack_speed).
item_category(windtalker, movement_speed).
item_category(windtalker, crit).
item_stat(windtalker, physical_attack, 30).
item_stat(windtalker, attack_speed, 20).
item_stat(windtalker, movement_speed, 20).
item_stat(windtalker, crit_chance, 10).
item_passive(windtalker, 'Typhoon: Every few attacks, deal magic damage to 3 enemies').
item_price(windtalker, 1870).

item(demon_hunter_sword).
item_type(demon_hunter_sword, offense).
item_category(demon_hunter_sword, physical_attack).
item_category(demon_hunter_sword, attack_speed).
item_stat(demon_hunter_sword, physical_attack, 35).
item_stat(demon_hunter_sword, attack_speed, 25).
item_passive(demon_hunter_sword, 'Devour: Basic attacks deal 9% of target current HP. 3% lifesteal vs creeps').
item_price(demon_hunter_sword, 2180).
item_good_against(demon_hunter_sword, hp_based).
item_good_against(demon_hunter_sword, frontline).

item(golden_staff).
item_type(golden_staff, offense).
item_category(golden_staff, attack_speed).
item_stat(golden_staff, physical_attack, 65).
item_stat(golden_staff, attack_speed, 30).
item_passive(golden_staff, 'Swift: Every 2 basic attacks, 3rd triggers passive effects twice. No crit.').
item_price(golden_staff, 2100).
item_good_against(golden_staff, hp_based).

item(corrosion_scythe).
item_type(corrosion_scythe, offense).
item_category(corrosion_scythe, physical_attack).
item_category(corrosion_scythe, attack_speed).
item_stat(corrosion_scythe, physical_attack, 35).
item_stat(corrosion_scythe, attack_speed, 25).
item_stat(corrosion_scythe, movement_speed, 5).
item_passive(corrosion_scythe, 'Corrosion: Basic attacks slow by 8% and reduce attack speed by 8%').
item_price(corrosion_scythe, 2050).
item_good_against(corrosion_scythe, attack_speed_hero).
item_good_against(corrosion_scythe, mobile_hero).

% ----------------------------------------------------------------------------
% PHYSICAL DEFENSE ITEMS
% ----------------------------------------------------------------------------
item(antique_cuirass).
item_type(antique_cuirass, defense).
item_category(antique_cuirass, physical_defense).
item_category(antique_cuirass, hp).
item_stat(antique_cuirass, hp, 770).
item_stat(antique_cuirass, physical_defense, 54).
item_passive(antique_cuirass, 'Deter: Reduces attacker physical attack by 10% (stacks 3 times)').
item_price(antique_cuirass, 2170).
item_good_against(antique_cuirass, physical_carry).
item_good_against(antique_cuirass, dps_hero).

item(blade_armor).
item_type(blade_armor, defense).
item_category(blade_armor, physical_defense).
item_stat(blade_armor, physical_defense, 90).
item_passive(blade_armor, 'Counterstrike: Reflects 25% of basic attack damage as physical damage').
item_price(blade_armor, 1660).
item_good_against(blade_armor, physical_carry).
item_good_against(blade_armor, dps_hero).
item_good_against(blade_armor, crit_hero).
item_good_against(blade_armor, attack_speed_hero).

item(dominance_ice).
item_type(dominance_ice, defense).
item_category(dominance_ice, physical_defense).
item_category(dominance_ice, mana).
item_category(dominance_ice, cooldown_reduction).
item_stat(dominance_ice, physical_defense, 70).
item_stat(dominance_ice, mana, 500).
item_stat(dominance_ice, cooldown_reduction, 5).
item_passive(dominance_ice, 'Arctic Slow: Reduces nearby enemy shield, HP regen, and attack speed by 50%').
item_price(dominance_ice, 2010).
item_good_against(dominance_ice, sustain_hero).
item_good_against(dominance_ice, healer).
item_good_against(dominance_ice, attack_speed_hero).
item_good_against(dominance_ice, shield_hero).
item_good_against(dominance_ice, lifesteal_hero).


% ----------------------------------------------------------------------------
% MAGIC DEFENSE ITEMS
% ----------------------------------------------------------------------------
item(athenas_shield).
item_type(athenas_shield, defense).
item_category(athenas_shield, magic_defense).
item_category(athenas_shield, hp).
item_stat(athenas_shield, hp, 900).
item_stat(athenas_shield, magic_defense, 62).
item_passive(athenas_shield, 'Shield: Gains a magic damage-absorbing shield every 30s').
item_price(athenas_shield, 2150).
item_good_against(athenas_shield, magic_damage_dealer).
item_good_against(athenas_shield, burst_hero).

item(radiant_armor).
item_type(radiant_armor, defense).
item_category(radiant_armor, magic_defense).
item_category(radiant_armor, hp).
item_stat(radiant_armor, hp, 950).
item_stat(radiant_armor, magic_defense, 52).
item_passive(radiant_armor, 'Holy Blessing: Taking magic damage increases magic defense (stacks)').
item_price(radiant_armor, 1880).
item_good_against(radiant_armor, magic_damage_dealer).
item_good_against(radiant_armor, poke_hero).

item(cursed_helmet).
item_type(cursed_helmet, defense).
item_category(cursed_helmet, magic_defense).
item_category(cursed_helmet, hp).
item_stat(cursed_helmet, hp, 1200).
item_stat(cursed_helmet, magic_defense, 25).
item_passive(cursed_helmet, 'Burning Soul: Deals 1.5% of max HP as magic damage to nearby enemies per second').
item_price(cursed_helmet, 1760).

item(oracle).
item_type(oracle, defense).
item_category(oracle, magic_defense).
item_category(oracle, hp).
item_category(oracle, cooldown_reduction).
item_stat(oracle, hp, 850).
item_stat(oracle, magic_defense, 36).
item_stat(oracle, cooldown_reduction, 10).
item_passive(oracle, 'Bless: Increases shield absorption and HP regen by 30%').
item_price(oracle, 2060).

% ----------------------------------------------------------------------------
% HP / HYBRID DEFENSE ITEMS
% ----------------------------------------------------------------------------
item(immortality).
item_type(immortality, defense).
item_category(immortality, physical_defense).
item_category(immortality, hp).
item_stat(immortality, hp, 800).
item_stat(immortality, physical_defense, 40).
item_passive(immortality, 'Immortal: Resurrect 2.5s after death with 16% HP and shield. 210s CD').
item_price(immortality, 2120).

item(queens_wings).
item_type(queens_wings, defense).
item_category(queens_wings, physical_attack).
item_category(queens_wings, hp).
item_category(queens_wings, cooldown_reduction).
item_stat(queens_wings, physical_attack, 15).
item_stat(queens_wings, hp, 1000).
item_stat(queens_wings, cooldown_reduction, 10).
item_passive(queens_wings, 'Demonize: When HP below 40%, reduce damage taken by 40% for 5s').
item_price(queens_wings, 2250).

item(bruteforce_breastplate).
item_type(bruteforce_breastplate, defense).
item_category(bruteforce_breastplate, physical_defense).
item_category(bruteforce_breastplate, hp).
item_stat(bruteforce_breastplate, hp, 770).
item_stat(bruteforce_breastplate, physical_defense, 54).
item_passive(bruteforce_breastplate, 'Brute Force: Using skills/basic attacks increases movement speed, physical and magic defense (stacks 5 times)').
item_price(bruteforce_breastplate, 1870).

% ----------------------------------------------------------------------------
% MOVEMENT / BOOTS
% ----------------------------------------------------------------------------
item(warrior_boots).
item_type(warrior_boots, movement).
item_category(warrior_boots, physical_defense).
item_category(warrior_boots, movement_speed).
item_stat(warrior_boots, physical_defense, 22).
item_stat(warrior_boots, movement_speed, 40).
item_passive(warrior_boots, 'Valor: Physical defense increases by 5 on taking physical damage (stacks 5 times)').
item_price(warrior_boots, 720).
item_good_against(warrior_boots, physical_carry).

item(tough_boots).
item_type(tough_boots, movement).
item_category(tough_boots, magic_defense).
item_category(tough_boots, movement_speed).
item_stat(tough_boots, magic_defense, 22).
item_stat(tough_boots, movement_speed, 40).
item_passive(tough_boots, 'Fortitude: Reduces CC duration by 30%').
item_price(tough_boots, 710).
item_good_against(tough_boots, cc_heavy).
item_good_against(tough_boots, magic_damage_dealer).

item(arcane_boots).
item_type(arcane_boots, movement).
item_category(arcane_boots, penetration).
item_category(arcane_boots, movement_speed).
item_stat(arcane_boots, magic_penetration, 10).
item_stat(arcane_boots, movement_speed, 40).
item_price(arcane_boots, 690).

item(swift_boots).
item_type(swift_boots, movement).
item_category(swift_boots, attack_speed).
item_category(swift_boots, movement_speed).
item_stat(swift_boots, attack_speed, 15).
item_stat(swift_boots, movement_speed, 40).
item_price(swift_boots, 710).

item(magic_shoes).
item_type(magic_shoes, movement).
item_category(magic_shoes, cooldown_reduction).
item_category(magic_shoes, movement_speed).
item_stat(magic_shoes, cooldown_reduction, 10).
item_stat(magic_shoes, movement_speed, 40).
item_price(magic_shoes, 710).

% ----------------------------------------------------------------------------
% ROAM ITEMS
% ----------------------------------------------------------------------------



% ----------------------------------------------------------------------------
% ADDED ITEMS (current game). Stats are intentionally left out where not verified;
% only categories, type and short passive summaries are recorded.
% ----------------------------------------------------------------------------
item(chastise_pauldron).
item_type(chastise_pauldron, defense).
item_category(chastise_pauldron, magic_defense).
item_category(chastise_pauldron, hp).
item_good_against(chastise_pauldron, magic_damage_dealer).

item(clock_of_destiny).
item_type(clock_of_destiny, offense).
item_category(clock_of_destiny, magic_power).
item_category(clock_of_destiny, hp).
item_category(clock_of_destiny, mana).
item_passive(clock_of_destiny, 'Gradually gains extra magic power and max HP over time, up to a cap').

item(concentrated_energy).
item_type(concentrated_energy, offense).
item_category(concentrated_energy, magic_power).

item(demon_boots).
item_type(demon_boots, movement).
item_category(demon_boots, movement_speed).
item_category(demon_boots, mana).
item_passive(demon_boots, 'Boots aimed at mages: helps with mana sustain').

item(enchanted_talisman).
item_type(enchanted_talisman, offense).
item_category(enchanted_talisman, magic_power).
item_category(enchanted_talisman, mana).
item_category(enchanted_talisman, cooldown_reduction).
item_passive(enchanted_talisman, 'Improves mana regeneration and cooldown reduction').

item(feather_of_heaven).
item_type(feather_of_heaven, offense).
item_category(feather_of_heaven, magic_power).

item(flask_of_the_oasis).
item_type(flask_of_the_oasis, defense).
item_category(flask_of_the_oasis, hp).
item_category(flask_of_the_oasis, cooldown_reduction).
item_passive(flask_of_the_oasis, 'Active: restores HP to you and nearby allies').

item(fleeting_time).
item_type(fleeting_time, offense).
item_category(fleeting_time, cooldown_reduction).

item(great_dragon_spear).
item_type(great_dragon_spear, offense).
item_category(great_dragon_spear, physical_attack).
item_category(great_dragon_spear, attack_speed).

item(guardian_helmet).
item_type(guardian_helmet, defense).
item_category(guardian_helmet, hp).
item_passive(guardian_helmet, 'Boosts HP regeneration').
item_good_against(guardian_helmet, poke_hero).

item(haas_claws).
item_type(haas_claws, offense).
item_category(haas_claws, physical_attack).
item_category(haas_claws, lifesteal).
item_passive(haas_claws, 'Adds lifesteal to your attacks').

item(malefic_gun).
item_type(malefic_gun, offense).
item_category(malefic_gun, physical_attack).
item_category(malefic_gun, penetration).

item(rapid_boots).
item_type(rapid_boots, movement).
item_category(rapid_boots, movement_speed).

item(rose_gold_meteor).
item_type(rose_gold_meteor, defense).
item_category(rose_gold_meteor, magic_defense).
item_category(rose_gold_meteor, hp).
item_passive(rose_gold_meteor, 'Grants a shield that absorbs magic damage when your HP gets low').
item_good_against(rose_gold_meteor, magic_damage_dealer).
item_good_against(rose_gold_meteor, burst_hero).

item(sky_piercer).
item_type(sky_piercer, offense).
item_category(sky_piercer, physical_attack).
item_category(sky_piercer, penetration).
item_passive(sky_piercer, 'Extra physical penetration, strong against tanky targets').
item_good_against(sky_piercer, frontline).
item_good_against(sky_piercer, hp_based).

item(starlium_scythe).
item_type(starlium_scythe, offense).
item_category(starlium_scythe, physical_attack).

item(thunderbelt).
item_type(thunderbelt, offense).
item_category(thunderbelt, magic_power).

item(winter_crown).
item_type(winter_crown, defense).
item_category(winter_crown, magic_defense).
item_category(winter_crown, hp).
item_good_against(winter_crown, magic_damage_dealer).

item(wishing_lantern).
item_type(wishing_lantern, offense).
item_category(wishing_lantern, magic_power).

item(wind_of_nature).
item_type(wind_of_nature, offense).
item_category(wind_of_nature, physical_attack).
item_passive(wind_of_nature, 'Active: briefly become immune to physical damage').
item_good_against(wind_of_nature, burst_hero).
item_good_against(wind_of_nature, physical_carry).

% ============================================================================
% UTILITY PREDICATES
% ============================================================================

%% items_by_type(+Type, -Items) is det.
items_by_type(Type, Items) :-
    findall(I, item_type(I, Type), Is),
    sort(Is, Items).

%% items_by_category(+Category, -Items) is det.
items_by_category(Category, Items) :-
    findall(I, item_category(I, Category), Is),
    sort(Is, Items).

%% anti_heal_items(-Items) is det.
%  Returns items that have anti-heal effects.
anti_heal_items(Items) :-
    findall(I, (item(I), item_good_against(I, sustain_hero)), Is),
    sort(Is, Items).

%% physical_defense_items(-Items) is det.
physical_defense_items(Items) :-
    items_by_category(physical_defense, Items).

%% magic_defense_items(-Items) is det.
magic_defense_items(Items) :-
    items_by_category(magic_defense, Items).

%% penetration_items(-Items) is det.
penetration_items(Items) :-
    items_by_category(penetration, Items).

%% item_info(+Item) is det.
%  Prints detailed information about an item.
item_info(Item) :-
    item(Item),
    item_type(Item, Type),
    findall(C, item_category(Item, C), Cats),
    findall(S-V, item_stat(Item, S, V), Stats),
    ( item_passive(Item, Passive) -> true ; Passive = 'None' ),
    ( item_price(Item, Price) -> true ; Price = unknown ),
    findall(G, item_good_against(Item, G), Goods),
    format_item_name(Item, FName),
    format('~n┌──────────────────────────────────────────┐~n'),
    format('│  ~w~n', [FName]),
    format('└──────────────────────────────────────────┘~n'),
    format('  Type       : ~w~n', [Type]),
    format('  Categories : ~w~n', [Cats]),
    format('  Price      : ~w gold~n', [Price]),
    format('  Stats:~n'),
    forall(member(S-V, Stats), format('    - ~w: +~w~n', [S, V])),
    format('  Passive    : ~w~n', [Passive]),
    ( Goods \= []
    -> format('  Good vs    : ~w~n', [Goods])
    ;  true
    ),
    nl.

format_item_name(Item, Formatted) :-
    atom_string(Item, Str),
    split_string(Str, "_", "", Parts),
    maplist(capitalize_item_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', Formatted).

capitalize_item_word(Word, Word) :- memberchk(Word, ["of", "the", "and"]), !.
capitalize_item_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).
