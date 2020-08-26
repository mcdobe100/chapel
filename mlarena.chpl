use tree2;
class mlarena {
  type eltType = unmanaged ml?;
  var head: c_ptr = c_malloc(eltType, 5000);
  var curr: c_ptr = head;
  var obj = curr:eltType;
  var off: int = __primitive("sizeof_bundle", eltType);

  proc deinit() {
    c_free(head);
  }

  proc place(depth: int) {
    if depth > 0 {
      obj = curr: eltType;
      //var right = (curr+16): eltType;
      //writeln(obj);
      curr += 8;
      __primitive("call init", obj, depth, this);
    }
  }
}
