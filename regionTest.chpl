use Time;
class asd {
  var a: int = 5;
}

proc func() {
  extern proc enterRegion();
  enterRegion();

  writeln();
  for i in 0..10000 do {
    var a: asd = new asd(a=5);
  }

  extern proc exitRegion();
  exitRegion();
}
var t: Timer;
t.start();

func();

t.stop();
writeln(t.elapsed());
