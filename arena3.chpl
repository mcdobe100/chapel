use tree5;
class arena3 {
  type eltType;
  var head: c_ptr = c_malloc(eltType, 5000000);
  var curr: c_ptr = head;
  var off: int = __primitive("sizeof_bundle", eltType);

  proc deinit() {
    c_free(head);
  }
  
  proc newTree() {
    var tmp = curr: eltType;
    curr += off;
    return tmp;
  }
}