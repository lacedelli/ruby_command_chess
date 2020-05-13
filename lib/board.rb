require_relative "cell.rb"
require_relative "pieces.rb"

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
				unless cell.has_piece?()
					next
				else
					piece = cell.piece()
					piece_moves = piece.get_moves(cell.coord)
					piece_threats = piece.get_threats(cell.coord)
					moves_arr = get_move_spaces(piece_moves)
					threats_arr = get_threat_spaces(piece_threats, piece.color)
					piece.update_moves(moves_arr, threats_arr)
				end
			end
		end
	end

	def render_board()
		# TODO increase the font size of the console
		font_color = "\033[30m"
		bg_magenta = "\033[45m"
		bg_white = "\033[47m"
		no_formatting = "\033[0m"
		printable_string = ""
		pattern = 0
		(0..7).reverse_each do |row|
			(0..7).each do |column|
				printable_string << font_color
				unless @grid[column][row].has_piece?
					if pattern % 2 == 0
						printable_string << bg_white << " "
					else
						printable_string << bg_magenta << " "
					end
				else
					if pattern % 2 == 0
						printable_string << bg_white << @grid[column][row].piece.symbol
					else
						printable_string << bg_magenta << @grid[column][row].piece.symbol
					end
				end
					pattern += 1
			end
			pattern += 1
			printable_string << no_formatting << "\n"
		end
		printable_string << no_formatting
	end

	def make_move(instruction)
		# Parse the instruction 
		long_notation = /^([KQBNR]|[kqbnr])?([a-h][1-8])(-|x|X)([a-h][1-8])/
		match = long_notation.match(instruction)
		piece_str = match[1]

		if piece_str.nil?()
			# TODO Move affects pawn
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
							puts "#{destination.coord.join()} isn't a threatened space by the selected piece."
							return nil
						end
					else
						puts "The piece at #{destination.coord.join} isn't a piece of the oppossite color."
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

	def set_pieces()
		# Create white pieces
		color = "white"
		create_piece(Rook.new(color), "a1")
		create_piece(Rook.new(color), "h1")
		create_piece(Knight.new(color), "b1")
		create_piece(Knight.new(color), "g1")
		create_piece(Bishop.new(color), "c1")
		create_piece(Bishop.new(color), "f1")
		create_piece(Queen.new(color), "d1")
		create_piece(King.new(color), "e1")
		("a".."h").each do |letter|
			create_piece(Pawn.new(color), "#{letter}2")
		end
		# Create black pieces
		color = "black"
		create_piece(Rook.new(color), "a8")
		create_piece(Rook.new(color), "h8")
		create_piece(Knight.new(color), "b8")
		create_piece(Knight.new(color), "g8")
		create_piece(Bishop.new(color), "c8")
		create_piece(Bishop.new(color), "f8")
		create_piece(Queen.new(color), "d8")
		create_piece(King.new(color), "e8")
		("a".."h").each do |letter|
			create_piece(Pawn.new(color), "#{letter}7")
		end

	end

	private
	attr_writer :grid

	def create_piece(piece, coord)
		cell = get_cell(coord)
		cell.set_piece(piece)
		# Set the future moves for each piece
		piece_moves = piece.get_moves(cell.coord)
		piece_threats = piece.get_threats(cell.coord)
		moves_arr = get_move_spaces(piece_moves)
		threats_arr = get_threat_spaces(piece_threats, piece.color)
		piece.update_moves(moves_arr, threats_arr)
	end

	def get_move_spaces(piece_moves)
		moves_arr = []
		p piece_moves
		piece_moves.map do |k, v|
			v.each do |coordinates|
				c = get_cell(coordinates)
				if c.piece.nil?
					moves_arr << coordinates
				else
					break
				end
			end
		end
		moves_arr
	end

	def get_threat_spaces(piece_threats, color)
		# TODO Change this to work functionally on the same principle
		# that get moves does, but with the threats hash of the piece
		# because if we only account for the threatened spaces in which
		# there ARE pieces currently dealing with checks is gonna be impossible
		threats_arr = []
		piece_threats.map do |k, v|
			v.each do |coordinates|
				c = get_cell(coordinates)
				if c.piece.nil?
					next
				else
					unless c.piece.color == color
						threats_arr << coordinates
						break
					end
				end
			end
		end
		threats_arr
	end

	def cycle_moves(array)
		cells = []
		array.each do |coord|
			cell = get_cell(coord)
			unless cell.piece.nil?
				cells << cell
			end
		end
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
		if coordinates.is_a?(String)
			coord = coordinates.split("")
		elsif coordinates.is_a?(Array)
			coord = coordinates
		end
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
		# Check if the specified piece 
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


b = Board.new()
b.set_pieces()
puts b.render_board()
