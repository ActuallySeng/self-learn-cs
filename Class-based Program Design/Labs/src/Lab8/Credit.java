package Lab8;


// Represents a credit line account
public class Credit extends Account{

    int creditLine;  // Maximum amount accessible
    double interest; // The interest rate charged
    
    public Credit(int accountNum, int balance, String name, int creditLine, double interest){
        super(accountNum, balance, name);
        this.creditLine = creditLine;
        this.interest = interest;
    }

	int withdraw(int amount) {
		int newBal = balance + amount;
		if (newBal > creditLine) {
			throw new RuntimeException(String.valueOf(amount) + " is not available");
		} else {
			this.balance = newBal;
			return this.balance;
		}
	}
	
	int deposit(int funds) {
		int newBal = balance - funds;
		if (newBal < 0) {
			throw new RuntimeException(String.valueOf(funds) + " exceeds debt amount");
		} else {
			this.balance = newBal;
			return this.balance;
		}
	}
}
