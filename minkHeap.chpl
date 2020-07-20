use Heap;

class minkHeap : ReduceScanOp {
  type eltType;
  const k: int = 5;

  // Store minimum k items as vector in descending order.
  var v =  new heap(eltType);

  proc identity {
    for i in 0..#k {
      v.push(max(eltType));
    }
    return v;
  }

  proc accumulateOntoState(ref v, value: eltType) {
    if value <= v.top() {
      v.pop();
      v.push(value);
    }
  }

  proc accumulate(value: eltType) {
    accumulateOntoState(v, value);
  }

  proc accumulate(accumState: []) {
    for stateValue in accumState {
      accumulate(stateValue);
    }
  }

  proc combine(state: borrowed minkHeap(eltType)) {
    accumulate(state.v);
  }

  proc generate() {
    return v;
  }

  proc clone() {
    return new unmanaged minkHeap(eltType=eltType, k=k);
  }
}

var a = [1,2,3];

var sd = createHeap(a);

writeln(minkHeap reduce a);
