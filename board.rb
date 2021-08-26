require_relative "tile"
require "colorize"
class Board
   
    def initialize
        $empty_grid = Array.new(9) {Array.new(9, :S)}
        $empty_grid.unshift((1..9).to_a)
        $empty_grid[0].unshift(" ")
        $empty_grid.each.with_index do |x, i|
            if i > 0
                x.unshift(i)
            end
        end
        @tiles = Hash.new()
        @game_over = false
        @flag_count = 1
        @flagged_pos = []
        
    end
    
    def grid 
        $grid = $empty_grid.deep_dup
        return $grid
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
                $empty_grid[x][y] = :B
            end
            i += 1
        end
    end

    def render
        if @game_over == false 
            i = 1
            while i < $grid.length 
                j = 1
                while j < $grid[i].length
                    if $grid[i][j] == "F"
                        $grid[i][j] = "F".magenta
                    elsif @tiles[[i, j]].orientation == "down"
                        $grid[i][j] = "*".yellow
                    else   
                        if @tiles[[i, j]].color == "green"
                            $grid[i][j] = @tiles[[i, j]].value.to_s.green
                        else
                            $grid[i][j] = "_".yellow
                        end
                    end
                    j += 1
                end
                i += 1
            end

            $grid.each do |sub|
                puts sub.join("\s")
            end
        else
            $grid.each do |sub|
                puts sub.join("\s")
            end
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
        create_tiles
        render
        while @game_over == false && all_revealed? == false 
            pos = get_pos
            if pos[0] == "r"
                if @flagged_pos.include?(pos[1..2])
                    puts "Can't reveal a flagged position"
                    redo
                else
                    reveal(pos[1..2])
                end
            else   
                flag(pos[1..2])
            end
        end
    end

    def get_pos
        valid_inp  = false
        str = ""
        while !valid_inp
            puts "Please type the positions you would like to reveal or flag.\nStart with '-r' to reveal or '-f' to flag, followed by the position. eg '-r 1, 2'"
            print ">>\s"
            input = gets.chomp
            if valid_pos?(input)
                valid_inp = true 
                str = input 
            end
        end
        arr = str.match(/^\s*\-([r f])\s+(\d)\,\s*(\d)\s*$/).captures
        pos = [arr[0], arr[1].to_i, arr[2].to_i]
        return pos 
    end

    def valid_pos?(str)
        if !!(str.match(/^\s*\-[r f]\s+\d\,\s*\d\s*$/)) == false
            puts "Invalid input! (Did you put a comma?)"
            return false
        end
        if str.include?("f") && @flag_count == 10
            puts "You have run out of flags!!"
            return false
        else
            puts "You have #{10 - @flag_count} flags left."
        end
        return true
    end

    def reveal(pos)
        if $empty_grid[pos[0]][pos[1]] == :B   
            $grid[pos[0]][pos[1]] = "B".red 
            @game_over = true 
            puts ""
            puts "the position had a mine"
            puts ""
            end_of_game
        else
            i = pos[0]
            until i == 0 || $empty_grid[i][pos[1]] == :B   
                j = pos[1]
                until j == 0 || $empty_grid[i][j] == :B
                    @tiles[[i, j]].reveal
                    j -= 1
                end 
                j = pos[1] + 1
                until j >= 9 || $empty_grid[i][j] == :B
                    @tiles[[i, j]].reveal
                    j += 1
                end 
                i -= 1
            end
            i = pos[0] + 1
            until i == 10 || $empty_grid[i][pos[1]] == :B
                j = pos[1]
                until j == 0 || $empty_grid[i][j] == :B
                    @tiles[[i, j]].reveal
                    j -= 1
                end 
                j = pos[1] + 1
                until j == 10 || $empty_grid[i][j] == :B
                    @tiles[[i, j]].reveal
                    j += 1
                end 
                i += 1
            end
            render
        end
    end

    def flag(pos)
        $grid[pos[0]][pos[1]] = "F"
        @flagged_pos << pos 
        @flag_count += 1
        render
    end

    def end_of_game
        @tiles.each do |x, v|
            if @tiles[x].sym == :B    
                $grid[x[0]][x[1]] = "B".red
            elsif v.adjacent_mines == 0
                $grid[x[0]][x[1]] = "_".yellow
            else 
                $grid[x[0]][x[1]] = @tiles[x].adjacent_mines.to_s.green
            end
        end
        render
    end

    def all_revealed?
        i = 1
        while i < 10
            j = 1
            while j < 10
                if @tiles[[i, j]].orientation == "down" && @tiles[[i, j]].sym != :B   
                    return false
                end
                j += 1
            end
            i += 1
        end
        puts "Congratulations!! You have won the game!".light_cyan
        @game_over = true 
        render
        return true
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
board.grid
board.run
