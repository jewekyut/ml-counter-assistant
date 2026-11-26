% ============================================================================
% Mobile Legends: Bang Bang - Hero Knowledge Base
% heroes.pl - Comprehensive hero database with roles, types, and attributes
% ============================================================================
:- module(heroes, [
    hero/1,
    hero_role/2,
    hero_damage_type/2,
    hero_specialty/2,
    hero_tier/2,
    hero_difficulty/2,
    hero_lane/2,
    hero_strength/2,
    hero_weakness/2,
    hero_tag/2,
    all_heroes/1,
    heroes_by_role/2,
    heroes_by_tier/2,
    heroes_by_lane/2,
    hero_info/1
]).

:- use_module(season).

:- discontiguous hero/1, hero_role/2, hero_damage_type/2, hero_specialty/2,
                 hero_tier/2, hero_difficulty/2, hero_lane/2, hero_strength/2,
                 hero_weakness/2, hero_tag/2.

% ============================================================================
% HERO DEFINITIONS
% hero(Name).
% hero_role(Name, Role) - tank, fighter, assassin, mage, marksman, support
% hero_damage_type(Name, Type) - physical, magic, hybrid, true_damage
% hero_specialty(Name, Spec) - burst, sustain, crowd_control, poke, push,
%                              chase, initiator, reap, support_spec, mobility
% hero_tier(Name, Tier) - s_plus, s, a, b, c (current meta ranking)
% hero_difficulty(Name, Diff) - easy, moderate, hard, very_hard
% hero_lane(Name, Lane) - gold, exp, mid, roam, jungle
% hero_strength(Name, Str) - descriptive strength
% hero_weakness(Name, Wk) - descriptive weakness
% hero_tag(Name, Tag) - categorical tags for counter logic
% ============================================================================

% ----------------------------------------------------------------------------
% TANKS
% ----------------------------------------------------------------------------
hero(tigreal).
hero_role(tigreal, tank).
hero_damage_type(tigreal, physical).
hero_specialty(tigreal, crowd_control).
hero_specialty(tigreal, initiator).
hero_difficulty(tigreal, easy).
hero_lane(tigreal, roam).
hero_strength(tigreal, strong_cc).
hero_strength(tigreal, team_fight_presence).
hero_strength(tigreal, easy_to_play).
hero_weakness(tigreal, low_damage).
hero_weakness(tigreal, slow_mobility).
hero_weakness(tigreal, skill_dependent).
hero_tag(tigreal, cc_heavy).
hero_tag(tigreal, initiator_tag).
hero_tag(tigreal, frontline).

hero(khufra).
hero_role(khufra, tank).
hero_damage_type(khufra, magic).
hero_specialty(khufra, crowd_control).
hero_specialty(khufra, initiator).
hero_difficulty(khufra, moderate).
hero_lane(khufra, roam).
hero_strength(khufra, anti_dash).
hero_strength(khufra, strong_engage).
hero_strength(khufra, flexible_cc).
hero_weakness(khufra, long_cooldowns).
hero_weakness(khufra, needs_team_follow_up).
hero_tag(khufra, cc_heavy).
hero_tag(khufra, anti_dash).
hero_tag(khufra, initiator_tag).

hero(atlas).
hero_role(atlas, tank).
hero_damage_type(atlas, magic).
hero_specialty(atlas, crowd_control).
hero_specialty(atlas, initiator).
hero_difficulty(atlas, moderate).
hero_lane(atlas, roam).
hero_strength(atlas, aoe_ultimate).
hero_strength(atlas, engage_range).
hero_strength(atlas, disruption).
hero_weakness(atlas, squishy_early).
hero_weakness(atlas, ult_can_be_interrupted).
hero_tag(atlas, cc_heavy).
hero_tag(atlas, initiator_tag).
hero_tag(atlas, aoe_cc).

hero(franco).
hero_role(franco, tank).
hero_damage_type(franco, physical).
hero_specialty(franco, crowd_control).
hero_difficulty(franco, moderate).
hero_lane(franco, roam).
hero_strength(franco, hook_pick_off).
hero_strength(franco, suppression_ult).
hero_strength(franco, tanky).
hero_weakness(franco, hook_dependent).
hero_weakness(franco, weak_if_misses_hook).
hero_tag(franco, cc_heavy).
hero_tag(franco, pick_off).
hero_tag(franco, suppression).

hero(hylos).
hero_role(hylos, tank).
hero_damage_type(hylos, magic).
hero_specialty(hylos, sustain).
hero_specialty(hylos, crowd_control).
hero_difficulty(hylos, easy).
hero_lane(hylos, roam).
hero_strength(hylos, high_hp_pool).
hero_strength(hylos, sustain_in_fights).
hero_strength(hylos, zone_control).
hero_weakness(hylos, countered_by_anti_heal).
hero_weakness(hylos, kitable).
hero_tag(hylos, sustain_hero).
hero_tag(hylos, frontline).
hero_tag(hylos, hp_based).

hero(akai).
hero_role(akai, tank).
hero_damage_type(akai, physical).
hero_specialty(akai, crowd_control).
hero_specialty(akai, initiator).
hero_difficulty(akai, moderate).
hero_lane(akai, roam).
hero_lane(akai, jungle).
hero_strength(akai, pin_enemies_to_wall).
hero_strength(akai, disruption).
hero_strength(akai, flexible_role).
hero_weakness(akai, needs_wall_positioning).
hero_weakness(akai, weak_without_ult).
hero_tag(akai, cc_heavy).
hero_tag(akai, initiator_tag).
hero_tag(akai, displacement).

hero(grock).
hero_role(grock, tank).
hero_damage_type(grock, physical).
hero_specialty(grock, crowd_control).
hero_specialty(grock, push).
hero_difficulty(grock, moderate).
hero_lane(grock, roam).
hero_strength(grock, early_game_damage).
hero_strength(grock, wall_power).
hero_strength(grock, terrain_control).
hero_weakness(grock, falls_off_late).
hero_weakness(grock, wall_dependent).
hero_tag(grock, early_game).
hero_tag(grock, frontline).

hero(johnson).
hero_role(johnson, tank).
hero_damage_type(johnson, magic).
hero_specialty(johnson, crowd_control).
hero_specialty(johnson, initiator).
hero_difficulty(johnson, moderate).
hero_lane(johnson, roam).
hero_strength(johnson, global_engage).
hero_strength(johnson, surprise_ganks).
hero_strength(johnson, stun_cc).
hero_weakness(johnson, car_can_be_dodged).
hero_weakness(johnson, weak_without_ult).
hero_tag(johnson, cc_heavy).
hero_tag(johnson, initiator_tag).
hero_tag(johnson, global_presence).

hero(lolita).
hero_role(lolita, tank).
hero_role(lolita, support).
hero_damage_type(lolita, physical).
hero_specialty(lolita, crowd_control).
hero_difficulty(lolita, moderate).
hero_lane(lolita, roam).
hero_strength(lolita, projectile_block).
hero_strength(lolita, aoe_stun_ult).
hero_strength(lolita, anti_projectile).
hero_weakness(lolita, weak_against_melee).
hero_weakness(lolita, ult_can_be_interrupted).
hero_tag(lolita, anti_projectile).
hero_tag(lolita, cc_heavy).
hero_tag(lolita, frontline).

