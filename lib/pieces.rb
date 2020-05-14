class Piece
	attr_reader :color, :threat_spaces, :move_spaces, :symbol

	def initialize(color)
		@color = color
		@threat_spaces = []
		@move_spaces = []
		@symbol = get_symbol()
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

	def update_moves(moves_arr, threat_arr)
		@threat_spaces = threat_arr
		@move_spaces = moves_arr
		nil
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

	def first_move?()
		@first_move
	end
	
	def moved()
		@first_move = false
		nil
	end

	private
	attr_writer :first_move

	def get_symbol()
		if @color == "black"
			"\u265f".encode("utf-8")
		else
			"\u2659".encode("utf-8")
		end
	end

	def possible_moves(coord)
		moves = {}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		if @color == "white"
			moves[:up] = []
			2.times do |step|
				if valid_coordinates?([coord_a, coord_b + (step + 1)])
					moves[:up] << [int_to_str(coord_a),coord_b + (step + 1)]
				end
			end
			elsif @color == "black"
				moves[:down] = []
				2.times do |step|
					if valid_coordinates?([coord_a, coord_b + (-step - 1)])
						moves[:down] << [int_to_str(coord_a), coord_b + (-step -1)]
					end
				end
			end
		moves
	end

	def threatened_spaces(coord)
		threats = {}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		if @color == "white"
			threats[:diag_up_left] = []
			threats[:diag_up_right] = []
			if valid_coordinates?([coord_a - 1, coord_b + 1])
				threats[:diag_up_left] << [int_to_str(coord_a - 1), coord_b + 1]
			end
			if valid_coordinates?([coord_a + 1, coord_b + 1])
				threats[:diag_up_right] << [int_to_str(coord_a + 1), coord_b + 1]
			end
		elsif @color == "black"
			threats[:diag_down_left] = []
			threats[:diag_down_right] = []
			if valid_coordinates?([coord_a - 1, coord_b - 1])
				threats[:diag_down_left] << [int_to_str(coord_a - 1), coord_b - 1]
			end
			if valid_coordinates?([coord_a - 1, coord_b + 1])
				threats[:diag_down_left] << [int_to_str(coord_a - 1), coord_b + 1]
			end
		end
		threats
	end

end

class Rook < Piece

	def initialize(color)
		super(color)
	end

	private

	def get_symbol()
		if @color == "black"
			"\u265c".encode("utf-8")
		else
			"\u2656".encode("utf-8")
		end
	end

	def possible_moves(coord)
		moves = {up: [], down: [], left: [], right: []}
		# travese the board in each direction, adding each
		# valid coordinate to its respective direction
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		8.times do |step|
			# check coord_a,coord_b + step
			if valid_coordinates?([coord_a, coord_b + (1 + step)])
				moves[:up] << [int_to_str(coord_a), coord_b + (1 + step)]
			end
			# check coord_a + step, coord_b
			if valid_coordinates?([coord_a + (step + 1), coord_b])
				moves[:right] << [int_to_str(coord_a + (step + 1)), coord_b]
			end
			# chech coord_a + -step, coord_b
			if valid_coordinates?([coord_a + (-step - 1), coord_b])
				moves[:left] << [int_to_str(coord_a + (-step - 1)), coord_b]
			end
			# check coord_a, coord_b + -step
			if valid_coordinates?([coord_a, coord_b + (-step - 1)])
				moves[:down] << [int_to_str(coord_a), coord_b + (-step - 1)]
			end
		end
		moves
	end

	def threatened_spaces(coord)
		possible_moves(coord)
	end

end

class Bishop < Piece

	def initialize(color)
		super(color)
	end

	private

	def get_symbol()
		if @color == "black"
			"\u265d".encode("utf-8")
		else
			"\u2657".encode("utf-8")
		end
	end
	
	def possible_moves(coord)
		moves = {up_right: [], down_right: [], down_left: [], up_left: []}
		# travese the board in each direction, adding each
		# valid coordinate to its respective direction
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		8.times do |step|
			# check coord_a + step, coord_b + step
			if valid_coordinates?([coord_a + (step + 1), coord_b + (step + 1)])
				moves[:up_right] << [int_to_str(coord_a + (step + 1)), coord_b + (step + 1)]
			end
			# check coord_a - step, coord_b + step
			if valid_coordinates?([coord_a + (-step - 1), coord_b + (step + 1)])
				moves[:up_left] << [int_to_str(coord_a + (-step - 1)), coord_b + (step + 1)]
			end
			# check coord_a + step, coord_b - step
			if valid_coordinates?([coord_a + (step + 1), coord_b + (-step - 1)])
				moves[:down_right] << [int_to_str(coord_a + (step + 1)), coord_b + (-step - 1)]
			end
			# check coord_a -step, coord_b -step
			if valid_coordinates?([coord_a + (-step -1), coord_b + (-step -1)])
				moves[:down_left] << [int_to_str(coord_a + (-step -1)), coord_b + (-step -1)]
			end
		end
		moves
	end

	def threatened_spaces(coord)
		possible_moves(coord)
	end
end

