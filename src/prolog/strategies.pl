:- module(strategies, [recommend_strategies/3]).
:- use_module(heroes).
:- use_module(meta).
:- use_module(season).
:- use_module(library(lists)).
:- use_module(library(apply)).

lane(exp). lane(jungle). lane(mid). lane(gold). lane(roam).
party(1). party(2). party(3). party(5).
known_pair(A,B) :- once((synergy(A,B);synergy(B,A))).
valid_pick(H-L) :- hero(H), hero_lane(H,L).
base(H,S) :- (once(season_score(H,V)) -> S=V ; S=0).
team_score(Picks,S) :-
    findall(V,(member(H-_,Picks),base(H,V)),Vs), sum_list(Vs,B),
    findall(1,(append(_,[A-_|Rest],Picks),member(C-_,Rest),known_pair(A,C)),Pairs),
    length(Pairs,N), S is B+3*N.

% Named archetypes are curated rules, not measured win rates.
profile(ube,'UBE - Ultimate Bonding Experience','Group around objectives and keep allies within healing range.','Sustain and formation','Anti-heal, displacement and split pressure').
profile(wombo,'Wombo combo','Stagger initiation and area crowd control.','Coordinated teamfight control','Disengage and anti-control').
profile(dive,'Backline dive','Coordinate flank angles and attack vulnerable carries.','Mobility and burst','Anti-dash and suppression').
profile(split,'Split pressure','Push side lanes and regroup for objectives.','Map and turret pressure','Fast rotations and hard engage').
anchor(ube,estes,roam).
anchor(wombo,H,roam) :- hero_tag(H,initiator_tag), hero_tag(H,cc_heavy).
anchor(dive,H,jungle) :- hero_tag(H,mobile_hero), hero_tag(H,burst_hero).
anchor(split,H,jungle) :- hero_tag(H,split_push).
bonus(ube,H,3) :- once((hero_tag(H,sustain_hero);hero_tag(H,frontline))), !.
bonus(wombo,H,3) :- hero_tag(H,cc_heavy), !.
bonus(dive,H,3) :- hero_tag(H,mobile_hero), !.
bonus(split,H,3) :- once((hero_tag(H,split_push);hero_specialty(H,push))), !.
bonus(_,_,0).

% Greedy bounded completion: choose highest-scoring eligible hero per open lane.
complete([],_,P,P).
complete([L|Ls],Kind,P,Out) :-
    (member(_-L,P) -> complete(Ls,Kind,P,Out)
    ; findall(K-(H-L),(valid_pick(H-L),\+ member(H-_,P),team_score([H-L|P],S),bonus(Kind,H,B),K is -(S+B)),Rows),
      keysort(Rows,[_-Pick|_]), complete(Ls,Kind,[Pick|P],Out)).

candidate(1,[H-L],solo,'Solo lane pick','Play your assigned lane and coordinate with teammates.','Season score and lane eligibility','See hero weaknesses') :- valid_pick(H-L).
candidate(2,[A-L,B-M],synergy,'Recorded duo synergy','Coordinate the two heroes around their complementary abilities.','Recorded synergy in meta.pl','Other lanes need teammates') :-
    synergy(A,B), valid_pick(A-L),valid_pick(B-M), L\=M,A\=B.
candidate(3,P,synergy,'Synergy-based trio','Coordinate the recorded pair with a third lane.','Recorded pair plus ranked lane coverage','Other lanes need teammates') :-
    candidate(2,Pair,_,_,_,_,_), lane(L), \+ member(_-L,Pair), complete([L],synergy,Pair,P).
candidate(5,P,K,Name,How,Strength,Weak) :-
    profile(K,Name,How,Strength,Weak), anchor(K,H,L), valid_pick(H-L),
    complete([roam,jungle,exp,mid,gold],K,[H-L],P).

pick_dict(H-L,pick{id:H,lane:L,strengths:St,weaknesses:W}) :-
    findall(X,hero_strength(H,X),St),findall(X,hero_weakness(H,X),W).
row(N,L,Key-D) :-
    candidate(N,P0,K,Name,How,Strength,Weak), sort(P0,P),
    (L=all -> true ; member(_-L,P)), team_score(P,S),
    maplist(pick_dict,P,Ps),
    findall([A,B],(append(_,[A-_|Rest],P),member(B-_,Rest),known_pair(A,B)),Pairs),
    Key is -S, D=strategy{size:N,kind:K,name:Name,picks:Ps,execution:How,strength:Strength,weakness:Weak,score:S,synergies:Pairs}.
limit(0,_,[]) :- !.
limit(_,[],[]) :- !.
limit(N,[_-D|T],[D|R]) :- N1 is N-1,limit(N1,T,R).
% Preserve each named five-player archetype in the results.
ranked(5,L,Ds) :- !,
    findall(D,(profile(K,_,_,_,_),findall(Key-R,(row(5,L,Key-R),get_dict(kind,R,K)),Rows),sort(Rows,[_-D|_])),Ds).
ranked(N,L,Ds) :- findall(R,row(N,L,R),Rows),sort(Rows,Sorted),limit(15,Sorted,Ds).
recommend_strategies(N,L,Ds) :-
    (L==all;lane(L)),
    (N==0 -> findall(D,(party(P),ranked(P,L,R),member(D,R)),Ds);party(N),ranked(N,L,Ds)).