hero(belerick).
hero_role(belerick, tank).
hero_damage_type(belerick, magic).
hero_specialty(belerick, crowd_control).
hero_specialty(belerick, sustain).
hero_difficulty(belerick, easy).
hero_lane(belerick, roam).
hero_strength(belerick, damage_reflection).
hero_strength(belerick, hp_scaling).
hero_strength(belerick, taunt_cc).
hero_weakness(belerick, slow_mobility).
hero_weakness(belerick, countered_by_anti_heal).
hero_tag(belerick, sustain_hero).
hero_tag(belerick, hp_based).
hero_tag(belerick, damage_reflect).

hero(edith).
hero_role(edith, tank).
hero_role(edith, marksman).
hero_damage_type(edith, hybrid).
hero_specialty(edith, crowd_control).
hero_specialty(edith, burst).
hero_difficulty(edith, moderate).
hero_lane(edith, exp).
hero_lane(edith, roam).
hero_strength(edith, form_switch_versatility).
hero_strength(edith, cc_in_tank_form).
hero_strength(edith, burst_in_ult_form).
hero_weakness(edith, vulnerable_during_ult).
hero_weakness(edith, needs_good_timing).
hero_tag(edith, cc_heavy).
hero_tag(edith, hybrid_damage).
hero_tag(edith, form_switcher).

hero(chip).
hero_role(chip, support).
hero_damage_type(chip, magic).
hero_specialty(chip, crowd_control).
hero_specialty(chip, support_spec).
hero_difficulty(chip, moderate).
hero_lane(chip, roam).
hero_strength(chip, global_teleport_ult).
hero_strength(chip, map_control).
hero_strength(chip, engage_disengage).
hero_weakness(chip, low_damage).
hero_weakness(chip, ult_requires_coordination).
hero_tag(chip, cc_heavy).
hero_tag(chip, global_presence).
hero_tag(chip, utility_tank).

% ----------------------------------------------------------------------------
% FIGHTERS
% ----------------------------------------------------------------------------
hero(yu_zhong).
hero_role(yu_zhong, fighter).
hero_damage_type(yu_zhong, physical).
hero_specialty(yu_zhong, sustain).
hero_specialty(yu_zhong, chase).
hero_difficulty(yu_zhong, moderate).
hero_lane(yu_zhong, exp).
hero_strength(yu_zhong, massive_sustain).
hero_strength(yu_zhong, dragon_form_cc_immune).
hero_strength(yu_zhong, strong_team_fights).
hero_weakness(yu_zhong, countered_by_anti_heal).
hero_weakness(yu_zhong, slow_early_game).
hero_weakness(yu_zhong, needs_to_stack_passive).
hero_tag(yu_zhong, sustain_hero).
hero_tag(yu_zhong, frontline).
hero_tag(yu_zhong, cc_immune_ult).

hero(esmeralda).
hero_role(esmeralda, fighter).
hero_role(esmeralda, mage).
hero_damage_type(esmeralda, magic).
hero_specialty(esmeralda, sustain).
hero_specialty(esmeralda, burst).
hero_difficulty(esmeralda, moderate).
hero_lane(esmeralda, exp).
hero_lane(esmeralda, jungle).
hero_strength(esmeralda, shield_absorption).
hero_strength(esmeralda, sustain_through_shields).
hero_strength(esmeralda, anti_shield).
hero_weakness(esmeralda, countered_by_anti_heal).
hero_weakness(esmeralda, cc_vulnerable).
hero_weakness(esmeralda, weak_against_burst).
hero_tag(esmeralda, sustain_hero).
hero_tag(esmeralda, shield_counter).
hero_tag(esmeralda, magic_damage_dealer).

hero(chou).
hero_role(chou, fighter).
hero_damage_type(chou, physical).
hero_specialty(chou, crowd_control).
hero_specialty(chou, chase).
hero_difficulty(chou, hard).
hero_lane(chou, exp).
hero_lane(chou, roam).
hero_strength(chou, cc_immune_skill1).
hero_strength(chou, pick_off_ult).
hero_strength(chou, high_mobility).
hero_weakness(chou, high_skill_cap).
hero_weakness(chou, squishy_if_built_damage).
hero_tag(chou, cc_heavy).
hero_tag(chou, pick_off).
hero_tag(chou, mobile_hero).
hero_tag(chou, cc_immune_skill).

hero(paquito).
hero_role(paquito, fighter).
hero_damage_type(paquito, physical).
hero_specialty(paquito, burst).
hero_specialty(paquito, chase).
hero_difficulty(paquito, hard).
hero_lane(paquito, exp).
hero_lane(paquito, jungle).
hero_strength(paquito, burst_combos).
hero_strength(paquito, cc_in_kit).
hero_strength(paquito, enhanced_skills).
hero_weakness(paquito, stack_management).
hero_weakness(paquito, needs_precise_combos).
hero_tag(paquito, burst_hero).
hero_tag(paquito, cc_heavy).
hero_tag(paquito, combo_hero).

hero(x_borg).
hero_role(x_borg, fighter).
hero_damage_type(x_borg, physical).
hero_specialty(x_borg, sustain).
hero_specialty(x_borg, push).
hero_difficulty(x_borg, easy).
hero_lane(x_borg, exp).
hero_strength(x_borg, true_damage_ult).
hero_strength(x_borg, sustain_with_armor).
hero_strength(x_borg, anti_sustain).
hero_weakness(x_borg, weak_without_armor).
hero_weakness(x_borg, kitable).
hero_tag(x_borg, sustain_hero).
hero_tag(x_borg, true_damage).

hero(thamuz).
hero_role(thamuz, fighter).
hero_damage_type(thamuz, physical).
hero_specialty(thamuz, sustain).
hero_specialty(thamuz, chase).
hero_difficulty(thamuz, easy).
hero_lane(thamuz, exp).
hero_lane(thamuz, jungle).
hero_strength(thamuz, extreme_sustain).
hero_strength(thamuz, strong_early_game).
hero_strength(thamuz, good_dueling).
hero_weakness(thamuz, countered_by_anti_heal).
hero_weakness(thamuz, falls_off_late).
hero_weakness(thamuz, kitable).
hero_tag(thamuz, sustain_hero).
hero_tag(thamuz, early_game).

hero(aldous).
hero_role(aldous, fighter).
hero_damage_type(aldous, physical).
hero_specialty(aldous, burst).
hero_specialty(aldous, chase).
hero_difficulty(aldous, easy).
hero_lane(aldous, exp).
hero_strength(aldous, infinite_scaling).
hero_strength(aldous, global_ult).
hero_strength(aldous, one_shot_late_game).
hero_weakness(aldous, weak_early_game).
hero_weakness(aldous, needs_stacks).
hero_weakness(aldous, ult_countered_by_cc).
hero_tag(aldous, late_game_carry).
hero_tag(aldous, global_presence).
hero_tag(aldous, scaling_hero).

