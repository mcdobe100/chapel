use mlarena;

class ml {
  var left, right: unmanaged ml?;

  proc init(depth, ar) {
    if depth > 0 {
      ar.place(depth-1);
      ar.place(depth-1);
      left = (ar.curr-24): unmanaged ml?;
      right = (ar.curr): unmanaged ml?;
    }
  }
  
  proc buildTree() {
    
  }
}

proc main() {
  var arena: mlarena = new mlarena();
  /*var first = arena.head: unmanaged ml?;
  arena.place(2);
  writeln(first);*/

  //var a = arena.place(2);
  var a =arena.place(2);
  writeln(a);
}
