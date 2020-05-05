require_relative "cell.rb"

class Board
	attr_reader :grid

	def initialize()
		@grid = []
		hor_range = ("a".."h")
		counter = 0
		hor_range.each do |col|
			@grid << []
			p col
			8.times do |row|
				p row + 1
				@grid[counter] << Cell.new([col, row + 1])
			end
			counter += 1
		end
	end

	def update_board()
		@grid.each do |column|
			column.map do |cell|
				unless cell.contains_piece?()
					next
				else
					# TODO update the move & threat values
					# of cell.piece.move && cell.piece.threat
				end
			end
		end
	end

	def make_move(instruction)
		# TODO parse the instruction 
		# first letter should be upper case
		# if not, move affects a pawn
		# 
		# find starting coordinates
		# find dash separator
		# check for "x" regarding piece capturing
		# find ending coordinates
		#
		# confirm that a piece exists in selected space
		# confirm that piece is the type specified
		# confirm that the movement the player asked is valid
		# if x was found instead of dash, check for capture
		# execute move if all conditions are true
		#
		# if move is not parseable
		# or if move is not actionable, ask player to input again
	end

	private
	attr_writer :grid

	def move_piece(origin, destination)
		# TODO use a variable to hold origin.piece
		# set origin.piece to nil
		# get cell on destination coordinates
		# set destination.piece to piece
	end

	def capture_piece(origin, destination)
		# TODO move destination.piece to a captured array
		# call move_piece(origin, destination)
	end

end
