class Player
  attr_reader :temperature

  def initialize(color, strategy = :random,
    alpha = 0.1, gamma = 0.1, reward = 100, &block)

    @color  = color
    @alpha  = alpha
    @gamma  = gamma
    @reward = reward
    @strategy = strategy
    @block  = block

    @q = Matrix.new
  end

  def act(state, actions)
    case @strategy
    when :softmax
      exponentials = actions.map do |action|
        Math.exp(@q[state,action]/$temperature)
      end

      z = exponentials.inject(:+)
      probabilities = exponentials.map { |element| element / z }

      accumulator = 0

      superior_intervals = probabilities.map do |probability|
        accumulator += probability
      end

      inferior_intervals = superior_intervals.dup
      inferior_intervals.unshift(0) # Agrega un 0 al principio.
      inferior_intervals.pop # Quita el 1 del final.

      n = rand

      actions.length.times do |i|
        if inferior_intervals[i] <= n && n < superior_intervals[i]
          return actions[i]
        end
      end

      raise "There was an Math.exp overflow."
    when :greedy
      if rand > @temperature
        scores = actions.map { |action| @q[state, action] }
        index  = scores.each_with_index.max[1]
        actions[index]
      else
        actions.sample
      end
    else
      actions.sample
    end
  end

  def move(game, episode = nil)
    state   = game.state
    actions = game.actions

    @temperature = @block.call(episode) if @block

    action  = act(state, actions)

    result = game.send("play_#{@color}", action)

    # reward is the R matrix simplified by a scalar
    # consisting in a reward for only winning.
    reward = result == @color ? @reward : 0

    # The q-learning rule is split in two parts: the first one deals with the
    # current state information; the term that calculates the maximum Q of
    # next possible moves is delayed and constitutes the second part, this is
    # because an opponent move is required for its computation.
    @q[state, action] = @q[state, action] +
      @alpha * (reward - @q[state, action])

    @q[@prev_state, @prev_action] = @q[@prev_state, @prev_action] +
      @alpha * @gamma * actions.map{ |action| @q[state, action] }.max

    @prev_action = action
    @prev_state  = state

    result
  end
end
