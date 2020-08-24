class C {
  var i: int;
  proc init() {
    i = 5;
  }
}
record Arena {
  type eltType;
  var size: int;
  var ptr: c_ptr(eltType);

  proc postinit() {
    ptr = c_malloc(eltType, size);
  }

  proc deinit() {
    c_free(ptr);
  }

  proc alloc(): eltType {
    var ret = ptr:eltType;
    ptr += c_sizeof(eltType);
    //ret!.i=1;
    ret!.init();
    return ret;
  }
}
var arena = new Arena(eltType=unmanaged C?, size=1);
var c = arena.alloc();
writeln(c);