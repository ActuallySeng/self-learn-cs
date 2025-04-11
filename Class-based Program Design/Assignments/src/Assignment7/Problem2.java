package Assignment7;

import tester.Tester;

interface IList<T>{
	// Checks if this list has ARG in it.
	int hasElement(T arg);
	int anySimilar(IList<T> arg);
}

class ConsList<T> implements IList<T>{
	T first;
	IList<T> rest;
	
	ConsList(T first, IList<T> rest){
		this.first = first;
		this.rest = rest;
	}

	public int hasElement(T arg) {
		if (arg == first) {
			return 1;
		} else {
			return this.rest.hasElement(arg);
		}
	}

	public int anySimilar(IList<T> arg) {
		return arg.hasElement(this.first) + this.rest.anySimilar(arg);
	}
}

class MTList<T> implements IList<T>{
	public int hasElement(T arg) {
		return 0;
	}

	public int anySimilar(IList<T> arg) {
		return 0;
	}
	
}

// Classes
class Course{
	String name;
	Instructor prof;
	IList<Student> students;
	
	Course(String name, Instructor prof, IList<Student> students){
		this.name = name;
		this.prof = prof;
		prof.courses = new ConsList<Course>(this, prof.courses);
		this.students = students;
	}
}

class Instructor{
	String name;
	IList<Course> courses = new MTList<Course>();
	
	Instructor(String name){
		this.name = name;
	}
	
	boolean dejavu(Student c) {
		return this.courses.anySimilar(c.courses) > 1;
	}
}

class Student{
	String name;
	int id;
	IList<Course> courses = new MTList<Course>();
	
	Student(String name, int id){
		this.name = name;
		this.id = id;
	}
	
	void enroll(Course c) {
		this.courses = new ConsList<Course>(c, this.courses);
		c.students = new ConsList<Student>(this, c.students);
	}
	
	// Checks if c has any same course as THIS student.
	boolean classmates(Student c) {
		return this.courses.anySimilar(c.courses) > 0;
	}
}

class ExamplesCollege{
	Student s1 = new Student("Joe", 44);
	Student s2 = new Student("Shee", 21);
	Student s3 = new Student("Amy", 42);
	Student s4 = new Student("Na Kang Lim", 1);
	Student s5 = new Student("Na Ri", 2);
	
	Instructor i1 = new Instructor("Joe");
	Instructor i2 = new Instructor("Siva");
	Instructor i3 = new Instructor("Ely");

	Course c1 = new Course("Sceince", i1, new MTList<Student>());
	Course c2 = new Course("Mtha", i2, new MTList<Student>());
	Course c3 = new Course("Atr", i1, new MTList<Student>());
	Course c4 = new Course("Fart", i3, new MTList<Student>());
	
	void testCollege(Tester t) {
		s1.enroll(c1);
		s2.enroll(c1);
		s2.enroll(c2);
		s2.enroll(c3);
		
		t.checkExpect(s1.courses, new ConsList<Course>(c1, new MTList<Course>()));
//		t.checkExpect(c1.students, new ConsList<Student>(s1, new MTList<Student>()));
		
		t.checkExpect(new ConsList<Student>(s1, new ConsList<Student>(s2, new MTList<Student>())).hasElement(s2), 1);
		t.checkExpect(new ConsList<Student>(s1, new ConsList<Student>(s2, new MTList<Student>())).hasElement(s3), 0);
		
		t.checkExpect(s2.classmates(s1), true);
		t.checkExpect(s3.classmates(s1), false);
		
		t.checkExpect(i3.dejavu(s1), false);
		t.checkExpect(i1.dejavu(s2), true);
	}
}