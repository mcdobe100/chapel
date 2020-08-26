module Arena {
  use arenaTree;
  class chpl_arena {
    type eltType = unmanaged Tree?;
    var objOffset: int = __primitive("sizeof_bundle", eltType);
    var head: c_ptr = c_malloc(eltType, 5000);
    var curr: c_ptr = head;
    var obj: eltType = curr: eltType;

    proc setObject() {
      obj = curr: eltType;
    }
    
    //takes arguments to pass to initialized of object
    proc deinit() {
      c_free(head);
    }
  }
  proc place(depth: int, ref ar: chpl_arena) {
      ar.setObject();
      ar.curr += ar.objOffset;
      __primitive("call init", ar.obj, depth, ar);
  }
}