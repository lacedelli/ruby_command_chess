require 'json'
require_relative "cell.rb"
require_relative "pieces.rb"

class Board
	attr_reader :grid

	def initialize(data = [])

		@white_k = nil
		@black_k = nil
		@white_captured = []
		@black_captured = []
		@white_threats = []
		@black_theats = []
		@check = false
		@threat_cell = nil

		if data.empty?
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
			set_pieces()
		else
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
			data.map do |k,v|
				cell = get_cell(k)
				case v[0]
				when "Pawn"
					cell.set_piece(Pawn.new(v[1]))
				when "Rook"
					cell.set_piece(Rook.new(v[1]))
				when "Knight"
					cell.set_piece(Knight.new(v[1]))
				when "Bishop"
					cell.set_piece(Bishop.new(v[1]))
				when "Queen"
					cell.set_piece(Queen.new(v[1]))
				when "King"
					cell.set_piece(King.new(v[1]))
				end
				update_board()
			end
		end
		nil
	end

	def update_board()
		@white_threats = []
		@black_threats = []

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
					update_threats_arrays(piece, threats_arr)
					piece.update_moves(moves_arr, threats_arr)
				end
			end
		end
		nil
	end

	def render_board()
		font_color = "\033[30m"
		bg_magenta = "\033[45m"
		bg_white = "\033[47m"
		no_formatting = "\033[0m"
		printable_string = ""
		pattern = 0
		(0..7).reverse_each do |row|
			printable_string << " #{row + 1} "
			(0..7).each do |column|
				printable_string << font_color
				unless @grid[column][row].has_piece?
					if pattern % 2 == 0
						printable_string << bg_white << "   "
					else
						printable_string << bg_magenta << "   "
					end
				else
					if pattern % 2 == 0
						printable_string << bg_white << " " << @grid[column][row].piece.symbol << " "
					else
						printable_string << bg_magenta <<  " " << @grid[column][row].piece.symbol << " "
					end
				end
					pattern += 1
			end
			pattern += 1
			printable_string << no_formatting << "\n"
		end
		printable_string << "    a  b  c  d  e  f  g  h " << "\n"
		printable_string << font_color << bg_white << " #{@white_captured.join(" ")}" << no_formatting << "\n"
		printable_string << font_color << bg_white << " #{@black_captured.join(" ")}" << no_formatting << "\n"
		printable_string << no_formatting
		printable_string
	end

	def make_move(instruction, color)

		long_notation = /^([KQBNR]|[kqbnr])?([a-h][1-8])(-|x|X)([a-h][1-8])/
		match = long_notation.match(instruction)
		piece_str = match[1]

		if piece_str.nil?
			piece_str = ""
		end

		# find starting coordinates
		origin = get_cell(match[2])
		if origin.nil?()
			puts "Couldn't find origin coordinates, remember they range from a1 to h8."
			return false
		end

		# Find operand
		operand = match[3]
		if operand.nil?()
			puts "Couldn't recognize the operand, remember to use '-' or 'x'."
			return false 
		end

		# find ending coordinates
		destination = get_cell(match[4])
		if destination.nil?()
			puts "Couldn't find destination coordinates, remember they range from a1 to h8."
			return false
		end

		if origin == destination
			puts "A piece can't move to its current space."
			return false
		end

		if possible_move?(piece_str, color, origin, operand, destination)
			if operand == "-"
				move_piece(origin, destination)
				return true
			else
				capture_piece(origin, destination)
				return true
			end
		else
			return false
		end
	end
	
	def checkmate?()
		no_king_moves = false
		no_capturing_possibility = false
		no_blocking_moves = false
		moves_array = []
		blocked_moves = 0
		total_moves = @white_k.move_spaces.length()
		@white_k.move_spaces.map() do |move|
			if @black_threats.include?(move)
				blocked_moves += 1
			end
			if total_moves == blocked_moves
				no_king_moves = true
			end
		end
		if @checked
			unless @white_threats.include?(@threat_cell.coord())
				no_capturing_possibility = true
			end
			@grid.map do |row|
				row.map do |cell|
					if cell.has_piece?()
						if cell.piece.color == "white"
							cell.piece.moves.map do |coord|
								unless moves_array.include?(coord)
									moves_array << coord
								end
							end
						end
					end
				end
			end
			if moves_array.empty?()
				no_blocking_moves = true
			end
		end

		if no_blocking_moves && no_capturing_possibilities && no_king_moves
			return true
		end

		no_king_moves = false
		no_capturing_possibility = false
		no_blocking_moves = false
		moves_array = []
		blocked_moves = 0
		total_moves = @black_k.move_spaces.length()
		@black_k.move_spaces.map() do |move|
			if @white_threats.include?(move)
				blocked_moves += 1
			end
			if total_moves == blocked_moves
				no_king_moves = true
			end
		end
		if @checked
			unless @black_threats.include?(@threat_cell.coord())
				no_capturing_possibility = true
			end
			@grid.map do |row|
				row.map do |cell|
					if cell.has_piece?()
						if cell.piece.color == "black"
							cell.piece.moves.map do |coord|
								unless moves_array.include?(coord)
									moves_array << coord
								end
							end
						end
					end
				end
			end
			if moves_array.empty?()
				no_blocking_moves = true
			end
		end

		if no_blocking_moves && no_capturing_possibilities && no_king_moves
			return true
		end

		false
	end

	def to_json()
		local_grid = @grid
		piece_hash = {}
		local_grid.map do |row|
			row.map do |cell|
				if cell.has_piece?()
					piece_hash[cell.coord.join()] = [cell.piece.class, cell.piece.color]
				end
			end
		end
		JSON.dump(piece_hash)
	end

	def self.from_json(string)
		data = JSON.load(string)
		self.new(data)
	end

	private
	attr_writer :grid, :white_captured, :black_captured

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
		@white_k = King.new(color)
		create_piece(@white_k, "e1")
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
		@black_k = King.new(color)
		create_piece(@black_k, "e8")
		("a".."h").each do |letter|
			create_piece(Pawn.new(color), "#{letter}7")
		end
		nil
	end

	def create_piece(piece, coord)
		cell = get_cell(coord)
		cell.set_piece(piece)
		# Set the future moves for each piece
		piece_moves = piece.get_moves(cell.coord)
		piece_threats = piece.get_threats(cell.coord)
		moves_arr = get_move_spaces(piece_moves)
		threats_arr = get_threat_spaces(piece_threats, piece.color)
		piece.update_moves(moves_arr, threats_arr)
		nil
	end

	def get_move_spaces(piece_moves)
		moves_arr = []
		piece_moves.map do |k, v|
			v.map do |coordinates|
				c = get_cell(coordinates)
				if c.has_piece?()
					break
				else
					moves_arr << coordinates
				end
			end
		end
		moves_arr
	end

	def get_threat_spaces(piece_threats, color)
		threats_arr = []
		piece_threats.map do |k, v|
			v.each do |coordinates|
				c = get_cell(coordinates)
				unless c.has_piece?()
					threats_arr << coordinates
				else
					unless c.piece.color == color
						threats_arr << coordinates
						break
					else
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
		nil
	end

	def move_piece(origin, destination)
		piece = origin.remove_piece()
		destination.set_piece(piece)
	
		if piece.instance_of?(Pawn)
			if piece.first_move?()
				piece.moved()
			end
		end
		update_board()
		king_check(piece, destination)
	
		nil
	end

	def king_check(piece, destination)
		piece.threat_spaces.each do |space|
			cell = get_cell(space)
			if cell.has_piece?()
				if cell.piece.instance_of?(King)
					@check = true
					@threat_cell = destination
					p "Check by #{piece.class()}."
				end
			end
		end
	end


	def capture_piece(origin, destination)
		captured = destination.remove_piece()
		if captured.color == "white"
			@white_captured << captured.symbol()
		else
			@black_captured << captured.symbol()
		end
		# call move_piece(origin, destination)
		move_piece(origin, destination)
		nil
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

	def update_threats_arrays(piece, threats_arr)
		if piece.color() == "white"
			threats_arr.map do |threat|
				unless @white_threats.include?(threat)
					@white_threats << threat
				end
			end
		else
			threats_arr.map do |threat|
				unless @black_threats.include?(threat)
					@black_threats << threat
				end
			end
		end
	end

	def get_threat_vector()
		threat_vector = []
		threats = @threat_cell.piece.get_threats(@threat_cell.coord)
		threats.each do |k,v|
			threat_arr = []
			v.each do |coord|
				cell = get_cell(coord)
				threat_arr << coord
				if cell.has_piece?()
					if cell.piece.instance_of?(King)
						unless @threat_cell.piece.same_color?(cell.piece())
							threat_vector = threat_arr
						end
					end
				end
			end
		end
		threat_vector
	end


	def correct_piece?(piece, p_input)
		# Check if the specified piece 
		# is the type the player asserts it to be
		piece_class = piece.class().to_s()
		case piece_class
		when "Queen"
			if p_input.upcase() == "Q"
				return true
			end
		when "King"
			if p_input.upcase() == "K"
				return true
			end
		when "Bishop"
			if p_input.upcase() == "B"
				return true
			end
		when "Rook"
			if p_input.upcase() == "R"
				return true
			end
		when "Knight"
			if p_input.upcase() == "N"
				return true
			end
		when "Pawn"
			if p_input == ""
				return true
			end
		else
			return false
		end
	end
	
	def endangers_king?(origin, color)
		piece_temp_holder = origin.remove_piece()
		update_board()
		if color == "white"
			@black_threats.each do |coord|
				cell = get_cell(coord)
				if cell.has_piece?()
					if cell.piece() == @white_k
						origin.set_piece(piece_temp_holder)
						update_board()
						return true
					end
				end
			end
		else
			@white_threats.each do |coord|
				cell = get_cell(coord)
				if cell.has_piece?()
					if cell.piece() == @black_k
						origin.set_piece(piece_temp_holder)
						update_board()
						return true
					end
				end
			end
		end
		origin.set_piece(piece_temp_holder)
		update_board()
		false
	end

	def possible_move?(piece_str, color, origin, operand, destination)
		# Check if piece is the tipe specified
		if correct_piece?(origin.piece(), piece_str)
			# Check if piece is the color of player
			piece = origin.piece
			if piece.color == color
			# if operand is -
				if operand == "-"
				# if move is in range
					if piece.move_spaces.include?(destination.coord)
						# If king is checked, only allow moves that block
						# the threat.
						if @check
							threat_vector = get_threat_vector()
							if threat_vector.include?(destination.coord)
								@check = false
								@threat_cell = nil
								return true
							else
								p "King is checked, but move didn't block attack vector of the #{@threat_cell.piece().class()} threatening it."
								return false
							end
						end
						# if move opens up the king to an attack vector
						# disallow it
						if endangers_king?(origin, color)
							p "Move opens up king for attack."
							return false
						end
						# if a king attempts to move into a threatened space, deny it
						if piece.instance_of?(King)
							if piece.color == "white"
								if @black_threats.include(destination.coord)
									p "The king can't move to a threatened space."
									return false
								end
							else
								if @white_threats.include(destination.coord)
									p "The king can't move to a threatened space."
									return false
								end
							end
						end
						# move
						return true
					else
						puts "The #{piece.class} at #{origin.coord.join()} can't move to #{destination.coord.join()}."
						return false
					end
				# if operand is x or X
				else
					# if destination is in range
					if piece.threat_spaces.include?(destination.coord())
						# if piece is in destination
						if destination.has_piece?()
							threatened_piece = destination.piece()
							unless threatened_piece.color() == piece.color
								# If king is checked, only allow moves that 
								# capture the threatening piece
								if @check
									if destination == @threat_cell
										@check = false
										@threat_cell = nil
										return true
									else
										p "The #{destination.piece().class()} that you're attempting to capture isnt the #{@threat_cell.piece().class()} that's threatening the King}"
									end
								end
								# if a capture opens up the king to an attack
								# vector, disallow it
								if endangers_king?(origin, color)
									p "Move endangers king."
									return false
								end
								# if a king attempts to capture a piece that opens up a
								# threatened space, deny it
								if piece.instance_of?(King)
									if piece.color == "white"
										if @black_threats.include(destination.coord)
											p "The king can't move to a threatened space."
											return false
										end
									else
										if @white_threats.include(destination.coord)
											p "The king can't move to a threatened space."
											return false
										end
									end
								end
								# capture
								return true
							else
								puts "The #{destination.piece.class()} at #{destination.coord.join()} is the same color as the attacker!"
								return false
							end
						else
							puts "The threatened space #{destination.coord.join()} is empty."
							return false
						end
					else
						puts "The selected #{piece.class} doesn't threat #{destination.coord.join()}."
						return false
					end
				end
			else
				puts "You selected a piece from a different color."
				return false
			end
		else
			puts "The piece at Coordinates #{origin.coord.join()} is not the type specified."
			return false
		end
	end
	nil
end


#b = Board.new()
#b.make_move("e2-e4", "white")
#b.make_move("d7-d5", "black")
#b.make_move("Bf1-b5", "white")
#b.make_move("b7-b6", "black")
#b.make_move("c7-c6", "black")
#b.make_move("c6-c5", "black")
#puts b.render_board()

