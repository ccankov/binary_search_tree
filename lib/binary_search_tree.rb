require_relative './bst_node'

# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.

# Class implementation of a Binary Search Tree
class BinarySearchTree
  attr_accessor :root

  def initialize(root = nil, &prc)
    @root = root
    prc ||= proc { |el1, el2| el1 <=> el2 }
    @prc = prc
  end

  def insert(value, tree_node = @root)
    return @root = BSTNode.new(value, nil) if @root.nil?

    go_left = go_left?(value, tree_node)
    check_node = go_left ? tree_node.left : tree_node.right

    if check_node.nil?
      node = BSTNode.new(value, tree_node)
      go_left ? tree_node.left = node : tree_node.right = node
    else
      insert(value, check_node)
    end
  end

  def find(value, tree_node = @root)
    case compare_to_value(value, tree_node)
    when 1
      next_node = tree_node.right
    when 0
      return tree_node
    when -1
      next_node = tree_node.left
    end
    return next_node unless next_node
    find(value, next_node)
  end

  def delete(value)
    node = find(value)
    return node unless node
    remove_node(node)
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    return tree_node unless tree_node.right
    maximum(tree_node.right)
  end

  def depth(tree_node = @root)
    return 0 unless tree_node && (tree_node.left || tree_node.right)
    [depth(tree_node.left), depth(tree_node.right)].max + 1
  end

  def is_balanced?(tree_node = @root)
    return true unless tree_node
    depth_diff = depth(tree_node.left) - depth(tree_node.right)
    depth_diff *= -1 if depth_diff < 0
    left_balanced = is_balanced?(tree_node.left)
    right_balanced = is_balanced?(tree_node.right)
    depth_diff < 2 && left_balanced && right_balanced
  end

  def in_order_traversal(tree_node = @root, arr = [])
    in_order_traversal(tree_node.left, arr) if tree_node.left
    arr << tree_node.value
    in_order_traversal(tree_node.right, arr) if tree_node.right
    arr
  end

  def in_order_traversal_node(tree_node = @root, arr = [])
    in_order_traversal_node(tree_node.left, arr) if tree_node.left
    arr << tree_node
    in_order_traversal_node(tree_node.right, arr) if tree_node.right
    arr
  end

  private

  # optional helper methods go here:
  def compare_to_value(value, node)
    @prc.call(value, node.value)
  end

  def go_left?(value, node)
    compare_to_value(value, node) < 1
  end

  def remove_node(node)
    case node.child_vals.length
    when 0
      remove_leaf(node)
    when 1
      remove_with_single_child(node)
    when 2
      remove_with_children(node)
    end
    node.parent = nil
  end

  def remove_leaf(node)
    raise 'not a leaf node' if node.left || node.right
    is_root = !node.parent
    is_left = !is_root && go_left?(node.value, node.parent)
    return @root = nil if is_root
    is_left ? node.parent.left = nil : node.parent.right = nil
  end

  def remove_with_single_child(node)
    raise 'does not have 1 child' if node.child_vals.length != 1
    child = node.left || node.right
    child.parent = node.parent
    return @root = child unless node.parent
    is_left = go_left?(node.value, node.parent)
    is_left ? node.parent.left = child : node.parent.right = child
  end

  def remove_with_children(node)
    child = maximum(node.left)
    is_left = go_left?(node.value, node.parent)
    is_left ? node.parent.left = child : node.parent.right = child
    child.promote(node.parent, node.left, node.right)
  end
end
