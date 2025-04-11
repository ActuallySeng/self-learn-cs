package Lecture20;

import tester.Tester;

// Wrapper class for list.

interface IMutableLo<T>{
	void add(T arg);
	void remove(String name);
}

class MutableLo<T> implements IMutableLo<T>{
	ILo<T> list;
	
	MutableLo(){
		this.list = new SentinelNode<T>(new MTLo<T>());
	}

	public void add(T arg) {
		this.list = this.list.insert(arg);
	}

	// Removes an element based on element name (String).
	public void remove(String name) {
		this.list.remove(name);
	}
}



interface ILo<T>{
	ILo<T> insert(T arg);
	void remove(String name);
}

class SentinelNode<T> implements ILo<T>{
	ILo<T> rest;
	
	SentinelNode(ILo<T> rest){
		this.rest = rest;
	}

	public ILo<T> insert(T arg) {
		return new SentinelNode<T>(new ConsLo<T>(arg, rest));
	}

	@Override
	public void remove(String name) {
		// TODO Auto-generated method stub
		
	}
}

class ConsLo<T> implements ILo<T>{
	T first;
	ILo<T> rest;
	
	ConsLo(T first, ILo<T> rest){
		this.first = first;
		this.rest = rest;
	}

	public ILo<T> insert(T arg) {
		return new ConsLo<T>(first, rest.insert(arg));
	}

	@Override
	public void remove(String name) {
		// TODO Auto-generated method stub
		
	}
}

class MTLo<T> implements ILo<T>{

	public ILo<T> insert(T arg) {
		return new ConsLo<T>(arg, this);
	}

	@Override
	public void remove(String name) {
		// TODO Auto-generated method stub
		
	}
	
}

// Person class
class Person{
	String name;
	int age;
	
	Person(String name, int age){
		this.name = name;
		this.age = age;
	}
}


class ExamplesWrapper{
	Person james = new Person("James", 15);
	Person henry = new Person("Henry", 54);
	Person tom = new Person("Tom", 23);
	
	MutableLo<Person> newList = new MutableLo<Person>();
	ILo<Person> expectedList = new SentinelNode<Person>(new ConsLo<>(james, new MTLo<>()));
	ILo<Person> expectedList2 = new SentinelNode<Person>(new MTLo<>());
	
	void testWrapper(Tester t) {
		newList.add(james);
		newList.add(henry);
		newList.add(tom);
		t.checkExpect(newList.list, expectedList);
//		newList.remove("James");
//		t.checkExpect(newList.list, expectedList2);
		
	}
}