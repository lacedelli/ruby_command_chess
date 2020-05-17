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

## Thoughts after being done

Well, here we are, I "finished" this project.
It's an ok thing, but after working all the time I did on it, I think I am a
little biased on its favor; I think it's still pretty barebones, and there's 
some things that I think I should have done differently, but after a certain
point in time, I had to stick to my guns and carry on with the choices I made
when it came to the design principles of the game.

Specially right after the restructure I had to make during the middle of the project. 

### What I would have done differently

When I decided how to implement the player input I chose to use the long
algebraic system to make it easier on me at the beginning, but it turned out
that using a longer system has more opportunities for the use to break the
program, and; oh boy, is this program prone to breaking.

The internal workings of the game are definitely over-engineered, of that I'm 
sure, but I did what I could with what I had, and, I think that it is a
sufficiently good system.

It would be great to make an extension that could read game files off the
internet and recreate them, but that's somewhat more advanced than what I 
think I can achieve; but, then again, also was this entire project.

17 / May / 2020