hero(terizla).
hero_role(terizla, fighter).
hero_damage_type(terizla, physical).
hero_specialty(terizla, crowd_control).
hero_specialty(terizla, burst).
hero_difficulty(terizla, moderate).
hero_lane(terizla, exp).
hero_strength(terizla, damage_reduction).
hero_strength(terizla, cc_ult).
hero_strength(terizla, anti_burst).
hero_weakness(terizla, no_mobility).
hero_weakness(terizla, slow_attack_speed).
hero_weakness(terizla, kitable).
hero_tag(terizla, cc_heavy).
hero_tag(terizla, anti_burst).
hero_tag(terizla, immobile_hero).

hero(freya).
hero_role(freya, fighter).
hero_damage_type(freya, physical).
hero_specialty(freya, burst).
hero_specialty(freya, crowd_control).
hero_difficulty(freya, moderate).
hero_lane(freya, exp).
hero_lane(freya, jungle).
hero_strength(freya, strong_dueling).
hero_strength(freya, cc_in_kit).
hero_strength(freya, shield_generation).
hero_weakness(freya, no_dash_escape).
hero_weakness(freya, vulnerable_to_kite).
hero_tag(freya, burst_hero).
hero_tag(freya, shield_hero).

hero(ruby).
hero_role(ruby, fighter).
hero_damage_type(ruby, physical).
hero_specialty(ruby, crowd_control).
hero_specialty(ruby, sustain).
hero_difficulty(ruby, moderate).
hero_lane(ruby, exp).
hero_strength(ruby, lifesteal_passive).
hero_strength(ruby, aoe_cc).
hero_strength(ruby, cc_chain).
hero_weakness(ruby, countered_by_anti_heal).
hero_weakness(ruby, low_burst_damage).
hero_tag(ruby, sustain_hero).
hero_tag(ruby, cc_heavy).
hero_tag(ruby, lifesteal_hero).

hero(jawhead).
hero_role(jawhead, fighter).
hero_damage_type(jawhead, physical).
hero_specialty(jawhead, burst).
hero_specialty(jawhead, crowd_control).
hero_difficulty(jawhead, easy).
hero_lane(jawhead, exp).
hero_lane(jawhead, roam).
hero_strength(jawhead, throw_displacement).
hero_strength(jawhead, early_burst).
hero_strength(jawhead, flexible_role).
hero_weakness(jawhead, falls_off_late).
hero_weakness(jawhead, throw_can_backfire).
hero_tag(jawhead, displacement).
hero_tag(jawhead, early_game).
hero_tag(jawhead, pick_off).

hero(guinevere).
hero_role(guinevere, fighter).
hero_role(guinevere, mage).
hero_damage_type(guinevere, magic).
hero_specialty(guinevere, burst).
hero_specialty(guinevere, crowd_control).
hero_difficulty(guinevere, moderate).
hero_lane(guinevere, exp).
hero_strength(guinevere, airborne_combo).
hero_strength(guinevere, magic_burst).
hero_strength(guinevere, engage_potential).
hero_weakness(guinevere, needs_knock_up_to_combo).
hero_weakness(guinevere, squishy).
hero_weakness(guinevere, purify_counters_her).
hero_tag(guinevere, burst_hero).
hero_tag(guinevere, cc_heavy).
hero_tag(guinevere, magic_damage_dealer).
hero_tag(guinevere, dash_hero).

hero(arlott).
hero_role(arlott, fighter).
hero_damage_type(arlott, physical).
hero_specialty(arlott, burst).
hero_specialty(arlott, chase).
hero_difficulty(arlott, moderate).
hero_lane(arlott, exp).
hero_lane(arlott, jungle).
hero_strength(arlott, cc_in_kit).
hero_strength(arlott, sustain_passive).
hero_strength(arlott, strong_laning).
hero_weakness(arlott, needs_wall_for_stun).
hero_weakness(arlott, weak_in_open_areas).
hero_tag(arlott, burst_hero).
hero_tag(arlott, cc_heavy).
hero_tag(arlott, sustain_hero).

% ----------------------------------------------------------------------------
% ASSASSINS
% ----------------------------------------------------------------------------
hero(lancelot).
hero_role(lancelot, assassin).
hero_damage_type(lancelot, physical).
hero_specialty(lancelot, burst).
hero_specialty(lancelot, chase).
hero_difficulty(lancelot, very_hard).
hero_lane(lancelot, jungle).
hero_strength(lancelot, invincibility_frames).
hero_strength(lancelot, high_burst).
hero_strength(lancelot, high_mobility).
hero_weakness(lancelot, very_high_skill_cap).
hero_weakness(lancelot, squishy).
hero_weakness(lancelot, weak_against_cc).
hero_tag(lancelot, mobile_hero).
hero_tag(lancelot, burst_hero).
hero_tag(lancelot, immune_frames).
hero_tag(lancelot, dash_hero).

hero(fanny).
hero_role(fanny, assassin).
hero_damage_type(fanny, physical).
hero_specialty(fanny, burst).
hero_specialty(fanny, chase).
hero_difficulty(fanny, very_hard).
hero_lane(fanny, jungle).
hero_strength(fanny, unmatched_mobility).
hero_strength(fanny, early_game_dominance).
hero_strength(fanny, map_control).
hero_weakness(fanny, highest_skill_cap).
hero_weakness(fanny, energy_dependent).
hero_weakness(fanny, countered_by_cc).
hero_tag(fanny, mobile_hero).
hero_tag(fanny, burst_hero).
hero_tag(fanny, energy_based).
hero_tag(fanny, early_game).

hero(hayabusa).
hero_role(hayabusa, assassin).
hero_damage_type(hayabusa, physical).
hero_specialty(hayabusa, burst).
hero_specialty(hayabusa, push).
hero_difficulty(hayabusa, hard).
hero_lane(hayabusa, jungle).
hero_lane(hayabusa, exp).
hero_strength(hayabusa, split_push).
hero_strength(hayabusa, single_target_burst).
hero_strength(hayabusa, escape_ability).
hero_weakness(hayabusa, weak_in_team_fights).
hero_weakness(hayabusa, ult_dodgeable_with_allies).
hero_tag(hayabusa, split_push).
hero_tag(hayabusa, burst_hero).
hero_tag(hayabusa, mobile_hero).

hero(ling).
hero_role(ling, assassin).
hero_damage_type(ling, physical).
hero_specialty(ling, burst).
hero_specialty(ling, chase).
hero_difficulty(ling, very_hard).
hero_lane(ling, jungle).
hero_strength(ling, wall_walking).
hero_strength(ling, invincibility_ult).
hero_strength(ling, map_mobility).
hero_weakness(ling, energy_management).
hero_weakness(ling, weak_early_clears).
hero_weakness(ling, needs_walls).
hero_tag(ling, mobile_hero).
hero_tag(ling, burst_hero).
hero_tag(ling, immune_frames).
hero_tag(ling, energy_based).

