package Assignment8;

import tester.Tester;

interface Predicate<T>{
	boolean apply(T arg);
}

class IsEFG implements Predicate<String>{

	public boolean apply(String arg) {
		return arg.equals("efg");
	}
	
}

class IsCDE implements Predicate<String>{

	public boolean apply(String arg) {
		return arg.equals("cde");
	}
	
}

class IsABC implements Predicate<String>{

	public boolean apply(String arg) {
		return arg.equals("abc");
	}
	
}

abstract class ANode<T>{
	ANode<T> next;
	ANode<T> prev;
	
	abstract int countNodes();
	abstract void addAt(T value, int pos);
	abstract ANode<T> removeFromHead();
	abstract ANode<T> removeFromTail();
	abstract ANode<T> find(Predicate<T> pred);
	abstract ANode<T> findHelper(Predicate<T> pred);
	abstract void removeNode(ANode<T> node);
}

class Node<T> extends ANode<T>{
	T data;
	
	Node(T data){
		this.data = data;
		this.next = null;
		this.prev = null;
	}
	
	Node(T data, ANode<T> next, ANode<T> prev){
		if (next == null || prev == null) {
			throw new IllegalArgumentException("Given node is null.");
		}
		this.data = data;
		this.next = next;
		this.prev = prev;
		
		next.prev = this;
		prev.next = this;
	}

	int countNodes() {
		return 1 + this.next.countNodes();
	}

	void addAt(T value, int pos) {
		this.prev.addAt(value, pos);
	}
	
	ANode<T> removeFromHead() {
		return this.prev.removeFromHead();
	}

	ANode<T> removeFromTail() {
		return this.prev.removeFromTail();
	}

	ANode<T> find(Predicate<T> pred) {
		return this;
	}

	ANode<T> findHelper(Predicate<T> pred) {
		if (pred.apply(this.data)) {
			return this;
		} else {
			return this.next.findHelper(pred);
		}
	}

	void removeNode(ANode<T> node) {
		if (this == node) {
			this.prev.next = this.next;
			this.next.prev = this.prev;
		} else {
			this.next.removeNode(node);
		}
	}
	
}

class Sentinel<T> extends ANode<T> {
	  Sentinel() {
	    this.next = this;
	    this.prev = this;
	  }

	int countNodes() {
		return 0;
	}
	
	void addAt(T value, int pos) {
		if (pos == 1) {
			new Node<T>(value, this.next, this);
		} else {
			new Node<T>(value, this, this.prev);
		}
	}
	
	ANode<T> removeFromHead() {
		ANode<T> newNext = this.next.next;
		ANode<T> oldNext = this.next;
		
		this.next = newNext;
		newNext.prev = this;
		
		oldNext.next = null;
		oldNext.prev = null;
		
		return oldNext;
	}

	ANode<T> removeFromTail() {
		ANode<T> newPrev = this.prev.prev;
		ANode<T> oldPrev = this.prev;
		
		this.prev = newPrev;
		newPrev.next = this;
		
		oldPrev.next = null;
		oldPrev.prev = null;
		
		return oldPrev;
	}

	ANode<T> find(Predicate<T> pred) {
		return this.next.findHelper(pred);
	}

	ANode<T> findHelper(Predicate<T> pred) {
		return this;
	}

	@Override
	void removeNode(ANode<T> node) {
		if (this == node) {
			return;
		} else {
			this.next.removeNode(node);
		}
	}


}

class Deque<T>{
	Sentinel<T> header;
	
	Deque(){
		this.header = new Sentinel<T>();
	}
	
	Deque(Sentinel<T> header){
		this.header = header;
	}
	
	// Counts num of nodes in list.
	int countNodes() {
		return header.next.countNodes();
	}
	
	// Adds new element at head if 1, tail if 0.
	void addAt(T value, int pos) {
		this.header.addAt(value, pos);
	}
	
	// Removes first node.
	ANode<T> removeFromHead() {
		if (header.next == null && header.prev == null) {
			throw new RuntimeException("List is empty");
		}
		
		return this.header.removeFromHead();
	}
	
	// Removes last node.
	ANode<T> removeFromTail(){
		if (header.next == null && header.prev == null) {
			throw new RuntimeException("List is empty");
		}
		
		return this.header.removeFromTail();
	}
	
	// Produces the first node in this Deque for which the given predicate returns true.
	ANode<T> find(Predicate<T> pred){
		return this.header.find(pred);
	}
	
	// Removes an element from the list.
	void removeNode(ANode<T> node) {
		this.header.removeNode(node);
	}
}

class ExamplesList{
	String abc;
	String bcd;
	String cde;
	String def;
	String efg;
	
	ANode<String> mtList;
	ANode<String> l1;
	ANode<String> l2;

	ANode<String> abcn;
	ANode<String> bcdn;
	ANode<String> cden;
	ANode<String> defn;
	ANode<String> efgn;
	
	Deque<String> d1;
	
	void initTest(){
		abc = "abc";
		bcd = "bcd";
		cde = "cde";
		def = "def";
		efg = "efg";
		
		mtList = new Sentinel<String>();
		l1 = new Node<String>(abc, new Node<String>(bcd, new Node<String>(cde, new Node<String>(def, mtList, mtList) , mtList), mtList), mtList);
		
		
		d1 = new Deque<String>(new Sentinel<String>());
		abcn = new Node<String>(abc, d1.header, d1.header);
		bcdn = new Node<String>(bcd, d1.header, abcn);
		cden = new Node<String>(cde, d1.header, bcdn);
		defn = new Node<String>(def, d1.header, cden);
		efgn = new Node<String>(efg, d1.header, defn);
		
	}
	void testList(Tester t) {
		initTest();
		t.checkExpect(mtList.countNodes(), 0);
		t.checkExpect(l1.countNodes(), 4);
		
		initTest();
		l1.addAt(efg, 1);
		t.checkExpect(l1.prev, new Node<String>(efg, l1, mtList));
		l1.addAt(abc, 0);
		t.checkExpect(l1.prev.prev, mtList);
		
		initTest();
		t.checkExpect(mtList.next, l1);
		mtList.removeFromHead();
		t.checkExpect(mtList.next, new Node<String>(bcd, new Node<String>(cde, new Node<String>(def, mtList, mtList) , mtList), mtList));
		
		initTest();
		t.checkExpect(mtList.removeFromHead(), new Node<String>(abc));
		
		initTest();
		t.checkExpect(d1.find(new IsCDE()), cden);
		t.checkExpect(d1.find(new IsABC()), abcn);
		t.checkExpect(d1.find(new IsEFG()), efgn);
		
		initTest();
		d1.removeNode(bcdn);
		t.checkExpect(d1.header.next, new Node<String>(abc, cden, d1.header));
	}
}