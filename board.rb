require_relative "tile"
class Board
    attr_reader :empty_grid, :grid
    def initialize
        @empty_grid = Array.new(9) {Array.new(9, :S)}
        @grid = @empty_grid.deep_dup
    end

    def [](pos1, pos2)
        @empty_grid[pos1][pos2]
    end

    def placing_mines
        occupied = []
        i = 0
        while i < 10
            x = rand(0..8)
            y = rand(0..8)
            if occupied.include?([x, y])
                redo
            else
                occupied << [x, y]
                grid[x][y] = :B
            end
            i += 1
        end
    end

    def render 
        p grid 
    end
end

class Array
    def deep_dup
        copy = []
        i = 0
        while(i < self.length)
            if self[i].is_a?(Array)
                copy << self[i].deep_dup
            else
                copy << self[i]
            end
            i += 1
        end
        return copy
    end
end

board = Board.new()
board.placing_mines