use arena3;
use DynamicIters;

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

proc bench(ar: arena3) {
  const minDepth = 4,                      // the shallowest tree
        maxDepth = max(minDepth + 2, n),   // the deepest normal tree
        strDepth = maxDepth + 1,           // the depth of the "stretch" tree
        depths = minDepth..maxDepth by 2;  // the range of depths to create
  var stats: [depths] (int,int);           // stores statistics for the trees

  {
    const strTree = ar.newTree();
    strTree!.buildTree(strDepth, ar);
    writeln("stretch tree of depth ", strDepth, "\t check: ", strTree!.sum());
  }
  const llTree = ar.newTree();
  llTree!.buildTree(maxDepth, ar);

  for depth in dynamic(depths) {
    const iterations = 2**(maxDepth - depth + minDepth);
    var sum = 0;

    for i in 1..iterations {
      const t = ar.newTree();
      t!.buildTree(depth, ar);
      sum += t!.sum();
    }
    stats[depth] = (iterations, sum);
  }

  for (depth, (numTrees, checksum)) in zip(depths, stats) do
    writeln(numTrees, "\t trees of depth ", depth, "\t check: ", checksum);

  writeln("long lived tree of depth ", maxDepth, "\t check: ", llTree!.sum());

}


proc main() {
  var allocator = new arena3(eltType=unmanaged goo?);

  /*var t: unmanaged goo? = allocator.newTree();
  t!.buildTree(n, allocator);
  writeln(t!.sum());*/

  bench(allocator);
}