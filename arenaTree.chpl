use Arena;

class Tree {
  var left, right: unmanaged Tree?;

  proc init(depth, ref arena) {
    if depth >= 0 {
      writeln(depth);
      place(depth-1, arena);
      left = arena.obj;
      place(depth-1, arena);
      right = arena.obj;
    }
  }

  proc sum(): int {
    var sum: int = 1;
    if right then
      sum += right!.sum();
    return sum;
  }
}


proc main() {
  //place(2, arena);
  //var tree = (arena.head + arena.objOffset): unmanaged Tree?;
  //tree!.left = new unmanaged Tree(1, arena);
  //writeln(tree);
  //writeln(arena.curr);
  
  var arena: chpl_arena = new chpl_arena();
  var tree2 = new unmanaged Tree(3, arena);
  //writeln(tree2);
  //writeln(tree2!.sum());
}