hero(benedetta).
hero_role(benedetta, assassin).
hero_damage_type(benedetta, physical).
hero_specialty(benedetta, burst).
hero_specialty(benedetta, chase).
hero_difficulty(benedetta, very_hard).
hero_lane(benedetta, exp).
hero_lane(benedetta, jungle).
hero_strength(benedetta, dash_immunity).
hero_strength(benedetta, high_mobility).
hero_strength(benedetta, strong_laning).
hero_weakness(benedetta, high_skill_cap).
hero_weakness(benedetta, squishy).
hero_weakness(benedetta, needs_precise_timing).
hero_tag(benedetta, mobile_hero).
hero_tag(benedetta, burst_hero).
hero_tag(benedetta, dash_hero).
hero_tag(benedetta, immune_frames).

hero(gusion).
hero_role(gusion, assassin).
hero_damage_type(gusion, magic).
hero_specialty(gusion, burst).
hero_specialty(gusion, reap).
hero_difficulty(gusion, very_hard).
hero_lane(gusion, jungle).
hero_strength(gusion, instant_burst_combo).
hero_strength(gusion, high_mobility).
hero_strength(gusion, snowball_potential).
hero_weakness(gusion, very_high_skill_cap).
hero_weakness(gusion, falls_off_late).
hero_weakness(gusion, countered_by_tanky_comps).
hero_tag(gusion, burst_hero).
hero_tag(gusion, mobile_hero).
hero_tag(gusion, magic_damage_dealer).
hero_tag(gusion, combo_hero).

hero(helcurt).
hero_role(helcurt, assassin).
hero_damage_type(helcurt, physical).
hero_specialty(helcurt, burst).
hero_specialty(helcurt, push).
hero_difficulty(helcurt, moderate).
hero_lane(helcurt, jungle).
hero_strength(helcurt, silence).
hero_strength(helcurt, vision_denial_ult).
hero_strength(helcurt, strong_dueling).
hero_weakness(helcurt, squishy).
hero_weakness(helcurt, weak_team_fights).
hero_tag(helcurt, silence_hero).
hero_tag(helcurt, burst_hero).
hero_tag(helcurt, vision_denial).

hero(saber).
hero_role(saber, assassin).
hero_damage_type(saber, physical).
hero_specialty(saber, burst).
hero_specialty(saber, reap).
hero_difficulty(saber, easy).
hero_lane(saber, jungle).
hero_strength(saber, suppression_ult).
hero_strength(saber, easy_burst_combo).
hero_strength(saber, pick_off).
hero_weakness(saber, one_dimensional).
hero_weakness(saber, squishy).
hero_weakness(saber, weak_team_fights).
hero_tag(saber, suppression).
hero_tag(saber, burst_hero).
hero_tag(saber, pick_off).

hero(joy).
hero_role(joy, assassin).
hero_damage_type(joy, magic).
hero_specialty(joy, burst).
hero_specialty(joy, chase).
hero_difficulty(joy, hard).
hero_lane(joy, jungle).
hero_strength(joy, cc_immunity_during_ult).
hero_strength(joy, high_mobility).
hero_strength(joy, sustained_burst).
hero_weakness(joy, needs_minions_or_enemies_to_dash).
hero_weakness(joy, squishy).
hero_tag(joy, mobile_hero).
hero_tag(joy, burst_hero).
hero_tag(joy, magic_damage_dealer).
hero_tag(joy, cc_immune_ult).

hero(aamon).
hero_role(aamon, assassin).
hero_damage_type(aamon, magic).
hero_specialty(aamon, burst).
hero_specialty(aamon, chase).
hero_difficulty(aamon, moderate).
hero_lane(aamon, jungle).
hero_strength(aamon, camouflage).
hero_strength(aamon, poke_and_burst).
hero_strength(aamon, safe_assassination).
hero_weakness(aamon, weak_against_aoe).
hero_weakness(aamon, needs_shards_to_burst).
hero_tag(aamon, stealth_hero).
hero_tag(aamon, burst_hero).
hero_tag(aamon, magic_damage_dealer).

% ----------------------------------------------------------------------------
% MAGES
% ----------------------------------------------------------------------------
hero(valentina).
hero_role(valentina, mage).
hero_damage_type(valentina, magic).
hero_specialty(valentina, burst).
hero_specialty(valentina, poke).
hero_difficulty(valentina, hard).
hero_lane(valentina, mid).
hero_lane(valentina, jungle).
hero_strength(valentina, steals_enemy_ult).
hero_strength(valentina, high_burst).
hero_strength(valentina, sustain_passive).
hero_weakness(valentina, depends_on_enemy_ult).
hero_weakness(valentina, squishy).
hero_tag(valentina, burst_hero).
hero_tag(valentina, sustain_hero).
hero_tag(valentina, ult_copy).

hero(yve).
hero_role(yve, mage).
hero_damage_type(yve, magic).
hero_specialty(yve, poke).
hero_specialty(yve, crowd_control).
hero_difficulty(yve, moderate).
hero_lane(yve, mid).
hero_strength(yve, zone_control_ult).
hero_strength(yve, long_range_poke).
hero_strength(yve, slow_and_damage).
hero_weakness(yve, immobile_during_ult).
hero_weakness(yve, vulnerable_to_dive).
hero_tag(yve, poke_hero).
hero_tag(yve, cc_heavy).
hero_tag(yve, immobile_hero).
hero_tag(yve, zone_control).

hero(pharsa).
hero_role(pharsa, mage).
hero_damage_type(pharsa, magic).
hero_specialty(pharsa, poke).
hero_specialty(pharsa, burst).
hero_difficulty(pharsa, moderate).
hero_lane(pharsa, mid).
hero_strength(pharsa, extreme_range_ult).
hero_strength(pharsa, flight_mobility).
hero_strength(pharsa, siege_potential).
hero_weakness(pharsa, vulnerable_while_ulting).
hero_weakness(pharsa, squishy).
hero_weakness(pharsa, cc_cancels_ult).
hero_tag(pharsa, poke_hero).
hero_tag(pharsa, immobile_hero).
hero_tag(pharsa, long_range).

hero(kagura).
hero_role(kagura, mage).
hero_damage_type(kagura, magic).
hero_specialty(kagura, burst).
hero_specialty(kagura, poke).
hero_difficulty(kagura, very_hard).
hero_lane(kagura, mid).
hero_strength(kagura, purify_on_skill).
hero_strength(kagura, high_burst_combo).
hero_strength(kagura, safe_poke).
hero_weakness(kagura, very_high_skill_cap).
hero_weakness(kagura, needs_umbrella_positioning).
hero_tag(kagura, burst_hero).
hero_tag(kagura, poke_hero).
hero_tag(kagura, purify_skill).
hero_tag(kagura, mobile_hero).

hero(lunox).
hero_role(lunox, mage).
hero_damage_type(lunox, magic).
hero_specialty(lunox, burst).
hero_specialty(lunox, sustain).
hero_difficulty(lunox, moderate).
hero_lane(lunox, mid).
hero_lane(lunox, jungle).
hero_strength(lunox, damage_immunity_dark_ult).
hero_strength(lunox, sustain_light_mode).
hero_strength(lunox, penetration_bypass).
hero_weakness(lunox, needs_mode_management).
hero_weakness(lunox, vulnerable_between_modes).
hero_tag(lunox, burst_hero).
hero_tag(lunox, sustain_hero).
hero_tag(lunox, immune_frames).
hero_tag(lunox, magic_damage_dealer).

