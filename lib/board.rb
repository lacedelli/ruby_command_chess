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

	def get_cell(coord)
		@grid.each do |row|
			row.each do |cell|
				p cell.coord
			end
		end
		nil
	end

end
