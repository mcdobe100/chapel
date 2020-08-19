module Arena {
  type eltType;
  var ptr: c_ptr;
  var numItems;

  proc init(t, size) {
    eltType = t;
    numItems=size;
    ptr = c_malloc(eltType, size);
  }
}