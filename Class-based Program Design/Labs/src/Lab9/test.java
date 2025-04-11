package Lab9;

import java.util.ArrayList;
import tester.*;
import javalib.impworld.*;
import javalib.worldimages.*;
import java.awt.Color;

interface Predicate<T>{
	boolean apply(T arg);
}

class Is10 implements Predicate<Integer>{
	public boolean apply(Integer arg) {
		return arg == 10;
	}
}

class IsOdd implements Predicate<Integer>{

	public boolean apply(Integer arg) {
		return arg % 2 == 1;
	}
}

class Util{
	<T> ArrayList<T> filter(ArrayList<T> arr, Predicate<T> pred){
		ArrayList<T> result = new ArrayList<T>();
		for (T i: arr) {
			if (pred.apply(i)) {
				result.add(i);
			}
		}
		return result;
	}
	
	// Remove all elem that doesnt fulfill pred.
	<T> void removeExcept(ArrayList<T> arr, Predicate<T> pred) {
		ArrayList<T> tempArray = new ArrayList<T>();
		for (T elem: arr) {
			if (!pred.apply(elem)) {
				tempArray.add(elem);
			}
		}
		
		for (T elem: tempArray) {
			arr.remove(elem);
		}
	}
		

}

class ExamplesArray{
	Util util;
	ArrayList<Integer> a1;
	
	void initTest() {
		util = new Util();
		a1 = new ArrayList<Integer>();

		a1.add(1);
		a1.add(3);
		a1.add(4);
		a1.add(5);
		a1.add(7);
		a1.add(8);
	}
	
	void testArray(Tester t) {
		
		initTest();
		ArrayList<Integer> a2 = new ArrayList<Integer>();
		a2.add(1);
		a2.add(3);
		a2.add(5);
		a2.add(7);
		
		t.checkExpect(util.filter(a1, new IsOdd()), a2);
		
		initTest();
		util.removeExcept(a1, new IsOdd());
		t.checkExpect(a1, a2);
	}
}