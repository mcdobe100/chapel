class tree3 {
  var left, right: unmanaged tree3?;

  proc init() {
    left = new unmanaged tree3();
    right = new unmanaged tree3();
  }

  proc deinit() {
    delete left;
    delete right;
  }

  proc doinit() {
    __primitive("call init", this);
  }
}

proc main() {
  var a = new unmanaged tree3();

  writeln(a);
}