hero(cecilion).
hero_role(cecilion, mage).
hero_damage_type(cecilion, magic).
hero_specialty(cecilion, poke).
hero_specialty(cecilion, burst).
hero_difficulty(cecilion, moderate).
hero_lane(cecilion, mid).
hero_lane(cecilion, gold).
hero_strength(cecilion, infinite_mana_scaling).
hero_strength(cecilion, long_range_poke).
hero_strength(cecilion, late_game_monster).
hero_weakness(cecilion, immobile).
hero_weakness(cecilion, weak_early_game).
hero_weakness(cecilion, vulnerable_to_dive).
hero_tag(cecilion, scaling_hero).
hero_tag(cecilion, poke_hero).
hero_tag(cecilion, immobile_hero).
hero_tag(cecilion, late_game_carry).

hero(vale).
hero_role(vale, mage).
hero_damage_type(vale, magic).
hero_specialty(vale, burst).
hero_specialty(vale, crowd_control).
hero_difficulty(vale, moderate).
hero_lane(vale, mid).
hero_strength(vale, skill_enhancement_choice).
hero_strength(vale, high_burst).
hero_strength(vale, cc_or_damage_flexibility).
hero_weakness(vale, squishy).
hero_weakness(vale, immobile).
hero_weakness(vale, skill_shot_dependent).
hero_tag(vale, burst_hero).
hero_tag(vale, cc_heavy).
hero_tag(vale, immobile_hero).

hero(xavier).
hero_role(xavier, mage).
hero_damage_type(xavier, magic).
hero_specialty(xavier, poke).
hero_specialty(xavier, burst).
hero_difficulty(xavier, moderate).
hero_lane(xavier, mid).
hero_strength(xavier, global_range_ult).
hero_strength(xavier, poke_damage).
hero_strength(xavier, vision_on_hit).
hero_weakness(xavier, immobile).
hero_weakness(xavier, vulnerable_to_dive).
hero_weakness(xavier, skill_shot_reliant).
hero_tag(xavier, poke_hero).
hero_tag(xavier, immobile_hero).
hero_tag(xavier, global_presence).
hero_tag(xavier, long_range).

hero(novaria).
hero_role(novaria, mage).
hero_damage_type(novaria, magic).
hero_specialty(novaria, poke).
hero_specialty(novaria, burst).
hero_difficulty(novaria, moderate).
hero_lane(novaria, mid).
hero_strength(novaria, long_range_poke).
hero_strength(novaria, zone_denial).
hero_strength(novaria, shield_break).
hero_weakness(novaria, immobile).
hero_weakness(novaria, weak_against_dive).
hero_tag(novaria, poke_hero).
hero_tag(novaria, immobile_hero).
hero_tag(novaria, long_range).

% ----------------------------------------------------------------------------
% MARKSMEN
% ----------------------------------------------------------------------------
hero(beatrix).
hero_role(beatrix, marksman).
hero_damage_type(beatrix, physical).
hero_specialty(beatrix, burst).
hero_specialty(beatrix, poke).
hero_difficulty(beatrix, hard).
hero_lane(beatrix, gold).
hero_strength(beatrix, weapon_versatility).
hero_strength(beatrix, high_burst_sniper).
hero_strength(beatrix, flexible_range).
hero_weakness(beatrix, weapon_management).
hero_weakness(beatrix, squishy).
hero_tag(beatrix, burst_hero).
hero_tag(beatrix, long_range).
hero_tag(beatrix, physical_carry).

hero(brody).
hero_role(brody, marksman).
hero_damage_type(brody, physical).
hero_specialty(brody, burst).
hero_specialty(brody, poke).
hero_difficulty(brody, moderate).
hero_lane(brody, gold).
hero_lane(brody, exp).
hero_strength(brody, stacking_damage).
hero_strength(brody, strong_early_game).
hero_strength(brody, ult_execute).
hero_weakness(brody, slow_attack_speed).
hero_weakness(brody, outscaled_late).
hero_tag(brody, burst_hero).
hero_tag(brody, early_game).
hero_tag(brody, physical_carry).

hero(clint).
hero_role(clint, marksman).
hero_damage_type(clint, physical).
hero_specialty(clint, burst).
hero_specialty(clint, poke).
hero_difficulty(clint, moderate).
hero_lane(clint, gold).
hero_strength(clint, enhanced_basic_attack).
hero_strength(clint, long_poke_range).
hero_strength(clint, high_physical_burst).
hero_weakness(clint, immobile).
hero_weakness(clint, weak_against_dive).
hero_tag(clint, burst_hero).
hero_tag(clint, poke_hero).
hero_tag(clint, physical_carry).
hero_tag(clint, immobile_hero).

hero(moskov).
hero_role(moskov, marksman).
hero_damage_type(moskov, physical).
hero_specialty(moskov, burst).
hero_specialty(moskov, push).
hero_difficulty(moskov, moderate).
hero_lane(moskov, gold).
hero_strength(moskov, attack_speed_steroid).
hero_strength(moskov, penetrating_attacks).
hero_strength(moskov, stun_on_wall).
hero_weakness(moskov, short_range).
hero_weakness(moskov, needs_wall_for_stun).
hero_weakness(moskov, squishy).
hero_tag(moskov, dps_hero).
hero_tag(moskov, physical_carry).
hero_tag(moskov, attack_speed_hero).

hero(karrie).
hero_role(karrie, marksman).
hero_damage_type(karrie, hybrid).
hero_specialty(karrie, burst).
hero_specialty(karrie, chase).
hero_difficulty(karrie, moderate).
hero_lane(karrie, gold).
hero_lane(karrie, jungle).
hero_strength(karrie, true_damage_passive).
hero_strength(karrie, tank_shredder).
hero_strength(karrie, sustained_dps).
hero_weakness(karrie, squishy).
hero_weakness(karrie, short_range).
hero_weakness(karrie, weak_against_burst).
hero_tag(karrie, true_damage).
hero_tag(karrie, anti_tank).
hero_tag(karrie, dps_hero).
hero_tag(karrie, physical_carry).

hero(wanwan).
hero_role(wanwan, marksman).
hero_damage_type(wanwan, physical).
hero_specialty(wanwan, burst).
hero_specialty(wanwan, chase).
hero_difficulty(wanwan, hard).
hero_lane(wanwan, gold).
hero_strength(wanwan, purify_passive).
hero_strength(wanwan, invincible_ult).
hero_strength(wanwan, high_mobility).
hero_weakness(wanwan, needs_weak_point_activation).
hero_weakness(wanwan, squishy).
hero_weakness(wanwan, weak_early_game).
hero_tag(wanwan, mobile_hero).
hero_tag(wanwan, purify_skill).
hero_tag(wanwan, immune_frames).
hero_tag(wanwan, physical_carry).

