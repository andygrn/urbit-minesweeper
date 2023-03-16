/-  minesweeper
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =board:minesweeper]
+$  card  card:agent:gall
--
::
=>  |%
  ++  make-cell
    |=  [y=@ x=@]
    ^-  cell:minesweeper
    :*
      type=%empty
      y=y
      x=x
      hidden=%.y
      flagged=%.n
      mined-neighbours=0
    ==
  ++  make-board
    |=  [width=@ height=@ minecount=@ eny=@uvJ]
    ^-  board:minesweeper
    =>
      =>
        :: generate blank board...
        =/  board  *board:minesweeper
        =.  board  board(width width, height height, condition %alive)
        =/  cellcount  (mul width height)
        =?  minecount  (gth minecount cellcount)  cellcount :: max mines = total cells
        =/  i  0
        |-
        ?:  =(cellcount (lent cells.board))
          .
        %=  $
          i  +(i)
          cells.board  (snoc cells.board (make-cell (mod i width) (div i height)))
        ==
      :: add mines randomly...
      =/  rng  ~(. og eny)
      |-
      ?:  =(minecount 0)
        .
      =^  rand  rng  (rads:rng (lent cells.board))
      =/  cell  (snag rand cells.board)
      ?:  ?=(%mined type.cell)
        $
      %=  $
        minecount  (dec minecount)
        cells.board  (snap cells.board rand `cell:minesweeper`cell(type %mined))
      ==
    :: then count them up
    %=  board
      cells
      %+  turn
        cells.board
      |=  =cell:minesweeper
      cell(mined-neighbours (get-neighbour-mine-count board y.cell x.cell))
    ==
  ++  get-cell-index
    |=  [=board:minesweeper y=@ x=@]
    ^-  @
    (add x (mul y height.board))
  ++  get-cell
    |=  [=board:minesweeper y=@ x=@]
    ^-  (unit cell:minesweeper)
    ?:  |((lth y 0) (gth y (sub height.board 1)))
      ~
    ?:  |((lth x 0) (gth x (sub width.board 1)))
      ~
    [~ (snag (get-cell-index board y x) cells.board)]
  ++  get-neighbour-cells
    |=  [=board:minesweeper y=@ x=@]
    ^-  (list cell:minesweeper)
    %-  murn  :_
      |=  a=(unit cell:minesweeper)  a  :: is there a better way to filter a list by empty unit?
    %-  limo
    ::  slightly more complicated than expected because
    ::  subtract-underflow is a thing
    ?:  &(=(x 0) =(y 0))
      :*  (get-cell board 0 1)
          (get-cell board 1 1)
          (get-cell board 1 0)
          ~
      ==
    ?:  =(y 0)
      :*  (get-cell board 1 x)
          (get-cell board 0 (add x 1))
          (get-cell board 1 (add x 1))
          (get-cell board 0 (sub x 1))
          (get-cell board 1 (sub x 1))
          ~
      ==
    ?:  =(x 0)
      :*  (get-cell board y 1)
          (get-cell board (add y 1) 0)
          (get-cell board (add y 1) 1)
          (get-cell board (sub y 1) 0)
          (get-cell board (sub y 1) 1)
          ~
      ==
    :*  (get-cell board y (add x 1))
        (get-cell board (add y 1) (add x 1))
        (get-cell board (add y 1) x)
        (get-cell board (add y 1) (sub x 1))
        (get-cell board y (sub x 1))
        (get-cell board (sub y 1) x)
        (get-cell board (sub y 1) (add x 1))
        (get-cell board (sub y 1) (sub x 1))
        ~
    ==
  ++  get-neighbour-mine-count
    |=  [=board:minesweeper y=@ x=@]
    ^-  @
    %+  roll
      (get-neighbour-cells board y x)
    |=  [=cell:minesweeper acc=@]
    ?:  ?=(%mined type.cell)
      +(acc)
    acc
  ++  get-sparse-neighbour-cells
    :: sparse = zero mined neighbours
    |=  [=board:minesweeper y=@ x=@]
    ^-  (list cell:minesweeper)
    %+  skim
      (get-neighbour-cells board y x)
    |=  =cell:minesweeper
    =(mined-neighbours.cell 0)
  ++  get-flagged-empty-cells :: only used for checking win condition
    |=  =board:minesweeper
    ^-  (list cell:minesweeper)
    %+  skim
      cells.board
    |=  =cell:minesweeper
    &(=(flagged.cell %.y) ?=(%empty type.cell))
  ++  get-hidden-nonflagged-cells :: only used for checking win condition
    |=  =board:minesweeper
    ^-  (list cell:minesweeper)
    %+  skim
      cells.board
    |=  =cell:minesweeper
    &(=(hidden.cell %.y) =(flagged.cell %.n))
  ++  get-empty-nonsparse-neighbour-cells
    |=  [=board:minesweeper y=@ x=@]
    ^-  (list cell:minesweeper)
    %+  skim
      (get-neighbour-cells board y x)
    |=  =cell:minesweeper
    ?&  ?=(%empty type.cell)
      (gth mined-neighbours.cell 0)
    ==
  ++  reveal-empty-nonsparse-neighbour-cells
    |=  [=board:minesweeper cells=(list cell:minesweeper)]
    ^-  board:minesweeper
    |-
    ?:  =((lent cells) 0)
      board
    =/  cell  (rear cells)
    %=  $
      board  (reveal-cells board (get-empty-nonsparse-neighbour-cells board y.cell x.cell))
      cells  (snip cells)
    ==
  ++  reveal-cell
    |=  [=board:minesweeper =cell:minesweeper]
    ^-  board:minesweeper
    %=  board
      cells  (snap cells.board (get-cell-index board y.cell x.cell) `cell:minesweeper`cell(hidden %.n, flagged %.n))
    ==
  ++  reveal-cells
    |=  [=board:minesweeper cells=(list cell:minesweeper)]
    ^-  board:minesweeper
    |-
    ?:  =((lent cells) 0)
      board
    %=  $
      board  (reveal-cell board (rear cells))
      cells  (snip cells)
    ==
  ++  get-flooded-sparse-cells-from-cell
    |=  [=board:minesweeper =cell:minesweeper cells-to-flood=(set cell:minesweeper)]
    ^-  (set cell:minesweeper)
    ?:  (~(has in cells-to-flood) cell)
      cells-to-flood
    =.  cells-to-flood  (~(put in cells-to-flood) cell) :: add the cell we're on
    =/  sparse-neighbours  (get-sparse-neighbour-cells board y.cell x.cell)
    |-
    ?:  =(0 (lent sparse-neighbours))
      cells-to-flood
    %=  $
      cells-to-flood  (~(uni in cells-to-flood) (get-flooded-sparse-cells-from-cell board (rear sparse-neighbours) cells-to-flood))
      sparse-neighbours  (snip sparse-neighbours)
    ==
  ++  flood-reveal-sparse-cells-from-cell
    |=  [=board:minesweeper =cell:minesweeper]
    ^-  board:minesweeper
    =/  cells-to-reveal  ~(tap in (get-flooded-sparse-cells-from-cell board cell *(set cell:minesweeper)))
    (reveal-empty-nonsparse-neighbour-cells (reveal-cells board cells-to-reveal) cells-to-reveal)
  ++  end-game
    |=  [=board:minesweeper =board-condition:minesweeper]
    ^-  board:minesweeper
    ::=.  board  (reveal-cells board cells.board)
    %=  board
      condition  board-condition
    ==
  ++  check-win
    |=  =board:minesweeper
    ?:  ?|
      (gth (lent (get-flagged-empty-cells board)) 0)
      (gth (lent (get-hidden-nonflagged-cells board)) 0)
      ==
      board
    ~&  'you win'
    (end-game board %won)
  ++  game-is-over
    |=  =board:minesweeper
    ^-  ?
    |(?=(%dead condition.board) ?=(%won condition.board))
  ++  dig
    |=  [=board:minesweeper y=@ x=@]
    ^-  board:minesweeper
    ?:  (game-is-over board)
      ~&  'reset board to continue'
      board
    =/  cell  (need (get-cell board y x))
    ?:  ?=(%mined type.cell)
      ~&  'game over'
      (end-game board %dead)
    %-  check-win
    ?:  =(mined-neighbours.cell 0)
      (flood-reveal-sparse-cells-from-cell board cell)
    %=  board
      cells  (snap cells.board (get-cell-index board y x) `cell:minesweeper`cell(hidden %.n))
    ==
  ++  flag
    |=  [=board:minesweeper y=@ x=@]
    ^-  board:minesweeper
    ?:  (game-is-over board)
      ~&  'reset board to continue'
      board
    =/  cell  (need (get-cell board y x))
    %-  check-win
    %=  board
      cells  (snap cells.board (get-cell-index board y x) `cell:minesweeper`cell(flagged !flagged.cell))
    ==
  --