class Knight < Piece

	def initialize(color)
		super(color)
	end

	private

	def get_symbol()
		if @color == "black"
			"\u265e".encode("utf-8")
		else
			"\u2658".encode("utf-8")
		end
	end
	
	def possible_moves(coord)
		moves = {upper_left: [], upper_right: [], right_up: [], right_down: [], bottom_right: [], bottom_left: [], left_down: [], left_up: []}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]

		temp_b = coord_b + 2
		if valid_coordinates?([coord_a - 1, temp_b])
			moves[:upper_left] << [int_to_str(coord_a - 1), temp_b]
		end
		if valid_coordinates?([coord_a + 1, temp_b])
			moves[:upper_right] << [int_to_str(coord_a + 1), temp_b]
		end

		temp_a = coord_a + 2
		if valid_coordinates?([temp_a, coord_b + 1])
			moves[:right_up] << [int_to_str(temp_a), coord_b + 1]
		end
		if valid_coordinates?([temp_a, coord_b - 1])
			moves[:right_down] << [int_to_str(temp_a), coord_b - 1]
		end

		temp_b = coord_b - 2
		if valid_coordinates?([coord_a + 1, temp_b])
			moves[:bottom_right] << [int_to_str(coord_a + 1), temp_b]
		end
		if valid_coordinates?([coord_a - 1, temp_b])
			moves[:bottom_left] << [int_to_str(coord_a - 1), temp_b]
		end

		temp_a = coord_a - 2
		if valid_coordinates?([temp_a, coord_b - 1])
			moves[:left_down] << [int_to_str(temp_a), coord_b - 1]
		end
		if valid_coordinates?([temp_a, coord_b + 1])
			moves[:left_up] << [int_to_str(temp_a), coord_b + 1]
		end
		moves
	end

	def threatened_spaces(coord)
		possible_moves(coord)
	end

end

class Queen < Piece

	def initialize(color)
		super(color)
	end

	private

	def get_symbol()
		if @color == "black"
			"\u265b".encode("utf-8")
		else
			"\u2655".encode("utf-8")
		end
	end

	def possible_moves(coord)
		moves = {up: [], upper_right: [], right: [], lower_right: [], down: [], lower_left: [], left: [], upper_left: []}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		8.times do |step|
			# Check for coord_b + step
			if valid_coordinates?([coord_a, coord_b + (step + 1)])
				moves[:up] << [int_to_str(coord_a), coord_b + (step + 1)]
			end
			# Check for coord_a + step, coord_b + step
			if valid_coordinates?([coord_a + (step + 1), coord_b + (step + 1)])
				moves[:upper_right] << [int_to_str(coord_a + (step + 1)), coord_b + (step + 1)]
			end
			# Check for coord_a + step
			if valid_coordinates?([coord_a + (step + 1), coord_b])
				moves[:right] << [int_to_str(coord_a + (step + 1)), coord_b]
			end
			# Check for coord_a + step, coord_b - step
			if valid_coordinates?([coord_a + (step + 1), coord_b + (-step - 1)])
				moves[:lower_right] << [int_to_str(coord_a + (step + 1)), coord_b + (-step - 1)]
			end
			# Check for coord_b - step
			if valid_coordinates?([coord_a, coord_b + (-step - 1)])
				moves[:down] << [int_to_str(coord_a), coord_b + (-step - 1)]
			end
			# Check for coord_a - step, coord_b - step
			if valid_coordinates?([coord_a + (-step - 1), coord_b + (-step - 1)])
				moves[:lower_left] << [int_to_str(coord_a + (-step - 1)), coord_b + (-step - 1)]
			end
			# Check for coord_a - step
			if valid_coordinates?([coord_a + (-step - 1), coord_b])
				moves[:left] << [int_to_str(coord_a + (-step - 1)), coord_b]
			end
			# Check for coord_a - setp, coord_b + step
			if valid_coordinates?([coord_a + (-step - 1), coord_b + (step + 1)])
				moves[:upper_left] << [int_to_str(coord_a + (-step - 1)), coord_b + (step + 1)]
			end
		end
		moves
	end

	def threatened_spaces(coord)
		possible_moves(coord)
	end

end

class King < Piece
	
	def initialize(color)
		super(color)
	end

	private

	def get_symbol()
		if @color == "black"
			"\u265a".encode("utf-8")
		else
			"\u2654".encode("utf-8")
		end
	end

	def possible_moves(coord)
		moves = {up: [], upper_right: [], right: [], lower_right: [], down: [], lower_left: [], left: [], upper_left: []}
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]

		if valid_coordinates?([coord_a, coord_b + 1])
			moves[:up] << [int_to_str(coord_a), coord_b + 1]
		end
	
		if valid_coordinates?([coord_a + 1, coord_b + 1])
			moves[:upper_right] << [int_to_str(coord_a + 1), coord_b + 1]
		end

		if valid_coordinates?([coord_a + 1, coord_b])
			moves[:right] << [int_to_str(coord_a + 1), coord_b]
		end
		
		if valid_coordinates?([coord_a + 1, coord_b - 1])
			moves[:lower_right] << [int_to_str(coord_a + 1), coord_b  - 1]
		end
		
		if valid_coordinates?([coord_a, coord_b - 1])
			moves[:down] << [int_to_str(coord_a), coord_b - 1]
		end
		
		if valid_coordinates?([coord_a +  - 1, coord_b - 1])
			moves[:lower_left] << [int_to_str(coord_a - 1), coord_b - 1]
		end
		
		if valid_coordinates?([coord_a - 1, coord_b])
			moves[:left] << [int_to_str(coord_a  - 1), coord_b]
		end
		
		if valid_coordinates?([coord_a - 1, coord_b + 1])
			moves[:upper_left] << [int_to_str(coord_a - 1), coord_b + 1]
		end
		moves
	end

	def threatened_spaces(coord)
		possible_moves(coord)
	end
end