hero(claude).
hero_role(claude, marksman).
hero_damage_type(claude, physical).
hero_specialty(claude, burst).
hero_specialty(claude, reap).
hero_difficulty(claude, moderate).
hero_lane(claude, gold).
hero_lane(claude, jungle).
hero_strength(claude, aoe_ult_damage).
hero_strength(claude, teleport_to_monkey).
hero_strength(claude, sustained_dps).
hero_weakness(claude, item_dependent).
hero_weakness(claude, weak_early_game).
hero_weakness(claude, needs_demon_hunter_sword).
hero_tag(claude, dps_hero).
hero_tag(claude, mobile_hero).
hero_tag(claude, physical_carry).

hero(bruno).
hero_role(bruno, marksman).
hero_damage_type(bruno, physical).
hero_specialty(bruno, burst).
hero_specialty(bruno, reap).
hero_difficulty(bruno, easy).
hero_lane(bruno, gold).
hero_strength(bruno, crit_scaling).
hero_strength(bruno, good_range).
hero_strength(bruno, easy_to_play).
hero_weakness(bruno, squishy).
hero_weakness(bruno, immobile).
hero_weakness(bruno, needs_items).
hero_tag(bruno, dps_hero).
hero_tag(bruno, physical_carry).
hero_tag(bruno, crit_hero).

hero(melissa).
hero_role(melissa, marksman).
hero_damage_type(melissa, physical).
hero_specialty(melissa, burst).
hero_specialty(melissa, push).
hero_difficulty(melissa, moderate).
hero_lane(melissa, gold).
hero_strength(melissa, anti_melee_zone).
hero_strength(melissa, strong_laning).
hero_strength(melissa, dps_in_zone).
hero_weakness(melissa, weak_against_range).
hero_weakness(melissa, zone_dependent).
hero_tag(melissa, dps_hero).
hero_tag(melissa, physical_carry).
hero_tag(melissa, anti_melee).
hero_tag(melissa, zone_control).

hero(irithel).
hero_role(irithel, marksman).
hero_damage_type(irithel, physical).
hero_specialty(irithel, burst).
hero_specialty(irithel, reap).
hero_difficulty(irithel, moderate).
hero_lane(irithel, gold).
hero_strength(irithel, attack_while_moving).
hero_strength(irithel, aoe_crit_ult).
hero_strength(irithel, late_game_power).
hero_weakness(irithel, weak_early_game).
hero_weakness(irithel, needs_items).
hero_weakness(irithel, squishy).
hero_tag(irithel, dps_hero).
hero_tag(irithel, physical_carry).
hero_tag(irithel, crit_hero).
hero_tag(irithel, late_game_carry).

% ----------------------------------------------------------------------------
% SUPPORTS
% ----------------------------------------------------------------------------
hero(rafaela).
hero_role(rafaela, support).
hero_damage_type(rafaela, magic).
hero_specialty(rafaela, sustain).
hero_specialty(rafaela, poke).
hero_difficulty(rafaela, easy).
hero_lane(rafaela, roam).
hero_strength(rafaela, team_healing).
hero_strength(rafaela, speed_boost).
hero_strength(rafaela, stun_ult).
hero_weakness(rafaela, countered_by_anti_heal).
hero_weakness(rafaela, squishy).
hero_weakness(rafaela, immobile).
hero_tag(rafaela, healer).
hero_tag(rafaela, sustain_hero).
hero_tag(rafaela, immobile_hero).

hero(estes).
hero_role(estes, support).
hero_damage_type(estes, magic).
hero_specialty(estes, sustain).
hero_difficulty(estes, easy).
hero_lane(estes, roam).
hero_strength(estes, strongest_healer).
hero_strength(estes, aoe_heal_ult).
hero_strength(estes, sustain_compositions).
hero_weakness(estes, hard_countered_by_anti_heal).
hero_weakness(estes, squishy).
hero_weakness(estes, no_cc).
hero_tag(estes, healer).
hero_tag(estes, sustain_hero).
hero_tag(estes, immobile_hero).

hero(angela).
hero_role(angela, support).
hero_damage_type(angela, magic).
hero_specialty(angela, support_spec).
hero_difficulty(angela, easy).
hero_lane(angela, roam).
hero_strength(angela, global_attach_ult).
hero_strength(angela, shield_and_heal).
hero_strength(angela, immobilize_skill).
hero_weakness(angela, vulnerable_alone).
hero_weakness(angela, needs_good_ally_to_attach).
hero_tag(angela, healer).
hero_tag(angela, global_presence).
hero_tag(angela, shield_hero).

hero(mathilda).
hero_role(mathilda, support).
hero_role(mathilda, assassin).
hero_damage_type(mathilda, magic).
hero_specialty(mathilda, support_spec).
hero_specialty(mathilda, mobility).
hero_difficulty(mathilda, moderate).
hero_lane(mathilda, roam).
hero_lane(mathilda, jungle).
hero_strength(mathilda, engage_and_shield).
hero_strength(mathilda, ally_dash).
hero_strength(mathilda, early_aggression).
hero_weakness(mathilda, falls_off_late).
hero_weakness(mathilda, needs_aggressive_team).
hero_tag(mathilda, mobile_hero).
hero_tag(mathilda, shield_hero).
hero_tag(mathilda, early_game).

hero(diggie).
hero_role(diggie, support).
hero_damage_type(diggie, magic).
hero_specialty(diggie, support_spec).
hero_specialty(diggie, crowd_control).
hero_difficulty(diggie, moderate).
hero_lane(diggie, roam).
hero_strength(diggie, anti_cc_ult).
hero_strength(diggie, vision_bombs).
hero_strength(diggie, poke_damage).
hero_weakness(diggie, squishy).
hero_weakness(diggie, low_sustain).
hero_tag(diggie, anti_cc).
hero_tag(diggie, poke_hero).
hero_tag(diggie, vision_control).

hero(floryn).
hero_role(floryn, support).
hero_damage_type(floryn, magic).
hero_specialty(floryn, sustain).
hero_specialty(floryn, support_spec).
hero_difficulty(floryn, easy).
hero_lane(floryn, roam).
hero_strength(floryn, global_heal_ult).
hero_strength(floryn, extra_equipment_passive).
hero_strength(floryn, strong_healing).
hero_weakness(floryn, countered_by_anti_heal).
hero_weakness(floryn, immobile).
hero_weakness(floryn, squishy).
hero_tag(floryn, healer).
hero_tag(floryn, sustain_hero).
hero_tag(floryn, global_presence).
hero_tag(floryn, immobile_hero).

hero(faramis).
hero_role(faramis, support).
hero_role(faramis, mage).
hero_damage_type(faramis, magic).
hero_specialty(faramis, support_spec).
hero_specialty(faramis, burst).
hero_difficulty(faramis, moderate).
hero_lane(faramis, roam).
hero_lane(faramis, mid).
hero_strength(faramis, resurrection_ult).
hero_strength(faramis, burst_damage).
hero_strength(faramis, sustain_passive).
hero_weakness(faramis, ult_zone_dependent).
hero_weakness(faramis, squishy).
hero_tag(faramis, resurrection).
hero_tag(faramis, burst_hero).
hero_tag(faramis, sustain_hero).