::
=>  |%
  ++  display
    |=  =board:minesweeper
    =/  y  0
    |-
    ?:  =(y height.board)
      board
    =/  x  0
    =/  output  *tape
    |-
    ?:  =(x width.board)
      ~&  output
      ^$(y +(y))
    =/  cell  (need (get-cell board y x))
    =/  char
    :~
      ?:  =(flagged.cell %.y)
        'F'
      ?:  =(hidden.cell %.y)
        '.'
      ?:  ?=(%mined type.cell)
        'X'
      (scot %u mined-neighbours.cell)
      ' '
    ==
    $(x +(x), output (weld output `tape`char))
  ++  display-dbug
    |=  =board:minesweeper
    =/  y  0
    |-
    ?:  =(y height.board)
      board
    =/  x  0
    =/  output  *tape
    |-
    ?:  =(x width.board)
      ~&  output
      ^$(y +(y))
    =/  cell  (need (get-cell board y x))
    =/  char
    :~
      ?:  ?=(%mined type.cell)
        'X'
      (scot %u mined-neighbours.cell)
      ?:  =(flagged.cell %.y)
        'F'
      ?:  =(hidden.cell %.y)
        '.'
      ' '
    ==
    $(x +(x), output (weld output `tape`char))
  --
::
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this      .
    default   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  ~&  >  '%minesweeper initialised successfully'
  `this(state [%0 *board:minesweeper])
++  on-save  !>(state)
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ::~&  >  state
  |^
  ?>  =(src.bowl our.bowl)
  ?+  mark  (on-poke:default mark vase)
      %minesweeper-action
    =^  cards  state
      (handle-poke !<(action:minesweeper vase))
    [cards this]
  ==
  ::
  ++  handle-poke
  |=  =action:minesweeper
  ^-  (quip card _state)
  ?-  -.action
      %reset
    :_  state(board (make-board w.action h.action mines.action eny.bowl))  %~
  ::
      %dig
    :_  state(board (dig board y.action x.action))  %~
  ::
      %flag
    :_  state(board (flag board y.action x.action))  %~
  ::
      %display
    :_  state(board (display board))  %~
  ::
      %display-dbug
    :_  state(board (display-dbug board))  %~
  ==
--
::
++  on-arvo     on-arvo:default
++  on-watch     on-watch:default
++  on-leave     on-leave:default
++  on-peek     on-peek:default
++  on-agent     on-agent:default
++  on-fail     on-fail:default
--
