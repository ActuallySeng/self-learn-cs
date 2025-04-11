package Lab8;


// Represents a List of Accounts
public interface ILoA{
	int deposit(int amt, int id);
	void removeAccount(int acctNo);
	void removeAccountHelper(int acctNo, ALoA prev);
	void add(Account acct);
}

abstract class ALoA implements ILoA{
	ILoA rest;
	
	ALoA(ILoA rest){
		this.rest = rest;
	}
}