class WaterSource
  def initialize(cave)
    @cave = cave
    @row = 1
    @col = 0
  end

  def position_to_the(direction)
    case direction
      when :left
        [@row, @col - 1]
      when :right
        [@row, @col + 1]
      when :top
        [@row - 1, @col]
      when :bottom
        [@row + 1, @col]
      else raise "Invalid direction."
    end
  end

  def move(direction)
    @row, @col = position_to_the direction
    @cave[@row][@col] = Cave::WATER
  end

  def cell_to_the(direction)
    row, col = position_to_the direction
    @cave[row][col]
  end

  def pour
    case Cave::AIR
      when cell_to_the(:bottom)
        move :bottom
      when cell_to_the(:right)
        move :right
      else
        move :left while cell_to_the(:left) == Cave::WATER
        move :top
        pour
    end
  end
end

class Cave
  WATER = '~'
  ROCK = '#'
  AIR = ' '

  def initialize(options)
    @cave = options[:cave]
    @water_amount = options[:water_amount]
    @water_source = WaterSource.new @cave
    @width = @cave.first.length
    @height = @cave.length
  end

  def start_flow
    (@water_amount.to_i - 1).times { @water_source.pour }
  end

  def measure_depth
    (0...@width).to_a.map do |col|
      row = depth = 0
      row += 1 while @cave[row][col] != WATER && row < @height - 1
      depth += 1 while @cave[row + depth][col] == WATER
      @cave[row + depth][col] == AIR ? WATER : depth
    end
  end

  def flow_picture
    @cave.join "\n"
  end
end

water_amount, _, *cave_string = File.open('input.txt', 'r').read.split("\n")

cave = Cave.new water_amount: water_amount, cave: cave_string
cave.start_flow

File.open('output.txt', 'w') {|file| file << cave.measure_depth.join(" ")}
File.open('flow.txt', 'w') {|file| file << cave.flow_picture}



