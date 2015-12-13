# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA
  attr_reader :label, :neigbours

  def self.from_string(string)
    expressions = create_expressions_from(string)
    return nil if expressions.empty?
    create_nfa_from(expressions)
  end

  def initialize(label)
    @label = label
    @neigbours = {}
  end

  def add_neigbour(move_label, state)
    @neigbours[move_label] = state
  end

  def each(&block)
    return self unless block_given?

    if neigbours.empty?
      block.call self
      return
    end

    block.call self

    neigbours.keys.each do |key|
      neigbours[key].each(&block)
    end
  end

  def matches(string)
    @found = false
    (0..string.length).each do |i|
      bt(self, string[i..string.length])
      break if @found
    end
    @found
  end

  def bt(state, string)
    return if reject(state, string)
    if accept(state)
      @found = true
      return
    end

    s = first(state, string)
    s.each do |key|
      bt(state.neigbours[key], string[1..string.length])
      break if @found
    end
  end

  def reject(state, string)
    if state.final? || (state.neigbours.key? string[0..0])
      return false
    else
      return true
    end
  end

  def accept(state)
    state.final?
  end

  def first(state, string)
    state.neigbours.keys.select { |i| i == string[0..0] }
  end

  def max_path
    path = max_path = []
    find_max_path(path, max_path)
  end

  def to_s
    "State: label=#{@label}, neigbours=#{@neigbours}"
  end

  protected

  def final?
    neigbours.empty?
  end

  def find_max_path(path, max_path)
    path << label
    if self.final?
      max_path = path.clone if max_path.length < path.length

      return max_path
    else
      neigbours.keys.each do |key|
        max_path = neigbours[key].find_max_path(path.clone, max_path)
      end

      return max_path
    end
  end

  def self.create_expressions_from(string)
    expressions = []

    string.each_char do |char|
      expressions << create_signle_expression_from(char)
    end

    expressions
  end

  def self.create_signle_expression_from(char)
    start = NFA.new("i#{char}")
    finish = NFA.new("f#{char}")
    start.add_neigbour(char, finish)

    start
  end

  def self.create_nfa_from(expressions)
    nfa = expressions.shift
    state = nfa.neigbours[nfa.neigbours.keys.first]

    until expressions.empty?
      elem = expressions.shift

      elem.neigbours.keys.each do |key|
        state.neigbours[key] = elem.neigbours[key]
      end

      state = state.neigbours[state.neigbours.keys.first]
    end

    nfa
  end
end
