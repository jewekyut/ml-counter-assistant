:- module(team_draft,[recommend_draft/5]).
:- use_module(heroes).
:- use_module(counters).
:- use_module(meta, [synergy/2]).
:- use_module(season, [season_score/2]).
:- use_module(winrates, [adjusted_winrate/2]).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Heuristic composition ranking, not a calibrated win probability.
lanes([roam,jungle,mid,gold,exp]).
weights(1,30,5,10,20,30,5).
weights(2,25,30,15,15,10,5).
weights(3,25,30,20,10,5,10).
weights(5,25,25,25,10,0,15).
valid(Hs) :- is_list(Hs), sort(Hs,S), same_length(Hs,S), maplist(hero,Hs).
subset_lanes(0,_,[]) :- !.
subset_lanes(N,[L|Ls],[L|Rest]) :- N>0, M is N-1, subset_lanes(M,Ls,Rest).
subset_lanes(N,[_|Ls],Rest) :- N>0, subset_lanes(N,Ls,Rest).
match(H,E,3) :- hard_counter(H,E), !.
match(H,E,2) :- soft_counter(H,E), !.
match(H,E,1) :- counters(H,E), !.
match(_,_,0).
flag(H,Tags,1) :- member(T,Tags),hero_tag(H,T), !.
flag(_,_,0).
feature(Enemies,H,f(H,Ls,C,M,I,F,K,P,G,D)) :-
    findall(L,hero_lane(H,L),L0),sort(L0,Ls),
    maplist(match(H),Enemies,C),
    (season_score(H,S)->true;S=2.5),
    (adjusted_winrate(H,W)->true;W=50), M is (S/5+max(0,min(1,(W-40)/20)))/2,
    flag(H,[mobile_hero,sustain_hero,split_push],I),
    flag(H,[frontline],F), flag(H,[cc_heavy,initiator_tag],K),
    (once((hero_damage_type(H,physical);hero_damage_type(H,hybrid)))->P=1;P=0),
    (once((hero_damage_type(H,magic);hero_damage_type(H,hybrid)))->G=1;G=0),
    flag(H,[dps_hero,split_push],D).
known(A,B) :- once((synergy(A,B);synergy(B,A))).
colmax([],[],[]).
colmax([A|As],[B|Bs],[C|Cs]) :- C is max(A,B),colmax(As,Bs,Cs).
coverage([f(_,_,C,_,_,_,_,_,_,_)|Fs],Out) :- foldl(merge_cov,Fs,C,Out).
merge_cov(f(_,_,C,_,_,_,_,_,_,_),A,B) :- colmax(C,A,B).
score(N,Pairs,S) :-
    pairs_features(Pairs,Fs),length(Fs,K),K>0,
    coverage(Fs,C),sum_list(C,CS),length(C,EC), Counter is CS/max(1,3*EC),
    findall(1,(append(_,[A-_|Rest],Pairs),member(B-_,Rest),A=f(H,_,_,_,_,_,_,_,_,_),B=f(J,_,_,_,_,_,_,_,_,_),known(H,J)),Syn),
    length(Syn,SN), Synergy is min(1,SN/max(1,K-1)),
    findall(M,member(f(_,_,_,M,_,_,_,_,_,_),Fs),Ms),sum_list(Ms,MS),Meta is MS/K,
    findall(I,member(f(_,_,_,_,I,_,_,_,_,_),Fs),Is),sum_list(Is,IS),Ind is IS/K,
    (member(f(_,_,_,_,_,1,_,_,_,_),Fs)->Front=1;Front=0),
    (member(f(_,_,_,_,_,_,1,_,_,_),Fs)->CC=1;CC=0),
    (member(f(_,_,_,_,_,_,_,1,_,_),Fs)->Phys=1;Phys=0),
    (member(f(_,_,_,_,_,_,_,_,1,_),Fs)->Magic=1;Magic=0),
    (member(f(_,_,_,_,_,_,_,_,_,1),Fs)->Dps=1;Dps=0),
    Balance is (Front+Phys+Magic)/3, Obj is (CC+Dps+Front)/3,
    weights(N,A,B,CW,D,E,F),S is A*Counter+B*Synergy+CW*Balance+D*Meta+E*Ind+F*Obj.
pairs_features(P,Fs) :- findall(F,member(F-_,P),Fs).
selected(P,H) :- member(f(H,_,_,_,_,_,_,_,_,_)-_,P).
locked_assignment([],_,_,[]).
locked_assignment([H|Hs],Ls,Features,[F-L|Ps]) :-
    member(F,Features),F=f(H,Eligible,_,_,_,_,_,_,_,_),member(L,Eligible),select(L,Ls,Rest),locked_assignment(Hs,Rest,Features,Ps).
% Keep a bounded beam of 24 partial compositions per lane assignment.
beam([],_,_,States,States).
beam([L|Ls],N,Features,States,Out) :-
    findall(Key-P,(member(_-Old,States),member(F,Features),F=f(H,Eligible,_,_,_,_,_,_,_,_),memberchk(L,Eligible),\+selected(Old,H),P=[F-L|Old],score(N,P,S),Key is -S),Rows),
    sort(Rows,Sorted),take_beam(24,Sorted,Top),Top\=[],beam(Ls,N,Features,Top,Out).
take_beam(0,_,[]) :- !.
take_beam(_,[],[]) :- !.
take_beam(N,[X|Xs],[X|Ys]) :- M is N-1,take_beam(M,Xs,Ys).
result(N,Locked,Features,Key-P) :-
    lanes(All),subset_lanes(N,All,Ls),locked_assignment(Locked,Ls,Features,Initial),
    findall(L,(member(L,Ls),\+member(_-L,Initial)),Open),
    beam(Open,N,Features,[0-Initial],Final),member(_-P,Final),score(N,P,S),Key is -S.
pick(Enemies,All,F-L,_{id:H,lane:L,counters:Cs,synergy:Syn}) :-
    F=f(H,_,_,_,_,_,_,_,_,_),findall(E,(member(E,Enemies),match(H,E,V),V>0),Cs),
    findall(J,(member(G-_,All),G=f(J,_,_,_,_,_,_,_,_,_),J\=H,known(H,J)),Syn).
recommend_draft(N,Preferred,Locked,Enemies,Dict) :-
    weights(N,_,_,_,_,_,_),valid(Locked),valid(Enemies),length(Locked,K),K=<N,length(Enemies,EN),EN>=1,EN=<5,
    \+ (member(H,Locked),memberchk(H,Enemies)),lanes(All), (Preferred==all;memberchk(Preferred,All)),
    findall(H,hero(H),Hs0),sort(Hs0,Hs),exclude(in_list(Enemies),Hs,Available),maplist(feature(Enemies),Available,Features),
    findall(Key-P,(result(N,Locked,Features,Key-P),(Preferred==all;member(_-Preferred,P))),Rows),
    keysort(Rows,[Key-Best|_]),maplist(pick(Enemies,Best),Best,Picks),S is round(-Key*10)/10,
    Dict=_{size:N,score:S,picks:Picks}.
in_list(L,H) :- memberchk(H,L).
