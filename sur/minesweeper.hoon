|%
+$  cell-type
  $%  %empty
      %mined
  ==
+$  board-condition
  $%  %alive
      %dead
      %won
  ==
+$  cell  [type=cell-type x=@ y=@ hidden=? flagged=? mined-neighbours=@]
+$  board  [width=@ height=@ cells=(list cell) condition=board-condition]
+$  action
  $%  [%reset w=@ h=@ mines=@]
      [%dig x=@ y=@]
      [%flag x=@ y=@]
      [%display ~]
      [%display-dbug ~]
  ==
::+$  update
::  $%  [%add =id =name]
::      [%del =id]
::      [%toggle =id]
::      [%rename =id =name]
::      [%initial =tasks]
::  ==
--
