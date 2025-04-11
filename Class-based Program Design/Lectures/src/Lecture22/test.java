package Lecture22;

import java.util.ArrayList;
import tester.Tester;

class Util{
	<T> ArrayList<T> interleave(ArrayList<T> arr1, ArrayList<T> arr2){
		ArrayList<T> result = new ArrayList<T>();
		for (int i = 0;
				i < arr1.size();
				i = i + 1) {
			result.add(arr1.get(i));
			result.add(arr2.get(i));
		}
		return result;
	}

}

class ExamplesArray{
	ArrayList<Integer> ar1;
	ArrayList<Integer> ar2;
	
	void initMethod(){
		ar1 = new ArrayList<Integer>();
		ar2 = new ArrayList<Integer>();
		ar1.add(5);
		ar1.add(7);
		ar1.add(8);
		
		ar2.add(3);
		ar2.add(4);
		ar2.add(1);
	}
	
	void testArray(Tester t) {
		initMethod();
		t.checkExpect(ar1.size(), 3);
		t.checkExpect((new Util()).interleave(ar1, ar2), null);
	}
}