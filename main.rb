require_relative 'matrix'
require_relative 'player'
require_relative 'game'
require 'pry'

EPISODES = 3000
ROWS     = 4
COLUMNS  = 4
DELTA = 0.001
$e = 1

# alpha, gamma, reward
players = [Player.new(:red, :greedy, 0.2, 0.5, 10000), Player.new(:yellow)]
results = Hash.new { |h,k| h[k] = 0 }

header = "episodio,rojo,empate,amarillo,temperatura\n"
data = []

EPISODES.times do |i|
  game = Game.new(ROWS, COLUMNS)
  turn = rand(2)
  result = nil

  begin
  loop do
    result = players[turn].move(game)
    break if result # :tie, :red, :yellow, nil
    turn = (turn + 1) % 2
  end
  rescue => e
   puts "\n", game, "\n"
   puts e.message, game.actions, "\n"
  end

  results[result] += 1
  data << "#{i+1},#{results[:red]},#{results[:tie]},#{results[:yellow]},#{$e}"
  $e -= DELTA if $e > 0
end

#puts(results.reduce(Hash.new(0)) { |a, b| a[b] += 1; a })

IO.write("resultados.csv", header + data.join("\n"))
