require 'json'
require_relative 'lib/board.rb'

class Game

	def self.play()
		file = 'save.txt'
		if File.exist?(file)
			data = File.open(file, 'r')
			json = data.read
			p json
			board = Board.from_json(json)
			data.close()
		else
			board = Board.new()
		end
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
				data = board.to_json
				savefile = File.open(file, 'w')
				savefile.write(data)
				savefile.close
				p "Game saved!"
				exit
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
