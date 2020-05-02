# Ruby chess

## Thoughts before dropping in

Well, this is it, huh? The dreaded moment of truth has arrived, I now have
to figure out a way to make a fully functioning chess game in ruby,
I think it won't really be that much of a "problem solving intensive" program
but there is a lot of work to be done.

In all honesty, I think that the connect four program has a good bunch of 
principles that I can pull from in order to make things work, adding a
cell class that holds a reference to its "coordinate" and a reference
to the piece that is located on it. Maybe going so far as to adding a
method #valid_move? to it that takes a coordinate and lets the player know
if a move they have chosen is illegal.

The only things that I think I'm gonna leave out are moves like en passant
or rooking.

See you in a month, I guess!

01 / May / 2020
