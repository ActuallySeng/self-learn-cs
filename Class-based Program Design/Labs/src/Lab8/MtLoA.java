package Lab8;


// Represents the empty List of Accounts
public class MtLoA implements ILoA{
    
    MtLoA(){}

	public int deposit(int amt, int id) {
		throw new RuntimeException("No such account available.");
	}

	public void removeAccount(int acctNo) {
		throw new RuntimeException("No such account available.");
	}

	public void removeAccountHelper(int acctNo, ALoA prev) {
		throw new RuntimeException("No such account available.");
	}

	public void add(Account acct) {
	}
}

