require_relative 'matrix'
require_relative 'player'
require_relative 'game'

EPISODES = 500
ROWS     = 4
COLUMNS  = 4
DELTA = 1
$t = 1500

players = [Player.new(:red, :softmax), Player.new(:yellow)]
results = Hash.new { |h,k| h[k] = 0 }

header = "episodio,rojo,empate,amarillo,temperatura\n"
data = []

EPISODES.times do |i|
  game = Game.new(ROWS, COLUMNS)
  turn = rand(2)
  result = nil

  loop do
    result = players[turn].move(game)
    break if result # :tie, :red, :yellow, nil
    turn = (turn + 1) % 2
  end

#  puts game, '----'

  results[result] += 1
  data << "#{i+1},#{results[:red]},#{results[:tie]},#{results[:yellow]},#{$t}"
  $t -= DELTA
end

#puts(results.reduce(Hash.new(0)) { |a, b| a[b] += 1; a })

IO.write("resultados.csv", header + data.join("\n"))
