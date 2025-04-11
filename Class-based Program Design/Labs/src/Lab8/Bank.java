package Lab8;


// Represents a Bank with list of accounts
public class Bank {
    
    String name;
    ILoA accounts;
    
    public Bank(String name){
        this.name = name;

        // Each bank starts with no accounts
        this.accounts = new SentinelNode(new MtLoA());
    }
    
	 // EFFECT: Add a new account to this Bank
	 void add(Account acct){
		 this.accounts.add(acct);
	 }
	 
	 int deposit(int amt, int id) {
		 return accounts.deposit(amt, id);
	 }
	 

	// EFFECT: Remove the given account from this Bank
	void removeAccount(int acctNo){
		this.accounts.removeAccount(acctNo);
	}

}
