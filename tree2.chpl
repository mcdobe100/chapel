use mlarena;

class ml {
  var left: unmanaged ml?;
  var right: unmanaged ml?;

  proc init() {
    left = nil;
    right = nil;
  }
  
  proc init(depth, ar) {
    left = new unmanaged ml();
    right = new unmanaged ml();
  }
}

proc main() {
  var arena: mlarena = new mlarena();
  var first = arena.head: unmanaged ml?;
  arena.place(1);
  writeln(first);
}
