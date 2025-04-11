package Lab8;


// Represents a savings account
public class Savings extends Account{

    double interest; // The interest rate

    public Savings(int accountNum, int balance, String name, double interest){
        super(accountNum, balance, name);
        this.interest = interest;
    }
    
	int withdraw(int amount) {
		int newBal = balance - amount;
		if (newBal < 0) {
			throw new RuntimeException(String.valueOf(amount) + " is not available");
		} else {
			this.balance = newBal;
			return this.balance;
		}
	}
}
