require 'minitest/autorun'
require_relative 'matrix'

describe Matrix do
  before do
    @four_four = Matrix.new([1,1,0,0],[1,1,0,0],[0,0,1,1],[0,0,1,1])
    @two_two =   Matrix.new([1,2],[3,4])
  end

  describe 'when multiplied by another matrix' do
    it 'returns the product' do
      assert_equal  8, @four_four * @four_four
      assert_equal 10, @four_four * @two_two
      assert_equal 30, @two_two * @two_two
      assert_equal  5, @four_four.*(@two_two, 1, 1)

      assert_raises { @four_four.*(@two_two, 0, 3) }
      assert_raises { @four_four.*(@two_two, 3, 0) }
      assert_raises { @two_two.*(@four_four) }
    end
  end
end
