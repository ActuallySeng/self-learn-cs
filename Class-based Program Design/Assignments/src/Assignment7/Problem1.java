package Assignment7;

import tester.Tester;

interface IArith{
	<R> R accept(IArithVisitor<R> visitor);
}

class Const implements IArith{
	double num;
	
	Const(double num) {
		this.num = num;
	}

	public <R> R accept(IArithVisitor<R> visitor) {
		return visitor.visitConst(this);
	}
}

class UnaryFormula implements IArith{
	IFunc<Double, Double> func;
	String name;
	IArith child;
	
	UnaryFormula(IFunc<Double, Double> func, String name, IArith child){
		this.func = func;
		this.name = name;
		this.child = child;
	}

	public <R> R accept(IArithVisitor<R> visitor) {
		return visitor.visitUnary(this);
	}
}

class BinaryFormula implements IArith{
	IBiFunc<Double, Double, Double> func;
	String name;
	IArith left;
	IArith right;
	
	BinaryFormula(IBiFunc<Double, Double, Double> func, String name, IArith left, IArith right){
		this.func = func;
		this.name = name;
		this.left = left;
		this.right = right;
	}

	public <R> R accept(IArithVisitor<R> visitor) {
		return visitor.visitBinary(this);
	}
}

// Function object
interface IFunc<A, R>{
	R apply(A arg);
}

interface IBiFunc<A1, A2, R>{
	R apply(A1 a1, A2 a2);
}


class Neg implements IFunc<Double, Double>{
	public Double apply(Double arg) {
		return - arg;
	}
}

class Sqr implements IFunc<Double, Double>{
	public Double apply(Double arg) {
		return arg * arg;
	}
}

class Plus implements IBiFunc<Double, Double, Double>{
	public Double apply(Double a1, Double a2) {
		return a1 + a2;
	}
}

class Minus implements IBiFunc<Double, Double, Double>{
	public Double apply(Double a1, Double a2) {
		return a1 - a2;
	}
}

class Mul implements IBiFunc<Double, Double, Double>{
	public Double apply(Double a1, Double a2) {
		return a1 * a2;
	}
}

class Div implements IBiFunc<Double, Double, Double>{
	public Double apply(Double a1, Double a2) {
		return a1 / a2;
	}
}

//Visitor
interface IArithVisitor<R>{
	R visitConst(Const consts);
	R visitUnary(UnaryFormula unary);
	R visitBinary(BinaryFormula binary);
}

class EvalVisitor implements IFunc<IArith, Double>, IArithVisitor<Double>{
	public Double apply(IArith arg) {
		return arg.accept(this);
	}
	
	public Double visitConst(Const consts) {
		return consts.num;
	}

	public Double visitUnary(UnaryFormula unary) {
		return unary.func.apply(this.apply(unary.child));
	}

	public Double visitBinary(BinaryFormula binary) {
		return binary.func.apply(this.apply(binary.left), this.apply(binary.right));
	}
	
}

class PrintVisitor implements IArithVisitor<String>, IFunc<IArith, String>{

	public String apply(IArith arg) {
		return arg.accept(this);
	}

	public String visitConst(Const consts) {
		return String.valueOf(consts.num);
	}

	public String visitUnary(UnaryFormula unary) {
		return "(" + unary.name + " " + unary.child.accept(this) + ")";
	}

	public String visitBinary(BinaryFormula binary) {
		return "(" + binary.name + " " + binary.left.accept(this) + " " + binary.right.accept(this) + ")";
	}
	
}

class DoublerVisitor implements IArithVisitor<IArith>, IFunc<IArith, IArith>{

	public IArith apply(IArith arg) {
		return arg.accept(this);
	}

	public IArith visitConst(Const consts) {
		return new Const(consts.num * 2);
	}

	public IArith visitUnary(UnaryFormula unary) {
		return new UnaryFormula(unary.func, unary.name, unary.child.accept(this));
	}

	public IArith visitBinary(BinaryFormula binary) {
		return new BinaryFormula(binary.func, binary.name, binary.left.accept(this), binary.right.accept(this));
	}
	
}


class NoNegativeResults implements IArithVisitor<Boolean>, IFunc<IArith, Boolean>{
	public Boolean apply(IArith arg) {
		return arg.accept(this);
	}

	public Boolean visitConst(Const consts) {
		return consts.num > 0;
	}

	public Boolean visitUnary(UnaryFormula unary) {
		return (new EvalVisitor()).apply(unary) > 0 && unary.child.accept(this);
	}

	public Boolean visitBinary(BinaryFormula binary) {
		return (new EvalVisitor()).apply(binary) > 0 && binary.left.accept(this) && binary.right.accept(this);
	}
	
}


// Examples
class ExamplesArith{
	IArith c1 = new Const(5);
	IArith c2 = new Const(7);
	IArith c3 = new Const(4);
	IArith add = new BinaryFormula(new Plus(), "Add", c1, c2);
	IArith sub = new BinaryFormula(new Minus(), "Minus", add, c3);
	IArith negres = new BinaryFormula(new Minus(), "Minus", sub, new Const(1000));
	
	void testArith(Tester t) {
		t.checkExpect((new EvalVisitor()).apply(add), 12.0);
		t.checkExpect((new EvalVisitor()).apply(sub), 8.0);
		
		t.checkExpect((new PrintVisitor()).apply(sub), "(Minus (Add 5.0 7.0) 4.0)");
		t.checkExpect((new DoublerVisitor()).apply(add), new BinaryFormula(new Plus(), "Add", new Const(10), new Const(14)));
		
		t.checkExpect((new NoNegativeResults()).apply(sub), true);
		t.checkExpect((new NoNegativeResults()).apply(negres), false);
	}
}