% ----------------------------------------------------------------------------
% COMPACT HERO TABLE (added heroes)
% hx(Name, Roles, Damage, Lanes, Difficulty, Specialties, Tags)
% ----------------------------------------------------------------------------
:- discontiguous hx/7.

hx(barats, [tank, fighter], physical, [exp], moderate, [crowd_control, sustain], [cc_heavy, frontline, sustain_hero, hp_based]).
hx(gatotkaca, [tank, fighter], physical, [exp, roam], moderate, [crowd_control, initiator], [cc_heavy, initiator_tag, frontline]).
hx(uranus, [tank], magic, [exp, jungle], easy, [sustain], [sustain_hero, frontline, hp_based]).
hx(minotaur, [tank, support], magic, [roam], moderate, [crowd_control, initiator], [cc_heavy, initiator_tag, frontline, pick_off]).
hx(baxia, [tank], magic, [roam], moderate, [crowd_control], [cc_heavy, frontline, anti_sustain]).
hx(gloo, [tank], magic, [exp, roam], moderate, [crowd_control, sustain], [frontline, hp_based, damage_reflect]).
hx(fredrinn, [fighter, tank], physical, [jungle, exp], moderate, [crowd_control, sustain], [frontline, cc_heavy, initiator_tag]).
hx(yin, [fighter], physical, [exp], hard, [burst, crowd_control], [cc_heavy, burst_hero, pick_off, combo_hero]).
hx(phoveus, [fighter], physical, [exp], moderate, [burst, chase], [anti_dash, burst_hero, mobile_hero]).
hx(cici, [fighter], physical, [exp], moderate, [sustain, burst], [sustain_hero, cc_heavy]).
hx(lukas, [fighter], physical, [exp], moderate, [sustain, burst], [sustain_hero, burst_hero, frontline]).
hx(kalea, [support, tank], magic, [roam, jungle, exp], moderate, [crowd_control, initiator], [cc_heavy, pick_off, frontline, initiator_tag]).
hx(sora, [fighter, tank], hybrid, [exp, jungle], hard, [burst, crowd_control], [burst_hero, cc_heavy, form_switcher]).
hx(aulus, [fighter], physical, [exp, jungle], moderate, [sustain, chase], [sustain_hero, cc_immune_skill, mobile_hero]).
hx(sun, [fighter], physical, [exp], easy, [push, chase], [split_push, dps_hero]).
hx(roger, [fighter, marksman], physical, [exp], moderate, [burst, chase], [burst_hero, mobile_hero, dash_hero]).
hx(suyou, [assassin, fighter], physical, [jungle, exp], hard, [burst, chase], [mobile_hero, burst_hero, dash_hero]).
hx(khaleed, [fighter], physical, [exp], moderate, [crowd_control], [cc_heavy, frontline]).
hx(balmond, [fighter], physical, [exp], easy, [burst], [frontline, early_game]).
hx(zilong, [fighter, assassin], physical, [exp], moderate, [chase, burst], [mobile_hero, dash_hero, early_game]).
hx(argus, [fighter], physical, [exp], moderate, [burst, sustain], [immune_frames, frontline]).
hx(lapu_lapu, [fighter], physical, [exp], moderate, [burst, crowd_control], [cc_heavy, sustain_hero, frontline]).
hx(alucard, [fighter, assassin], physical, [exp, jungle], moderate, [burst, chase, sustain], [lifesteal_hero, mobile_hero, dash_hero, burst_hero]).
hx(bane, [fighter, marksman], physical, [exp], easy, [push, poke], [poke_hero, split_push]).
hx(alpha, [fighter], physical, [exp], moderate, [sustain, push], [sustain_hero, early_game]).
hx(leomord, [fighter], physical, [exp], moderate, [chase, sustain], [mobile_hero, pick_off]).
hx(badang, [fighter], physical, [exp, roam], moderate, [crowd_control, burst], [cc_heavy, burst_hero, pick_off]).
hx(silvanna, [fighter, mage], magic, [exp], hard, [crowd_control, burst], [cc_heavy, magic_damage_dealer, burst_hero]).
hx(minsitthar, [fighter, tank], physical, [exp], moderate, [crowd_control], [cc_heavy, frontline, initiator_tag]).
hx(masha, [fighter], physical, [exp], moderate, [sustain], [sustain_hero, frontline, purify_skill]).
hx(hilda, [fighter, tank], physical, [exp], easy, [sustain], [sustain_hero, frontline]).
hx(dyrroth, [fighter], physical, [exp], moderate, [burst, sustain], [lifesteal_hero, burst_hero, sustain_hero]).
hx(martis, [fighter], physical, [exp], moderate, [crowd_control, chase], [cc_heavy, cc_immune_skill, pick_off]).
hx(obsidia, [marksman], physical, [gold], hard, [burst, reap], [dps_hero, physical_carry, scaling_hero, late_game_carry]).
hx(natan, [marksman, mage], magic, [gold], moderate, [burst, poke], [magic_damage_dealer, dps_hero, long_range]).
hx(granger, [marksman], physical, [gold], hard, [burst, poke], [burst_hero, long_range, physical_carry]).
hx(ixia, [marksman], physical, [gold], moderate, [burst, push], [dps_hero, physical_carry]).
hx(hanabi, [marksman], physical, [gold], moderate, [burst, chase], [dps_hero, crit_hero, mobile_hero, physical_carry, shield_hero]).
hx(miya, [marksman], physical, [gold], easy, [push, burst], [dps_hero, crit_hero, attack_speed_hero, physical_carry]).
hx(yi_sun_shin, [assassin, marksman], physical, [jungle], very_hard, [burst, chase], [mobile_hero, burst_hero, dash_hero]).
hx(layla, [marksman], physical, [gold], easy, [poke, burst], [long_range, immobile_hero, late_game_carry, physical_carry]).
hx(popol_and_kupa, [marksman], physical, [jungle, gold], moderate, [burst, chase], [dps_hero, mobile_hero, physical_carry]).
hx(lesley, [marksman], physical, [gold], moderate, [burst, reap], [long_range, burst_hero, stealth_hero, physical_carry]).
hx(kimmy, [marksman, mage], magic, [mid, gold], moderate, [burst, poke], [magic_damage_dealer, long_range, poke_hero]).
hx(zhuxin, [mage], magic, [mid], moderate, [crowd_control, poke], [cc_heavy, displacement, magic_damage_dealer, poke_hero]).
hx(alice, [mage, tank], magic, [mid], moderate, [sustain, burst], [sustain_hero, magic_damage_dealer, burst_hero]).
hx(zetian, [mage], magic, [mid], moderate, [poke, crowd_control], [poke_hero, long_range, immobile_hero, cc_heavy, global_presence, magic_damage_dealer]).
hx(harley, [assassin, mage], magic, [jungle, mid], hard, [burst], [burst_hero, combo_hero, mobile_hero, dash_hero, magic_damage_dealer]).
hx(zhask, [mage], magic, [mid], moderate, [push, burst], [poke_hero, immobile_hero, magic_damage_dealer]).
hx(eudora, [mage], magic, [mid], easy, [burst, crowd_control], [burst_hero, cc_heavy, magic_damage_dealer]).
hx(luo_yi, [mage], magic, [mid], hard, [crowd_control, burst], [cc_heavy, magic_damage_dealer, combo_hero, long_range]).
hx(cyclops, [mage], magic, [mid], easy, [burst, crowd_control], [burst_hero, cc_heavy, magic_damage_dealer]).
hx(chang_e, [mage], magic, [mid], moderate, [poke, burst], [poke_hero, magic_damage_dealer, long_range]).
hx(lylia, [mage], magic, [mid], moderate, [burst, poke], [burst_hero, magic_damage_dealer, long_range]).
hx(harith, [mage, marksman], magic, [mid, gold], hard, [burst, chase], [mobile_hero, dash_hero, burst_hero, magic_damage_dealer]).
hx(kadita, [mage, assassin], magic, [mid], hard, [burst, chase], [mobile_hero, burst_hero, magic_damage_dealer, cc_heavy]).
hx(valir, [mage], magic, [mid], moderate, [crowd_control, poke], [cc_heavy, poke_hero, displacement, magic_damage_dealer]).
hx(aurora, [mage], magic, [mid], moderate, [burst, crowd_control], [burst_hero, cc_heavy, magic_damage_dealer]).
hx(nana, [mage, support], magic, [mid, roam], easy, [crowd_control], [cc_heavy, magic_damage_dealer, poke_hero]).
hx(vexana, [mage], magic, [mid], moderate, [burst, crowd_control], [burst_hero, cc_heavy, magic_damage_dealer, poke_hero]).
hx(gord, [mage], magic, [mid], easy, [poke, burst], [poke_hero, long_range, immobile_hero, magic_damage_dealer]).
hx(odette, [mage], magic, [mid], moderate, [burst, crowd_control], [cc_heavy, burst_hero, magic_damage_dealer]).
hx(julian, [assassin, fighter], physical, [jungle, mid, exp], hard, [burst, chase], [burst_hero, mobile_hero, dash_hero, combo_hero, early_game]).
hx(hirara, [assassin], physical, [jungle], hard, [burst, chase], [mobile_hero, burst_hero, dash_hero]).
hx(karina, [assassin], magic, [jungle], moderate, [burst, reap], [burst_hero, mobile_hero, dash_hero, magic_damage_dealer]).
hx(natalia, [assassin], physical, [jungle], moderate, [burst, chase], [stealth_hero, burst_hero, silence_hero]).
hx(selena, [assassin, mage], magic, [mid, roam, jungle], hard, [burst, crowd_control], [stealth_hero, burst_hero, mobile_hero, magic_damage_dealer, cc_heavy]).
hx(nolan, [assassin], physical, [jungle], hard, [burst, chase], [mobile_hero, burst_hero, dash_hero]).
hx(hanzo, [assassin], physical, [jungle], hard, [burst], [burst_hero, mobile_hero]).
hx(kaja, [support, fighter], magic, [roam], moderate, [crowd_control], [cc_heavy, pick_off, initiator_tag, displacement]).
hx(marcel, [support, tank], magic, [roam], moderate, [support_spec, crowd_control], [shield_hero, cc_heavy]).
hx(carmilla, [support, tank], magic, [roam, exp], moderate, [crowd_control, sustain], [cc_heavy, frontline]).

