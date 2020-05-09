class Piece
	attr_reader :color, :threat_spaces, :move_spaces

	def initialize(color)
		@color = color
		@threat_spaces = []
		@move_spaces = []
	end

	def get_moves(coord)
		possible_moves(coord)
	end

	def get_threats(coord)
		threatened_spaces(coord)
	end

	def same_color?(piece)
		if piece.color == @color
			true
		else
			false
		end
	end

	private
	attr_writer :color, :threat_spaces, :move_spaces
	
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
	attr_reader :name

	def initialize(color)
		super(color)
		@first_move = true
		@name = "Pawn"
	end

	def update_moves()
	end

	def moved()
		if @first_move 
			@first_move = false
		end
	end

	private
	attr_writer :first_move

	def possible_moves(coord)
		moves = {}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		moves[:up] = []
		2.times do |step|
			if valid_coordinates?([coord_a, coord_b + (step + 1)])
				moves[:up] << [int_to_str(coord_a),coord_b + (step + 1)]
			end
		end
		moves
	end

	def threatened_spaces(coord)
		threats = {}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		threats[:diag_up_left] = []
		threats[:diag_up_right] = []
		if valid_coordinates?([coord_a - 1, coord_b + 1])
			threats[:diag_up_left] << [int_to_str(coord_a - 1), coord_b + 1]
		end
		if valid_coordinates?([coord_a + 1, coord_b + 1])
			threats[:diag_up_right] << [int_to_str(coord_a + 1), coord_b + 1]
		end
		threats
	end

end

class Rook < Piece

	def initialize(color)
		super(color)
	end

	def update_moves(cells_hash)
		# TODO iterate over move hash 
		# append position if there's no piece on it
		# 
	end

	private
	
	def possible_moves()
		moves = {up: [], down: [], left: [], right: []}
		# TODO 
		# travese the board in each direction, adding each
		# valid coordinate to its respective direction
	end

	def threatened_spaces()
		possible_moves()
	end

end

class Bishop < Piece
end

class Knight < Piece
end

class Queen < Piece
end

class King < Piece
end
