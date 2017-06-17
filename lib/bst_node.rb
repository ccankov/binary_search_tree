require_relative 'binary_search_tree'

# Node class for a binary search tree
class BSTNode
  attr_reader :value
  attr_accessor :right, :left, :parent

  def initialize(value, parent_node = nil)
    @value = value
    @parent = parent_node
    @left = nil
    @right = nil
  end

  def child_vals
    vals = []
    vals << @left.value if @left
    vals << @right.value if @right
    vals
  end

  def parent=(node)
    @parent = node
  end

  def promote(new_parent, new_left, new_right)
    raise 'node has no parent' unless @parent
    case child_vals.length
    when 0
      @parent.right = nil
    when 1
      @parent.right = @left
      @left.parent = @parent
    when 2
      raise 'node has 2 children'
    end
    @left = new_left
    @right = new_right
    new_left.parent = self
    new_right.parent = self
    @parent = new_parent
  end
end
