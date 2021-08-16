require_relative "tile"
require "colorize"
class Board
   
    attr_reader :empty_grid
    def initialize
        @empty_grid = Array.new(9) {Array.new(9, :S)}
        @empty_grid.unshift((1..9).to_a)
        @empty_grid[0].unshift(" ")
        @empty_grid.each.with_index do |x, i|
            if i > 0
                x.unshift(i)
            end
        end
        @tiles = Hash.new()
        @game_over = false
    end
    
    def grid 
        $grid = @empty_grid.deep_dup
        return $grid
    end

    def [](pos1, pos2)
        $grid[pos1][pos2]
    end

    def placing_mines
        occupied = []
        i = 0
        while i < 10
            x = rand(1..9)
            y = rand(1..9)
            if occupied.include?([x, y])
                redo
            else
                occupied << [x, y]
                @empty_grid[x][y] = :B
            end
            i += 1
        end
    end

    def render 
        $grid.each do |sub|
            puts sub.join("\s").yellow
        end
    end

    def create_tiles
        i = 1
        while i < 10
            j = 1
            while j < 10
                @tiles[[i, j]] = Tile.new($grid[i][j], [i, j])
                $grid[i][j] = "*"
                j += 1
            end
            i += 1
        end
    end

    def run 
        while @game_over == false && all_revealed? == false
            pos = get_pos
            reveal(pos)
            board.render 
        end
    end

    def get_pos
        valid_inp  = false
        str = ""
        while !valid_inp
            puts "please type the positions you would like to check. eg '1, 2'"
            input = gets.chomp
            if !valid_pos?(input)
                puts "invalid input! (Did u put a comma?)"
            else
                valid_inp = true 
                str = input 
            end
        end
        arr = str.match(/^\s*(\d)\,\s*(\d)\s*$/).captures
        pos = [arr[0].to_i, arr[1].to_i]
        return pos 
    end

    def valid_pos?(str)
        !!(str.match(/^\s*\d\,\s*\d\s*$/))
    end

    def reveal(pos)
        if @empty_grid[pos[0]][pos[1]] == :B   
            $grid[pos[0]][pos[1]] = "B".red 
            @game_over = true 
            puts "the position had a mine"
            end_of_game
        else

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
p board.empty_grid
board.grid
board.create_tiles
board.render