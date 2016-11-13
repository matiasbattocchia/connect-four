class Game
  # Winning kernels.
  H = Matrix.new([1,1,1,1])
  V = Matrix.new([1],[1],[1],[1])
  D = Matrix.new([1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1])
  A = Matrix.new([0,0,0,1],[0,0,1,0],[0,1,0,0],[1,0,0,0])
  Kernels = [H, V, D, A]

  def initialize(rows=6, columns=7)
    raise "Board size must be 4x4 or bigger." if rows < 4 && columns < 4

    @rows      = 1..rows
    @columns   = 1..columns

    @max_moves = rows * columns
    @moves     = 0

    @board     = Matrix.new

    @free_rows = Hash.new

    @rows.each do |i|
      @free_rows[i] = 1
    end

    @board.rows    = rows
    @board.columns = columns
  end

  def play(color, column)
    raise "This game has ended (#{@result})." if @result
    raise "Can't play #{@color} two times in row." if @color == color
    raise "Column range #{@columns} exceded." unless @columns.include? column

    row = @free_rows[column]
    raise "Row range #{@rows} exceded." unless @rows.include? row

    @free_rows[column] += 1
    @moves += 1
    @board[row, column] = @color = color
    @result = check
  end

  def state
    @board.hash
  end

  def actions
    @free_rows.select{ |_,v| @rows.include?(v) }.keys
  end

  def play_red(column)
    play(1, column)
  end

  def play_yellow(column)
    play(-1, column)
  end

  def to_s
    b = []

    @rows.reverse_each do |row|
      l = []

      @columns.each do |column|
        l <<
          case @board[row, column]
          when  1 then 'o'
          when -1 then 'x'
          else ' '
          end
      end

      b << l.join
    end

    b.join("\n")
  end

  private

  def convolution(kernel)
    if @board.rows < kernel.rows || @board.columns < kernel.columns
      raise 'The board is smaller than the kernel.'
    end

    row_diff    = @board.rows    - kernel.rows
    column_diff = @board.columns - kernel.columns

    values = []

    (row_diff + 1).times do |row_offset|
      (column_diff + 1).times do |column_offset|

        values << @board.*(kernel, row_offset, column_offset)

      end
    end

    values.max
  end

  def check
    return if @moves < 7

    Kernels.each do |kernel|
      case convolution(kernel)
      when  4 then return :red
      when -4 then return :yellow
      end
    end

    return :tie if @moves == @max_moves
  end
end
