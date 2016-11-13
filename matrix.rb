class Matrix
  attr_accessor :rows, :columns

  def initialize(*rows)
    @matrix = Hash.new(0)

    rows.each_with_index do |row, row_number|
      row.each_with_index do |value, column_number|

        self[row_number + 1, column_number + 1] = value

      end
    end

    @rows = rows.size
    @columns = rows.first&.size
  end

  def [](row, column)
    @matrix[[row, column]]
  end

  def []=(row, column, value)
    @matrix[[row, column]] = value
  end

  def hash
    @matrix.hash
  end

  def *(other, row_offset = 0, column_offset = 0)
    if rows < other.rows + row_offset ||
       columns < other.columns + column_offset

      raise 'The first matrix does not contain the second one.'
    end

    accumulator = 0

    other.rows.times do |row_number|
      other.columns.times do |column_number|

        accumulator +=
          self[row_number + row_offset + 1,
               column_number + column_offset + 1] *
          other[row_number + 1, column_number + 1]

      end
    end

    accumulator
  end
end
