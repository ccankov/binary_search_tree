require_relative 'binary_search_tree'

def kth_largest(tree_node, k)
  bst = BinarySearchTree.new(tree_node)
  ordered = bst.in_order_traversal_node
  ordered[-k]
end
