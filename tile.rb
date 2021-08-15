class Tile 
    def initialize(sym, pos)
        @orientation = "down"
        if sym != :B   
            @adjacent_mines = 
    end

    def adjacent(pos)
        #different set of positions for the function to use to check for mines. it was necessary as 0-1 = -1 and grid[-1] would return the last value
        #set of positions when both pos[0] and pos[1] are non zero
        positions = [
            [pos[0]-1, pos[1]],
            [pos[0]-1, pos[1]+1],
            [pos[0]-1, pos[1]-1],
            [pos[0]+1, pos[1]],
            [pos[0]+1, pos[1]+1],
            [pos[0]+1, pos[1]-1],
            [pos[0], pos[1]+1],
            [pos[0], pos[1]-1]
        ]
        #positions to check when x (pos[0]) is 0
        position_x_zero = [
            [pos[0]+1, pos[1]],
            [pos[0]+1, pos[1]+1],
            [pos[0]+1, pos[1]-1],
            [pos[0], pos[1]+1],
            [pos[0], pos[1]-1]
        ]
        #positions to check when y (pos[1]) is 0
        position_y_zero = [
            [pos[0]-1, pos[1]],
            [pos[0]-1, pos[1]+1],
            [pos[0]+1, pos[1]],
            [pos[0]+1, pos[1]+1],
            [pos[0], pos[1]+1],
        ]

        #positions to check when both are 0

        position_both_zero = [
            [pos[0]+1, pos[1]],
            [pos[0]+1, pos[1]+1],
            [pos[0], pos[1]+1]
        ]
        if !!(pos[0].to_s =~ /^0$/) && !!(pos[1] =~ /^0$/)
            calc_mines(position_both_zero)
        elsif !!(pos[0].to_s =~ /^0$/) 
            calc_mines(position_x_zero)
        elsif !!(pos[1] =~ /^0$/)
            calc_mines(position_y_zero)
        else
            calc_mines(positions)
        end
    end

    def calc_mines(pos)
        count = 0
        pos.each do |subarr|
            grid[*subarr] == :B    
            count += 1
        end
        return count 
    end
end

