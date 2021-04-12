%%%%%%%%%%%%%%%%%%%%%%%%%%
% tree.pl
% https://gfx.cse.taylor.edu/courses/cos382/assignments/04_ParadigmLogic_Prolog
% The goal of this assignment is to write a collection of Prolog rules
% to represent and manipulate binary trees.
%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starter code

% tree(Tree)
% "Tree" is a binary tree.

tree(void).
tree(tree(_,Left,Right)) :-  tree(Left),
                             tree(Right).


% tree_member(Element,Tree)
% "Element" is an element of the binary tree "Tree".

tree_member(X,tree(X,_,_)).
tree_member(X,tree(_,Left,_)) :- tree_member(X,Left).
tree_member(X,tree(_,_,Right)) :- tree_member(X,Right).



% preorder(Tree,Pre)
% "Pre" is a list of elements of "Tree" accumulated during a
% preorder traversal.

preorder(tree(X,L,R),Xs) :- preorder(L,Ls), preorder(R,Rs),
                            append([X|Ls],Rs,Xs).
preorder(void,[]).



% append(Xs,Ys,XsYs)
% "XsYs" is the result of appending the lists "Xs" and "Ys".

append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).


% Some sample trees
%
%    tree1       tree2         tree3
%
%      1           4             1
%     / \         / \           / \
%    2   3       5   6         2   3
%                             / \
%                            5   6
%                               /
%                              7
%

tree1(tree(1,tree(2,void,void),tree(3,void,void))).
tree2(tree(4,tree(5,void,void),tree(6,void,void))).
tree3(
        tree(   1,
                tree(   2,
                        tree(5,void,void),
                        tree(   6,
                                tree(7,void,void),
                                void
                        )
                ),
                tree(3,void,void)
        )
).



%%%%%%%%%%%%%%%%%%%%%%%%%%
% Place your code here


% Additional test data

%      tree4
%
%         1
%        / \
%       /   \
%      2     3
%     / \   / \
%    5   6 0   2
%       /
%      7
tree4(
        tree(1,
                tree(2,
                        tree(5, void, void),
                        tree(6,
                                tree(7, void, void),
                                void
                        )
                ),
                tree(3,
                        tree(0, void, void),
                        tree(2, void, void)
                )
        )
).

%      tree5
%
%        6
%       /
%      7
tree5(
        tree(6,
                tree(7, void, void),
                void
        )
).

%      tree6
%
%         5
%        / \
%       /   \
%      2     8
%     / \   / \
%    1   4 7   9
%       /
%      3
tree6(
        tree(5,
                tree(2,
                        tree(1, void, void),
                        tree(4,
                                tree(3, void, void),
                                void
                        )
                ),
                tree(8,
                        tree(7, void, void),
                        tree(9, void, void)
                )
        )
).


% inorder

inorder(void, []).
inorder(tree(S, L, R), Xs) :-
        inorder(L, Ls),
        inorder(R, Rs),
        append(Ls, [S|Rs], Xs).

% search

search(tree(X, _, _), X).
search(tree(_, L, _), X) :- search(L, X).
search(tree(_, _, R), X) :- search(R, X).

% subtree

subtree(S, S).
subtree(S, tree(_, L, _)) :-
        subtree(S, L).
subtree(S, tree(_, _, R)) :-
        subtree(S, R).

% sumtree

sumtree(void, 0).
sumtree(tree(Int, L, R), Sum) :-
        sumtree(L, Sl),
        sumtree(R, Sr),
        Sum is Int + Sl + Sr.

% ordered

greater(_, void).
greater(X, tree(Y, L, R)) :-
        X > Y,
        greater(X, L),
        greater(X, R).
smaller(_, void).
smaller(X, tree(Y, L, R)) :-
        X < Y,
        smaller(X, L),
        smaller(X, R).

ordered(void).
ordered(tree(X, L, R)) :-
        ordered(L),
        greater(X, L),
        ordered(R),
        smaller(X, R).

% substitute

substitute(_, _, void, void).
substitute(X, Y, tree(X, Xl, Xr), tree(Y, Yl, Yr)) :-
        substitute(X, Y, Xl, Yl),
        substitute(X, Y, Xr, Yr).
substitute(X, Y, tree(Z, Xl, Xr), tree(Z, Yl, Yr)) :-
        substitute(X, Y, Xl, Yl),
        substitute(X, Y, Xr, Yr).

% binsearch

binsearch(tree(Key, _, _), Key) :- 
        log("Found!").
binsearch(tree(X, L, _), Key) :- 
        Key < X, 
        log("Searching left of ", X), 
        binsearch(L, Key).
binsearch(tree(X, _, R), Key) :- 
        Key > X, 
        log("Searching right of ", X), 
        binsearch(R, Key).

log(X) :- write("Log: "), write(X), nl.
log(X, Y) :- write("Log: "), write(X), write(Y), nl.

% prettyprint

prettyprint(T) :- prettyprint(T, 0).

prettyprint(void, Indent) :-
        indent(Indent),
        write("X"), % use X to represent void
        nl.
        
prettyprint(tree(X, L, R), Indent) :-
        ChildIndent is Indent + 1,
        prettyprint(L, ChildIndent),
        indent(Indent),
        write(X),
        nl,
        prettyprint(R, ChildIndent).
        
indent(0).
indent(N) :-
        N > 0,
        write("    "),
        N1 is N - 1,
        indent(N1).
