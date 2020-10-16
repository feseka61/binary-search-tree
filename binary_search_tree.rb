def build_tree(array)
  sorted_array = array.uniq.sort
  start = 0
  last = sorted_array.length - 1
  mid = (start + last) / 2
  return nil if array.length == 0
  root = sorted_array[mid]
  left_child = build_tree(sorted_array[start...mid])
  right_child = build_tree(sorted_array[mid + 1..last])
  node = Node.new(root, left_child, right_child)
end

class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def <=> (other)
    @value <=> other.value
  end

  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end  
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def insert(value, root = @root)
    return if root.value == value
    if value < root.value
      if root.left_child.nil?
        return root.left_child = Node.new(value)
      else
        return insert(value, root.left_child) 
      end
    elsif value > root.value
      if root.right_child.nil?
        return root.right_child = Node.new(value) 
      else
        return insert(value, root.right_child) 
      end
    end
  end

  def delete(value, root = @root)
    return root if root.nil?
    if value < root.value
      root.left_child = delete(value, root.left_child)
    elsif value > root.value
      root.right_child = delete(value, root.right_child)
    else
      if root.left_child.nil?
        temp = root.right_child
        root = nil
        return temp
      elsif root.right_child.nil?
        temp = root.left_child
        root = nil
        return temp
      end
      temp = next_big(root)
      root.value = temp.value
      root.right_child = delete(temp.value, root.right_child)
    end
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  def find(value, root = @root)
    return root if root.nil?
    if value < root.value
      return find(value, root.left_child)
    elsif value > root.value
      return find(value, root.right_child)
    else
      return root
    end
  end

  def level_order(root = @root)
    queue = Queue.new
    ordered = []
    return if root.nil?
    queue << root
    current_node = root
    until queue.empty?
      current_node = queue.pop
      queue << current_node.left_child unless current_node.left_child.nil?
      queue << current_node.right_child unless current_node.right_child.nil?
      ordered << current_node.value
    end
    ordered
  end

  def inorder(root = @root)
    ordered = []
    return [] if root.nil?
    ordered.concat(inorder(root.left_child))
    ordered << root.value
    ordered.concat(inorder(root.right_child))
    ordered
  end

  def preorder(root = @root)
    ordered = []
    return [] if root.nil?
    ordered << root.value
    ordered.concat(preorder(root.left_child))
    ordered.concat(preorder(root.right_child))
    ordered
  end

  def postorder(root = @root)
    ordered = []
    return [] if root.nil?
    ordered.concat(postorder(root.left_child))
    ordered.concat(postorder(root.right_child))
    ordered << root.value
    ordered
  end

  def depth(node, root = @root)
    return if node.nil?
    current_node = root
    depth = 0
    until node == current_node
      if node < current_node
        current_node = current_node.left_child
      elsif node > current_node
        current_node = current_node.right_child
      end
      depth += 1
    end
    depth
  end

  def height(root = @root)
    return 0 if root.nil?
    height = depth(find(level_order(root)[-1]), root)
  end

  def balanced?(root = @root)
    return true if root.nil?
    left_height = height(root.left_child)
    right_height = height(root.right_child)
    unless balanced?(root.left_child) && balanced?(root.right_child)
      return false
    end
    if (left_height - right_height).abs > 1
      return false
    else 
      return true
    end
  end

  def rebalance
    array = level_order
    @root = build_tree(array)
  end
  
  def next_big(root)
    next_big = root.right_child
    until next_big.left_child.nil?
      next_big = next_big.left_child
    end
    next_big
  end
end

my_tree = Tree.new(Array.new(15) { rand(1..100) })
puts my_tree.balanced?
my_tree.pretty_print
p my_tree.level_order
p my_tree.preorder
p my_tree.postorder
p my_tree.inorder
puts '--------------------------------------------------------------'
my_tree.insert(101)
my_tree.insert(105)
puts my_tree.balanced?
my_tree.pretty_print
puts '--------------------------------------------------------------'
my_tree.rebalance
puts my_tree.balanced?
my_tree.pretty_print
p my_tree.level_order
p my_tree.preorder
p my_tree.postorder
p my_tree.inorder

