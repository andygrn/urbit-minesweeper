
# Urbit minesweeper

Very basic proof of concept, only playable through dojo.

## Installation

- `|merge %minesweeper our %webterm`
- `|mount %minesweeper`
- Copy these files into the mounted desk.
- `|commit %minesweeper`
- `|install our %minesweeper`

## Example game

Set up 10 x 10 board with 10 mines.

`:minesweeper &minesweeper-action [%reset w=10 h=10 mines=10]`  
`:minesweeper &minesweeper-action [%display ~]`

```
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
". . . . . . . . . . "
```

Dig at 3,3 (positions are zero-indexed).

`:minesweeper &minesweeper-action [%dig x=3 y=3]`  
`:minesweeper &minesweeper-action [%display ~]`

```
"0 0 0 0 0 0 1 . . . "
"0 0 0 0 1 2 3 . . . "
"1 1 0 0 1 . . . . . "
". 2 1 0 1 2 3 . . . "
". . 1 0 0 0 1 2 2 1 "
". . 2 1 0 0 0 0 0 0 "
". . . 2 1 0 0 0 0 0 "
". . . . 1 0 0 0 0 0 "
". 1 1 1 1 0 0 0 0 0 "
". 1 0 0 0 0 0 0 0 0 "
```

Flag at 5,2.

`:minesweeper &minesweeper-action [%flag x=5 y=2]`  
`:minesweeper &minesweeper-action [%display ~]`


```
"0 0 0 0 0 0 1 . . . "
"0 0 0 0 1 2 3 . . . "
"1 1 0 0 1 F . . . . "
". 2 1 0 1 2 3 . . . "
". . 1 0 0 0 1 2 2 1 "
". . 2 1 0 0 0 0 0 0 "
". . . 2 1 0 0 0 0 0 "
". . . . 1 0 0 0 0 0 "
". 1 1 1 1 0 0 0 0 0 "
". 1 0 0 0 0 0 0 0 0 "
```

Dig at 3,7.

`:minesweeper &minesweeper-action [%dig x=3 y=7]`  
`:minesweeper &minesweeper-action [%display ~]`

```
'game over'
```
