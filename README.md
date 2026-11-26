# ML Counter Assistant

A program made in SWI-Prolog that helps Mobile Legends: Bang Bang players pick heroes and choose items when they are facing an enemy team. It was made for our IT 405 (Logic Programming) final project at Southern Leyte State University, San Juan Campus.

## What it is for

When you are in the draft phase of a Mobile Legends match, you have to decide fast which hero to pick and what to build. Our program helps with that. You tell it the enemy heroes, and it tells you which heroes counter them and what items you should build.

All the thinking is done in Prolog (the `.pl` files). The web page is only there to make it easier to use, and it just asks Prolog the questions and shows the answers. You can also use the program with only the Prolog console, no browser needed.

## Features

- Counter Pick - type in one to five enemy heroes and it gives you the best heroes to counter them, ranked by score. It uses saved facts (like Khufra counters Fanny) and also rules based on hero tags (like an anti-dash hero counters a dash hero).
- Draft Board - checks your team for missing roles and damage balance, then suggests the best pick for each role.
- Counter Build - picks boots, defense items, anti-heal and the main items based on the enemy team (how much physical or magic damage, how much crowd control, if they have healing or burst).
- Meta - a tier list and ban suggestions for the current season (November 2026).
- Hero database - 133 heroes and 54 items, plus `why_counter/2` which explains why one hero counters another.

## What we used

- SWI-Prolog 9 or newer (the main part of the project)
- SWI-Prolog's built-in HTTP library, for the small web server
- HTML, CSS and JavaScript for the web page (optional)
- plunit, for the automated tests

## Folder structure

```
ml-counter-assistant/
  README.md
  src/
    prolog/          all the Prolog files
      heroes.pl      heroes and their tags
      items.pl       items
      counters.pl    counter facts, counter rules and scoring
      builds.pl      item build logic
      meta.pl        team checks, drafting, tier list and bans
      season.pl      the November 2026 tier and ban data
      main.pl        console menu (run this for the Prolog-only version)
      api.pl         turns the Prolog answers into data for the web page
      server.pl      the web server
    frontend/        the web page and the images
  tests/tests.pl     automated tests
  docs/              project documentation (PDF)
```

## How to run it

First, install SWI-Prolog from https://www.swi-prolog.org/Download.html and then get the project:

```
git clone https://github.com/jewekyut/ml-counter-assistant.git
cd ml-counter-assistant
```

Option 1: Prolog console

```
swipl src/prolog/main.pl
```

Then type `start.` at the prompt. A menu will show up. Type a number and press Enter.

Option 2: Web page

```
swipl src/prolog/server.pl
```

Then open http://localhost:8080/ in your browser. To stop the server, type `stop_server.` in the Prolog window.

If you are on Windows and prefer the SWI-Prolog window, open it and type:
`consult('src/prolog/server.pl').`

-Run the tests-

```
swipl -g run_tests -t halt tests/tests.pl
```

All the tests should pass.

## Sample queries

Start with `swipl src/prolog/main.pl` and then try these:

```prolog
?- hard_counter(khufra, fanny).
true.

?- counters(phoveus, julian).
true.
```
This one is not a saved fact. Prolog works it out from the hero tags.

```prolog
?- get_counter_picks(fanny, Picks).
Picks = [counter(khufra,hard), counter(franco,hard), counter(vale,soft), counter(akai,soft)].

?- best_counter_for_team([fanny,atlas,vale], Top).
Top = [4-khufra, 4-diggie, 3-franco, 3-valentina, 3-karrie, 2-akai, 2-paquito, 2-saber, 2-novaria, 2-beatrix].

?- recommend_boots([atlas,tigreal,fanny], Boots).
Boots = tough_boots.

?- recommend_build(karrie, [estes,floryn], Build).
Build = [tough_boots, demon_hunter_sword, golden_staff, great_dragon_spear, dominance_ice, athenas_shield] .

?- why_counter(karrie, gloo).
  Why Karrie counters Gloo:
    ★ HARD COUNTER
    Reason: Gloo is weak to true damage and percent-HP damage, which Karrie delivers
```

These two show what happens when the input is wrong or nothing matches:

```prolog
?- hero(nobody).
false.

?- counters(khufra, khufra).
false.
```

Other things you can try: `counter_pick_analysis/1`, `build_analysis/2`, `draft_helper/2`, `tier_list/0`, `ban_recommendations/0`, `team_comp_check/1` and `hero_info/1`.

## Group members

| Humphrey M. Basas 
| Jeruel L. Malubay
| John Rico G. Paciencia
| Jonathan P. Ouano 
| Kim Benedict Braga
| Joemar Ermita

## Notes

- The tier list and ban data come from two November 2026 tier lists (esports.gg and PocketGamer). We combined them into one score.
- The hero and item pictures belong to Moonton. We only use them for this school project.
- The full report is in `docs/Project_Documentation.pdf`. It also says which parts we got AI help with.