require_relative 'matrix'
require_relative 'player'
require_relative 'game'

def experiment(name, red_player, episodes = 1000)
  players = [red_player, Player.new(:yellow)]

  results = Hash.new { |h,k| h[k] = 0 }

  header = "episodio,rojo,empate,amarillo,temperatura\n"
  data = []

  episodes.times do |i|
    game = Game.new
    turn = rand(2)
    result = nil

    loop do
      result = players[turn].move(game)
      break if result # :tie, :red, :yellow, nil
      turn = (turn + 1) % 2
    end

    #puts "\n", game, "\n"

    results[result] += 1

    data << "#{i+1},#{results[:red].to_f/(i+1)},#{results[:tie].to_f/(i+1)}," \
      "#{results[:yellow].to_f/(i+1)},#{red_player.temperature}"
  end

  puts name, results[:red].to_f/episodes

  IO.write(name + '.csv', header + data.join("\n"))
end

#experiment('descuento_0,1',
           #Player.new(:red, :greedy, 0.1, 0.1, 100) {0.5} )

#experiment('descuento_0,7',
           #Player.new(:red, :greedy, 0.1, 0.7, 100) {0.5} )

#experiment('descuento_1,0',
           #Player.new(:red, :greedy, 0.1, 1.0, 100) {0.5} )

#experiment('descuento_0,7_temperatura_0,7',
           #Player.new(:red, :greedy, 0.1, 0.7, 100) {0.7} )

#experiment('descuento_0,7_temperatura_0,3',
           #Player.new(:red, :greedy, 0.1, 0.7, 100) {0.3} )

experiment('descuento_0,7_temperatura_0,1',
           Player.new(:red, :greedy, 0.1, 0.7, 100) {0.1} )

#experiment('descuento_0,7_temperatura_0,3_recompensa_1000',
           #Player.new(:red, :greedy, 0.1, 0.7, 1000) {0.3} )

experiment('descuento_0,7_temperatura_0,3_sube',
  Player.new(:red, :greedy, 0.1, 0.7, 100) { |i|
  0.25 + i.to_f/100 } )

experiment('descuento_0,7_temperatura_0,3_baja',
  Player.new(:red, :greedy, 0.1, 0.7, 100) { |i|
  0.35 - i.to_f/100 } )

#experiment('descuento_0,7_temperatura_0,3_escalón_a_0',
  #Player.new(:red, :greedy, 0.1, 0.7, 100) { |i|
  #i > 1500 ? 0 : 0.3 } )
