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
		# Parse the instruction 
		long_notation = /^([KQBNR]|[kqbnr])?([a-h][1-8])(-|x)([a-h][1-8])/
		match = long_notation.match(instruction)
		# first letter should be upper case
		unless match[1].nil?
			# Move affects pawn
		else
			# find starting coordinates
			origin = get_cell(match[2])
			if origin.nil?
				# TODO find a way to tell player nature of error
				# outside of board
				return nil
			end
		# Find operand
			operand = get_cell(match[3])
			if operand.nil?
				# TODO Tell player nature of error 
				return nil 
			end
		# find ending coordinates
			destination = get_cell(match[4])
			if destination.nil?
				# TODO Tell player nature of error
				return nil
			end
		# confirm that a piece exists in selected space
			unless origin.has_piece?
		# confirm that piece is the type specified
		# confirm that the movement the player asked is valid
		# if x was found instead of dash, check for capture
		# execute move if all conditions are true
		#
		# if move is not parseable
		# or if move is not actionable, ask player to input again
			end
		end
	end

	private
	attr_writer :grid

	def move_piece(origin, destination)
		# TODO use a variable to hold origin.piece
		# set origin.piece to nil
		# get cell on destination coordinates
		# set destination.piece to piece
		# if piece == pawn
		# if pawn first_move.true?
		# set first move to false
	end

	def capture_piece(origin, destination)
		# TODO move destination.piece to a captured array
		# call move_piece(origin, destination)
	end

	def get_cell(coordinates)
		# split coordinates into array
		# TODO scan the whole board for the
		# coordinates given, if found, return it
		# otherwise return nil
	end

end
