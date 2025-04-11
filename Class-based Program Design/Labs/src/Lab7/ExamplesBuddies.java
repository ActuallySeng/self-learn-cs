package Lab7;

import tester.*;


// runs tests for the buddies problem
public class ExamplesBuddies{
	Person ann;
	Person bob;
	Person cole;
	Person ed;
	Person dan;
	Person fay;
	Person gabi;
	Person hank;
	Person jan;
	Person kim;
	Person len;
	
	void initBuddies() {
		ann = new Person("Ann");
		bob = new Person("Bob");
		cole = new Person("Cole");
		ed = new Person("Ed");
		dan = new Person("Dan");
		fay = new Person("Fay");
		gabi = new Person("Gabi");
		hank = new Person("Hank");
		jan = new Person("Jan");
		kim = new Person("Kim");
		len = new Person("Len");
		
		ann.addBuddy(bob);
		ann.addBuddy(cole);
		bob.addBuddy(ann);
		bob.addBuddy(ed);
		bob.addBuddy(hank);
		cole.addBuddy(dan);
		dan.addBuddy(cole);
		ed.addBuddy(fay);
		fay.addBuddy(ed);
		fay.addBuddy(gabi);
		gabi.addBuddy(ed);
		gabi.addBuddy(fay);
		jan.addBuddy(kim);
		jan.addBuddy(len);
		kim.addBuddy(jan);
		kim.addBuddy(len);
		len.addBuddy(jan);
		len.addBuddy(kim);
	}
	
	void testBuddies(Tester t) {
		initBuddies();
		t.checkExpect(jan.hasDirectBuddy(len), true);
		t.checkExpect(bob.hasDirectBuddy(fay), false);
		
		t.checkExpect(ann.countCommonBuddies(dan), 1);
		t.checkExpect(hank.countCommonBuddies(ann), 0);
		
		t.checkExpect(kim.hasExtendedBuddy(ann), false);
		t.checkExpect(ann.hasExtendedBuddy(dan), true);
		t.checkExpect(ann.hasExtendedBuddy(gabi), true);
		
		t.checkExpect(jan.partyCount(), 3);
	}
}