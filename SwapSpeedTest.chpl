use Random;
use BlockDist;
use Time;

config const k = 100_000_000;
config const MAX_VAL = 500_000;
config const IS_DIST=false;

proc fillArr(a:[] ?t, const aMin, const aMax) where isIntType(t) {
  coforall loc in Locales {
    on loc {
      ref myA = a.localSlice[a.localSubdomain()];
      fillRandom(myA);
      [ai in myA] if (ai < 0) { ai = -ai; }
      if (aMax > aMin) {
        const modulus = aMax - aMin;
        [x in myA] x = ((x % modulus) + aMin):t;
      }
    }
  }
}

proc makeDefaultArray() {
  var a: [0..#k] int;
  fillArr(a,0,MAX_VAL);
  return a;
}

proc makeDistArray() {
  var a: [{0..#k} dmapped Block(boundingBox={0..#k})] int;
  fillArr(a,0,MAX_VAL);
  return a;
}

proc swapArrays(arr1: [?D] int, arr2: [D] int) {
  arr1 <=> arr2;
}

proc testReg() {
  var a, b;
  a = makeDefaultArray();
  b = makeDefaultArray();

  var t: Timer;
  t.start();
  swapArrays(a,b);
  t.stop();
  
  return t.elapsed();
}

proc testDist() {
  var a, b;
  a = makeDistArray();
  b = makeDistArray();

  var t: Timer;
  t.start();
  swapArrays(a,b);
  t.stop();
  
  return t.elapsed();
}

proc main() {
  var a:real;
  
  if IS_DIST {
    a = testDist();
  } else {
    a = testReg();
  }

  writeln("Swap on ", k, " elements took ",a, " seconds");
  if IS_DIST then writeln("Array type: block distributed"); else writeln("Array type: default");
}