hero(H)               :- hx(H, _, _, _, _, _, _).
hero_role(H, R)       :- hx(H, Rs, _, _, _, _, _), member(R, Rs).
hero_damage_type(H,D) :- hx(H, _, D, _, _, _, _).
hero_lane(H, L)       :- hx(H, _, _, Ls, _, _, _), member(L, Ls).
hero_difficulty(H, D) :- hx(H, _, _, _, D, _, _).
hero_specialty(H, S)  :- hx(H, _, _, _, _, Ss, _), member(S, Ss).
hero_tag(H, T)        :- hx(H, _, _, _, _, _, Ts), member(T, Ts).

% Current-season tier comes from the season.pl snapshot.
hero_tier(H, T)       :- season_tier(H, T).

% ============================================================================
% UTILITY PREDICATES
% ============================================================================

%% all_heroes(-Heroes) is det.
%  Returns a sorted list of all hero names.
all_heroes(Heroes) :-
    findall(H, hero(H), Hs),
    sort(Hs, Heroes).

%% heroes_by_role(+Role, -Heroes) is det.
%  Returns all heroes matching the given role.
heroes_by_role(Role, Heroes) :-
    findall(H, hero_role(H, Role), Hs),
    sort(Hs, Heroes).

%% heroes_by_tier(+Tier, -Heroes) is det.
%  Returns all heroes matching the given tier.
heroes_by_tier(Tier, Heroes) :-
    findall(H, hero_tier(H, Tier), Hs),
    sort(Hs, Heroes).

%% heroes_by_lane(+Lane, -Heroes) is det.
%  Returns all heroes matching the given lane.
heroes_by_lane(Lane, Heroes) :-
    findall(H, hero_lane(H, Lane), Hs),
    sort(Hs, Heroes).

%% hero_info(+Hero) is det.
%  Prints detailed information about a hero.
hero_info(Hero) :-
    hero(Hero),
    findall(R, hero_role(Hero, R), Roles),
    findall(D, hero_damage_type(Hero, D), DTypes),
    findall(S, hero_specialty(Hero, S), Specs),
    hero_tier(Hero, Tier),
    hero_difficulty(Hero, Diff),
    findall(L, hero_lane(Hero, L), Lanes),
    findall(St, hero_strength(Hero, St), Strengths),
    findall(Wk, hero_weakness(Hero, Wk), Weaknesses),
    findall(T, hero_tag(Hero, T), Tags),
    format_hero_name(Hero, FName),
    format('~n╔══════════════════════════════════════════╗~n'),
    format('║  ~w~n', [FName]),
    format('╚══════════════════════════════════════════╝~n'),
    format('  Role(s)      : ~w~n', [Roles]),
    format('  Damage Type  : ~w~n', [DTypes]),
    format('  Specialty    : ~w~n', [Specs]),
    format('  Tier         : ~w~n', [Tier]),
    format('  Difficulty   : ~w~n', [Diff]),
    format('  Lane(s)      : ~w~n', [Lanes]),
    format('  Strengths    : ~w~n', [Strengths]),
    format('  Weaknesses   : ~w~n', [Weaknesses]),
    format('  Tags         : ~w~n', [Tags]),
    nl.

%% format_hero_name(+Atom, -Formatted) is det.
%  Converts hero atom to a formatted display name.
format_hero_name(Hero, Formatted) :-
    atom_string(Hero, Str),
    split_string(Str, "_", "", Parts),
    maplist(capitalize_word, Parts, Caps),
    atomic_list_concat(Caps, ' ', Formatted).

capitalize_word(Word, Cap) :-
    atom_string(A, Word),
    atom_chars(A, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Cap, [Upper|Rest]).
