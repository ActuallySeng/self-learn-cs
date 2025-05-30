package Lab8;


// Represents a bank account
public abstract class Account {

    int accountNum;  // Must be unique
    int balance;     // Must remain above zero (others Accts have more restrictions)
    String name;     // Name on the account

    public Account(int accountNum, int balance, String name){
        this.accountNum = accountNum;
        this.balance = balance;
        this.name = name;
    }

	 // EFFECT: Withdraw the given amount
	 // Return the new balance
	 abstract int withdraw(int amount);
	 
	//EFFECT: Deposit the given funds into this account
	//Return the new balance
	int deposit(int funds) {
		int newBal = this.balance + funds;
		this.balance = newBal;
		return newBal;
	}


}
