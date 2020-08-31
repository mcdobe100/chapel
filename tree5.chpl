use arena3;

config const n = 10;

class goo {
  var left, right: unmanaged goo?;

  proc buildTree(depth: int, ar: arena3) {
    if depth > 0 {
      left = ar.newTree();
      right = ar.newTree();
      left!.buildTree(depth-1, ar);
      right!.buildTree(depth-1, ar);
    }
  }

  proc sum(): int {
    var sum = 1;
    if left then
      sum += left!.sum() + right!.sum();
    return sum;
  }
}


proc main() {
  var allocator = new arena3(eltType=unmanaged goo?);

  var t: unmanaged goo? = allocator.newTree();
  t!.buildTree(n, allocator);
  writeln(t!.sum());
}