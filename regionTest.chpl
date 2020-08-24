use Time;
class asd {
  var a: int = 5;
}

proc func() {
  extern proc enterRegion();
  enterRegion();

  forall i in 0..0 do {
    var a: asd = new asd(a=5);
    writeln("");
  }

  extern proc exitRegion();
  exitRegion();
}
/*var t: Timer;
t.start();

func();

t.stop();
writeln(t.elapsed());*/
func();
