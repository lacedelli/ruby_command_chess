class Cell
	attr_reader :piece, :coord
	
	def initialize(coordinates)
		@piece = nil
		@coord = coordinates
	end

	def remove_piece()
		piece_container = @piece
		@piece = nil
		piece_container
	end

	def set_piece(piece)
		@piece = piece
		nil
	end

	def contains_piece?()
		unless @piece.nil?
			true
		else
			false
		end
	end

	private
	attr_writer :piece, :coord

end

