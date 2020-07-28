use BlockDist;
use Time;
use Random;

proc fillInt(a:[] ?t, const aMin, const aMax) where isIntType(t) {
  coforall loc in Locales {
    on loc {
      ref myA = a.localSlice[a.localSubdomain()];
      fillRandom(myA);
      [ai in myA] if (ai < 0) { ai = -ai; }
      if (aMax > aMin) {
        const modulus = aMax - aMin;
        [x in myA] x = ((x % modulus) + aMin):t;
        //myA = (myA % modulus) + aMin:t;                                                                                                                       
      }
    }
  }
}

proc addArrs(ref a: [] int, ref b: [] int) {
  return a + b;
}

proc addArrCopies(ref a: [] int, ref b: [] int) {
  var a1 = a;
  var a2 = b;
  return a1 + a2;
}

const size = 10_000_000;

var dom = {0..#size} dmapped Block(boundingBox={0..#size});
var a: [dom] int;
var b: [dom] int;

fillInt(a,0,5000);
fillInt(a,0,5000);

var t = new Timer();

t.start();
addArrs(a,b);
t.stop();

writeln("Time elapsed: %.2dr seconds".format(t.elapsed()));