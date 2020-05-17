require_relative 'lib/board.rb'

class Game

	def self.play()
		# TODO make an if savefile thingy
		board = Board.new()
		p "Welcome to chess!"
		switch = 0
		color = "white"
		p "It's #{color}'s turn."
		loop do
			puts board.render_board()
			p "This game uses long algebraic notation."
			p "I.E. Bc1-f4 will move the bishop in c1 to f4."
			move = gets.chomp()
			if move.downcase() == "save"
				# TODO make a save thingy
			end
			if board.make_move(move, color)
				puts board.render_board()
				if board.checkmate?()
					break
				end
				switch += 1
				if switch % 2 == 0
					color = "white"
				else
					color = "black"
				end
				p "It's #{color}'s turn."
			else
				next
			end
		end
		p "Game ended! #{color} won!"
	end
end

Game.play()
