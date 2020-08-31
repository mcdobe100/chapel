use mlarena;

class asd {
  var left, right: unmanaged asd?;

  proc init(ar) {
    left = (ar.curr-48): unmanaged asd?;
    right = (ar.curr-48): unmanaged asd?;
  }
  proc sum(): int {
    var sum = 1;
    if left {
      sum += left!.sum() + right!.sum();
    }
    return sum;
  }
}

proc buildTree(depth, ar): unmanaged asd? {
  for i in 0..#depth-1 do
    ar.place();
  return ar.place();
}

proc main() {
  var arena: mlarena = new mlarena(eltType=unmanaged asd?);

  /*  var a = arena.place();
  var b = arena.place();
  var c = arena.place();
  writeln(a!.sum());
  writeln(b!.sum());
  writeln(c!.sum());*/

  var d = buildTree(11, arena);
  //writeln("\n",d,"\n");
  writeln(d!.sum());
}