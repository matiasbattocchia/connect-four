class Player
  def initialize(color, alpha = 0.1, gamma = 0.1, reward = 100)
    @color  = color
    @alpha  = alpha
    @gamma  = gamma
    @reward = reward

    @q = Matrix.new
  end

  def act(state, actions)
    actions.sample
  end

  def move(game)
    state   = game.state
    actions = game.actions
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
      @alpha * @gamma * (actions.map{ |action| @q[state, action] }.max || 0)

    @prev_action = action
    @prev_state  = state

    result
  end
end
