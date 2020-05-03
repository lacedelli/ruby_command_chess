require_relative "cell.rb"

class Board
	attr_reader :grid

	def initialize()
		@grid = []
		hor_range = ("a".."h")
		8.times do |row|
			@grid << []
			hor_range.each do |col|
				@grid[row] << Cell.new([col, row + 1])
			end
		end
	end

end
