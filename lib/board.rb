require_relative "cell.rb"

class Board
	attr_reader :grid

	def initialize()
		@grid = []
		hor_range = ("a".."h")
		counter = 0
		hor_range.each do |col|
			@grid << []
			8.times do |row|
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
		long_notation = /^([KQBNR]|[kqbnr])?([a-h][1-8])(-|x|X)([a-h][1-8])/
		match = long_notation.match(instruction)
		piece_str = match[1]
		if piece_str.nil?()
			# Move affects pawn
			puts "entered pawn clause"
		else
			# find starting coordinates
			origin = get_cell(match[2])
			if origin.nil?()
				puts "couldn't find origin coordinates, remember they range from a1 to h8"
				return nil
			end
		# Find operand
			operand = match[3]
			if operand.nil?()
				puts "Couldn't recognize the operand, remember to use '-' or 'x'"
				return nil 
			end
		# find ending coordinates
			destination = get_cell(match[4])
			if destination.nil?()
				puts "couldn't find destination coordinates, remember they range from a1 to h8"
				return nil
			end
		# confirm that a piece exists in selected space
			unless origin.has_piece?
				piece = origin.piece()
				if operand == "-"
					unless destination.has_piece?()
						if check_piece?(piece, piece_str)
							if piece.move.include?(destination.split(""))
								move_piece(origin, destination)
							else
								puts "The #{piece.name} at #{origin.coord.join} cannot move to #{destination.coord.join}"
								return nil
							end
						else
							puts "The piece at #{origin.coord.join()} is not the a #{piece_str}"
							return nil
						end
					else
						puts "The space at #{origin.coord.join} doesn't have a piece on it"
						return nil
					end
				elsif operand == "x" || operand == "X"
					# TODO Check that there's a piece of 
					# different color on destination
					unless origin.piece.same_color?(destination.piece)
					# check that destination is in piece's 
					# threatened spaces	
						if origin.piece.threat_spaces.include?(destination)
							capture_piece(origin, destination)
						else
							# TODO tell player nature of error
							return nil
						end
					else
						# TODO tell player nature of error
						return nil
					end
				end

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

	def add_piece(piece, coord)
		create_piece(piece, coord)
	end

	private
	attr_writer :grid

	def create_piece(piece, coord)
		cell = get_cell(coord)
		cell.set_piece(piece)
		# TODO Set the future moves for each piece
	end

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
		coord = coordinates.split("")
		columns = ("a".."h")
		counter = 0
		columns.each do |col|
			if col == coord[0]
				8.times do |row|
					if row + 1 == coord[1].to_i
						return @grid[counter][row]
					end
				end
			end
			counter += 1
		end
		nil
	end

	def check_piece?(piece, p_input)
		# TODO Check if the specified piece 
		# is the type the player asserts it to be
		case piece
		when instance_of?(Queen)
			if p_input.upcase() == "Q"
				return true
			end
		when instance_of?(King)
			if p_input.upcase() == "K"
				return true
			end
		when instance_of?(Bishop)
			if p_input.upcase() == "B"
				return true
			end
		when instance_of?(Rook)
			if p_input.upcase() == "R"
				return true
			end
		when instance_of?(Knight)
			if p_input.upcase() == "N"
				return true
			end
		end
	end
end
