# ML Counter Assistant

An expert system, written in **SWI-Prolog**, that helps *Mobile Legends: Bang Bang* players with
**counter picking**, **drafting** and **counter building**, using a November 2026 meta snapshot.

> IT 405 – Logic Programming Final Group Project · Southern Leyte State University, San Juan Campus

## Purpose and features

Prolog makes every decision; the web page is only a front-end that asks Prolog questions.

| Feature | What Prolog does |
|---|---|
| **Counter Pick** | Finds heroes that counter one or more enemy heroes, from stored facts (`hard_counter/2`, `soft_counter/2`) **and** from rules over hero tags (e.g. an *anti-dash* hero counters a *dash* hero). Scores and ranks the results. |
| **Draft Board** | Detects missing roles in your team, checks damage-type balance and synergies, and ranks the best pick per role by counter value + team fit + meta tier. |
| **Counter Build** | Chooses boots, defence, anti-heal and core items from the enemy team's damage mix, crowd control, sustain and burst. |
| **Meta analysis** | Tier list and ban priority derived from a consensus of two November 2026 tier lists. |
| **Hero database** | 133 heroes with roles, damage type, lanes, tags and a counter explanation (`why_counter/2`). |

Intended users: Mobile Legends players, especially during the draft/ban phase.

## Technology stack

- **SWI-Prolog 9+** (knowledge base, rules, reasoning) – required
- SWI-Prolog `library(http/*)` for the small JSON web server (`server.pl`)
- HTML / CSS / vanilla JavaScript front-end (optional, in `src/frontend/`)
- `plunit` for automated tests

## Repository structure

```
ml-counter-assistant/
  README.md
  src/
    prolog/            # knowledge base, rules, queries
      heroes.pl        #   133 heroes + tags (knowledge representation)
      items.pl         #   54 items
      counters.pl      #   counter facts + tag-based counter rules + scoring
      builds.pl        #   counter-build reasoning
      meta.pl          #   team composition, drafting, ban/tier logic
      season.pl        #   Nov 2026 meta snapshot (tiers, bans)
      main.pl          #   console menu (run this for the Prolog-only version)
      api.pl           #   JSON-ready views of the predicates above
      server.pl        #   HTTP server for the web front-end
    frontend/          # optional web interface
      index.html
      img/             #   hero portraits, thumbnails, item icons
  tests/tests.pl       # automated plunit tests
  docs/Project_Documentation.pdf
```

## Installation and launch

1. Install SWI-Prolog 9 or newer from <https://www.swi-prolog.org/Download.html>.
2. Clone this repository: `git clone <repository-url>` and `cd ml-counter-assistant`.

**A. Prolog console (no browser needed)**

```
swipl src/prolog/main.pl
?- start.
```

Type a menu number and press Enter. You can also query directly (see below).

**B. Web interface**

```
swipl src/prolog/server.pl
```

Open <http://localhost:8080/>. Stop it with `?- stop_server.`

> On Windows you can also open SWI-Prolog and run
> `?- consult('src/prolog/server.pl').`

**C. Run the tests**

```
swipl -g run_tests -t halt tests/tests.pl
```

## Sample Prolog queries (with expected output)

Load first: `swipl src/prolog/main.pl`

```prolog
?- hard_counter(khufra, fanny).
true.

?- counters(phoveus, julian).          % not a stored fact: inferred from tags
true.

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

?- hero(nobody).                       % invalid input
false.

?- counters(khufra, khufra).           % unsuccessful case
false.
```

Other useful entry points: `counter_pick_analysis/1`, `build_analysis/2`, `draft_helper/2`,
`tier_list/0`, `ban_recommendations/0`, `team_comp_check/1`, `hero_info/1`.

## Group members

| Member | Responsibility |
|---|---|
| _Name 1_ | _e.g. knowledge base (`heroes.pl`, `items.pl`)_ |
| _Name 2_ | _e.g. counter reasoning (`counters.pl`)_ |
| _Name 3_ | _e.g. build and meta logic (`builds.pl`, `meta.pl`)_ |
| _Name 4_ | _e.g. web front-end and server (`api.pl`, `server.pl`, `index.html`)_ |
| _Name 5_ | _e.g. testing and documentation_ |

## Credits and notes

- Meta data: consensus of the esports.gg and PocketGamer MLBB tier lists (November 2026).
- Hero and item artwork belongs to Moonton; it is used here for non-commercial, educational purposes only.
- Libraries: SWI-Prolog (BSD-2-Clause), plunit, SWI-Prolog HTTP libraries.
- See `docs/Project_Documentation.pdf` for the full report, including AI-assistance disclosure.
