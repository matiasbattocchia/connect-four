require 'minitest/autorun'
require_relative 'matrix'
require_relative 'game'

describe Game do
  before do
    @game = Game.new(5,5)

    board = Matrix.new [0,-1,-1,-1,-1],
                       [1, 1, 0, 0,-1],
                       [1, 0, 1,-1, 0],
                       [1, 0,-1, 1, 0],
                       [1,-1, 0, 0, 1]

    @game.instance_variable_set(:@board, board)
  end

  it 'does a diagonal kernel convolution' do
    assert_equal  4, @game.convolution(Game::D)
  end

  it 'does an anti-diagonal kernel convolution' do
    assert_equal -4, @game.convolution(Game::A)
  end

  it 'does a column kernel convolution' do
    assert_equal  4, @game.convolution(Game::V)
  end

  it 'does a row kernel convolution' do
    assert_equal -4, @game.convolution(Game::H)
  end
end
