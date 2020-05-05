class Piece
	attr_reader :color

	def initialize(color)
		@color = color
	end

	def same_color?(piece)
		if piece.color == @color
			true
		else
			false
		end
	end

	private
	attr_writer :color
	
	def valid_coordinates?(attempted_move)
		if attempted_move[0] <= 0 || attempted_move[0] >= 9
			false
		elsif attempted_move[1] <= 0 || attempted_move[1] >= 9
			false
		else 
			true
		end
	end

	def str_to_int(str)
		case str.downcase
		when "a"
			1
		when "b"
			2
		when "c"
			3
		when "d"
			4
		when "e"
			5
		when "f"
			6
		when "g"
			7
		when "h"
			8
		else nil
		end
	end

	def int_to_str(int)
		case int
		when 1
			"a"
		when 2
			"b"
		when 3
			"c"
		when 4
			"d"
		when 5
			"e"
		when 6
			"f"
		when 7
			"g"
		when 8
			"h"
		else nil
		end
	end

end

class Pawn < Piece
	attr_reader :color, :threat_spaces, :move_spaces

	def initialize(color)
		super(color)
		@threat_spaces = []
		@move_spaces = []
		@first_move = true
	end

	def get_next_move_attack(coordinates)
		{threat: threatened_spaces(coordinates),
		 move: possible_moves(coordinates)}
	end
	
	def update_moves(cells_hash)
	end

	private
	attr_writer :threat_spaces, :move_spaces, :first_move

	# get references to the cells on the game board
	def possible_moves(coord)
		coord_a = str_to_int(coord[0])
		# on first move
		if @first_move
			@first_move = false
			return [[int_to_str(coord_a), coord[1] + 2],[int_to_str(coord_a), coord[1] + 1]]
		else
			move = [coord_a, coord[1] + 1]
			if valid_coordinates?(move)
				return [int_to_str(coord_a), coord[1] + 1]
			end
		end
	end

	def threatened_spaces(coord)
		spaces = []
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		if valid_coordinates?([coord_a - 1, coord[1] + 1])
			spaces << [int_to_str(coord_a - 1), coord[1] + 1]
		end
		if valid_coordinates?([coord_a + 1, coord[1] + 1])
			spaces << [int_to_str(coord_a + 1), coord[1] + 1]
		end
		spaces
	end

end
