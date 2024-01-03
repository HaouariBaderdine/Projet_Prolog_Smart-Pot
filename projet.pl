% Faits pour representer les caracteristiques des plantes
caracteristique(plante1, [faible, succulente, petite, petite, verte, fine, croissance_active, temperature_elevee, pot_terre_cuite, avec_trou_drainage, sol_drainant, [feuilles_epaisses_charnues]]).
caracteristique(plante2, [moyen, fougere, moyenne, moyenne, jaune, fragile, croissance_active, temperature_basse, pot_plastique, sans_trou_drainage, sol_non_drainant, []]).

% Regles pour determiner la frequence d arrosage
regle_arrosage(succulente, frequence_faible).
regle_arrosage(grande, frequence_elevee).
regle_arrosage(croissance_active, frequence_elevee).
regle_arrosage(temperature_elevee, frequence_elevee).
regle_arrosage(humidite_faible, frequence_elevee).
regle_arrosage(ensoleillement_direct, frequence_elevee).
regle_arrosage(ensoleillement_indirect, frequence_faible).
regle_arrosage(pot_terre_cuite, frequence_elevee).
regle_arrosage(avec_trou_drainage, frequence_faible).
regle_arrosage(sol_drainant, frequence_faible).
regle_arrosage(feuilles_epaisses_charnues, frequence_faible).

% Algorithme mixte de resolution
resoudre(PPB, _, _) :-
    length(PPB, 0), % Si PPB est vide, renvoyer succes
    write('Succes'), nl.

resoudre(PPB, BFE, PLAN) :-
    indic_un_cycle(PPB, LESR, INDIC),
    indic_un_cycle_handler(INDIC, PPB, BFE, PLAN, LESR).

% Predicat pour gerer les differents cas d INDIC
indic_un_cycle_handler('echec', _, _, _, _) :-
    write('echec'), nl, fail.

indic_un_cycle_handler('primitif', PPB, BFE, PLAN, _) :-
    remove_head(PPB, Pb),
    append(PLAN, [Pb], NewPlan),
    % Effectuer les ajouts et retraits sur BFE comme decrit dans TAT pour ce Pb
    write('Primitif trouve: '), write(Pb), nl,
    write('Nouveau plan: '), write(NewPlan), nl,
    resoudre(PPB, BFE, NewPlan).

indic_un_cycle_handler(_, PPB, BFE, PLAN, LESR) :-
    une_cycle(PPB, BFE, PLAN, LESR).

% Predicat pour gerer le cas où UNE-R est declenchable
une_cycle(PPB, BFE, PLAN, LESR) :-
    nth0(0, LESR, UNE_R),
    regle_declenchable(UNE_R, PPB, BFE),
    apply_rule(UNE_R, PPB, NewPPB),
    append(PLAN, [UNE_R], NewPlan),
    resoudre(NewPPB, BFE, NewPlan).

% Predicat pour appliquer les changements dus à une regle
apply_rule(UNE_R, PPB, NewPPB) :-
    nth0(1, UNE_R, Corps),
    subtract(PPB, Corps, NewPPB).

% Predicat pour verifier si une regle est declenchable
regle_declenchable(UNE_R, PPB, _BFE) :-
    % Logique pour verifier si la regle est declenchable
    write('Regle declenchable: '), write(UNE_R), nl,
    member(Caracteristique, UNE_R),
    member(Caracteristique, PPB),
    write('Caracteristiques declenchees: '), write(UNE_R), nl.


% Predicat pour supprimer la tête d une liste
remove_head([_|T], T).

% Predicat indic_un_cycle/3
indic_un_cycle(PPB, LESR, INDIC) :-
    % Logique pour determiner INDIC et LESR
    (regle_declenchable(UNE_R, PPB, BFE) ->
        INDIC = 'declenchable',
        write('Regle declenchable trouvee: '), write(UNE_R), nl
    ;   INDIC = 'echec',
        write('Aucune regle declenchable trouvee.'), nl
    ).

% Exemple d utilisation
exemple_utilisation :-
    PPB = [faible, succulente, petite],
    BFE = [], % Remplacez par vos faits initiaux
    PLAN = [],
    resoudre(PPB, BFE, PLAN).
