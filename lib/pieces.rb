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
	attr_reader :color

	def initialize(color)
		super(color)
	end

	def possible_moves(coord)
		[coord[0], coord[1] + 1]
	end

	def threatened_spaces(coord)
		spaces = []
		coord_a = str_to_int(coord[0])
		coord_b = coord[1]
		spaces << [int_to_str(coord_a - 1), coord[1] + 1]
		spaces << [int_to_str(coord_a + 1), coord[1] + 1]
		spaces
	end

end
