% ============================================================================
% server.pl - HTTP/JSON backend for the ML Assistant web front-end
% Usage:  ?- consult('server.pl').   (starts automatically on port 8080)
%         then open http://localhost:8080/
% ============================================================================
:- module(ml_server, [start_server/0, start_server/1, stop_server/0]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(www_browser)).
:- use_module(library(filesex)).
:- use_module(library(readutil)).

:- use_module(api).
:- use_module(winrates, [winrates_json/1, predict_json/3]).

:- dynamic app_dir/1, server_port/1.
:- prolog_load_context(directory, D), assertz(app_dir(D)).

:- http_handler(root(.),          serve_index, []).
:- http_handler(root(api/heroes), api_heroes,  []).
:- http_handler(root(api/hero),   api_hero,    []).
:- http_handler(root(api/team),   api_team,    []).
:- http_handler(root(api/build),  api_build,   []).
:- http_handler(root(api/draft),  api_draft,   []).
:- http_handler(root(api/meta),   api_meta,    []).
:- http_handler(root(api/items),  api_items,   []).
:- http_handler(root(api/winrates), api_winrates, []).
:- http_handler(root(api/predict),  api_predict,  []).
:- http_handler(root(img),        serve_img,   [prefix]).

% ---------------------------------------------------------------- server ---
start_server :- start_server(8080).

start_server(Port) :-
    catch(http_stop_server(Port, []), _, true),
    http_server(http_dispatch, [port(Port)]),
    retractall(server_port(_)), assertz(server_port(Port)),
    format('~n  ML Assistant web UI running at http://localhost:~w/~n', [Port]),
    format('  Stop it with: ?- stop_server.~n~n'),
    catch(www_open_url('http://localhost:8080/'), _, true).

stop_server :-
    server_port(P), http_stop_server(P, []), retractall(server_port(_)).

:- initialization(start_server).

serve_index(_Request) :-
    app_dir(D),
    directory_file_path(D, '../frontend/index.html', F),
    read_file_to_string(F, Html, [encoding(utf8)]),
    format('Content-Type: text/html; charset=UTF-8~n~n'),
    write(Html).

bad(Msg) :- reply_json_dict(_{error: Msg}, [status(400)]).

% ------------------------------------------------------------ handlers ----
api_heroes(_) :-
    heroes_json(Ds), reply_json_dict(Ds).

api_hero(Request) :-
    http_parameters(Request, [id(H, [atom])]),
    (   hero_json(H, D) -> reply_json_dict(D) ; bad("Unknown hero") ).

api_team(Request) :-
    http_parameters(Request, [enemies(S, [atom])]),
    parse_ids(S, T),
    (   team_json(T, D) -> reply_json_dict(D) ; bad("Pick 1 to 5 valid heroes") ).

api_build(Request) :-
    http_parameters(Request, [hero(H, [atom]), enemies(S, [atom])]),
    parse_ids(S, T),
    (   build_json(H, T, D) -> reply_json_dict(D)
    ;   bad("Pick your hero and 1 to 5 valid enemy heroes") ).

api_draft(Request) :-
    http_parameters(Request, [mine(M, [atom, default('')]),
                              enemies(E, [atom, default('')])]),
    parse_ids(M, Mine), parse_ids(E, En),
    (   draft_json(Mine, En, D) -> reply_json_dict(D) ; bad("Invalid heroes") ).

api_meta(_) :-
    meta_json(D), reply_json_dict(D).

api_items(_) :-
    items_json(Ds), reply_json_dict(Ds).

%% GET /api/winrates  -> all hero stats (+ meta, league average)
api_winrates(_) :-
    winrates_json(D), reply_json_dict(D).

%% GET /api/predict?mine=a,b,c&enemies=d,e  -> predicted win chance of `mine`
api_predict(Request) :-
    http_parameters(Request, [mine(M, [atom, default('')]),
                              enemies(E, [atom, default('')])]),
    parse_ids(M, Mine), parse_ids(E, En),
    (   predict_json(Mine, En, D) -> reply_json_dict(D)
    ;   bad("Pick 1 to 5 valid heroes for your team") ).

%% Local images: src/frontend/img/{hero,thumb,item}/<id>.(png|jpg)
serve_img(Request) :-
    memberchk(path_info(P0), Request),
    split_string(P0, "/", "", Parts0), exclude(==(""), Parts0, Parts),
    Parts = [Kind, File],
    memberchk(Kind, ["hero", "thumb", "item"]),
    \+ sub_string(File, _, _, _, ".."),
    app_dir(D),
    format(atom(F), '~w/../frontend/img/~w/~w', [D, Kind, File]),
    exists_file(F), !,
    file_name_extension(_, Ext, F), img_mime(Ext, Mime),
    format('Content-Type: ~w~n', [Mime]),
    format('Cache-Control: max-age=86400~n~n'),
    catch(set_stream(current_output, encoding(octet)), _, true),
    setup_call_cleanup(open(F, read, In, [type(binary)]),
                       copy_stream_data(In, current_output),
                       close(In)).
serve_img(Request) :-
    memberchk(path_info(P), Request),
    throw(http_reply(not_found(P))).

img_mime(png,  'image/png').
img_mime(jpg,  'image/jpeg').
img_mime(jpeg, 'image/jpeg').
img_mime(webp, 'image/webp').
