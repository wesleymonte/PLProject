:- module('Display', [
    showTitle/0,
    drawIndividual_/3,
    drawIndividual/3,
    cls/0,
    ln/0
]).

:- use_module('Util').
:- use_module('GA').

cls :- write('\e[H\e[2J').
ln :- writeln("").

drawAsterisk(Y, [L|Line], [L|NewLine]) :- K is Y - 1, drawAsterisk(K, Line, NewLine).
drawAsterisk(0, [_|L], ["*"|L]).

drawPoint((0, Y), [L|Maze]) :- drawAsterisk(Y, L, NewL), writeln(NewL), showList(Maze).
drawPoint((X, Y), [L|Maze]) :- K is X - 1, writeln(L), drawPoint((K, Y), Maze).

drawIndividual_(_,_,[]).
drawIndividual_(Maze, S, [M|Moves]) :-
    makeAMove(S, M, Result),
    (isValidMove(Result), cls, drawPoint(Result, Maze), sleep(0.5), drawIndividual_(Maze, Result, Moves));
    (cls, drawPoint(S, Maze), sleep(0.5), drawIndividual_(Maze, S, Moves)).

drawIndividual(Maze, Spawn, individual(_,_,Moves)) :- drawIndividual_(Maze, Spawn, Moves).

showTitle():- cls, writeln("#####################################################################################################################"),
sleep(0.3),
writeln(".___  ___.      ___      ________   _______         _______.  ______    __      ____    ____  _______ .______      "),
sleep(0.3),
writeln("|   \\/   |     /   \\    |       /  |   ____|       /       | /  __  \\  |  |     \\   \\  /   / |   ____||   _  \\     "),
sleep(0.3),
writeln("|  \\  /  |    /  ^  \\   `---/  /   |  |__         |   (----`|  |  |  | |  |      \\   \\/   /  |  |__   |  |_)  |    "),
sleep(0.3),
writeln("|  |\\/|  |   /  /_\\  \\     /  /    |   __|         \\   \\    |  |  |  | |  |       \\      /   |   __|  |      /     "),
sleep(0.3),
writeln("|  |  |  |  /  _____  \\   /  /----.|  |____    .----)   |   |  `--'  | |  `----.   \\    /    |  |____ |  |\\ \\----."),
sleep(0.3),
writeln("|__|  |__| /__/     \\__\\ /________||_______|   |_______/     \\______/  |_______|    \\__/     |_______|| _| `._____|"),
sleep(0.3),
writeln("\n#####################################################################################################################\n"),
sleep(0.5),
writeln("                                                                                             FINAL EDITION ™"),
sleep(1),
writeln("O SOLUCIONADOR MAIS EFICIENTE DO MERCADO PROPORCIONADO PELO GRUPO:\n"),
sleep(2),
writeln("Wesley: o CYKA BLYAT da recursão"),
sleep(1),
writeln("Eduardo: o MUTANTE com chicungunha"),
sleep(1),
writeln("João Marcos: o GERADOR de caminhos"),
sleep(1),
writeln("Henrique: o FINISHER burocrático"),
sleep(1),
writeln("Flavio: o DEBUGGER quântico").