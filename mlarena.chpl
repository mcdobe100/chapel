use tree4;
class mlarena {
  type eltType;
  var head: c_ptr = c_malloc(eltType, 5000);
  var curr: c_ptr = head+24;
  //var obj = head:eltType;
  var off: int = __primitive("sizeof_bundle", eltType);

  proc deinit() {
    c_free(head);
  }

  proc place() {
    //obj = curr: eltType;
    curr += 2*off;
    pnew();
    return curr: eltType;
  }

  proc pnew() {
    __primitive("call init", curr:eltType, this);
  }
}
