package Lab8;


// Represents a checking account
public class Checking extends Account{

    int minimum; // The minimum account balance allowed

    public Checking(int accountNum, int balance, String name, int minimum){
        super(accountNum, balance, name);
        this.minimum = minimum;
    }

	int withdraw(int amount) {
		int newBal = balance - amount;
		if (newBal < minimum) {
			throw new RuntimeException(String.valueOf(amount) + " is not available");
		} else {
			this.balance = newBal;
			return this.balance;
		}
	}
}
