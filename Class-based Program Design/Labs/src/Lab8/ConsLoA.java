package Lab8;


// Represents a non-empty List of Accounts...
public class ConsLoA extends ALoA{

    Account first;

    public ConsLoA(Account first, ILoA rest){
    	super(rest);
        this.first = first;
    }

	public int deposit(int amt, int id) {
		if (first.accountNum == id) {
			return first.deposit(amt);
		} else {
			return rest.deposit(amt, id);
		}
	}

	public void removeAccount(int acctNo) {
	}

	public void removeAccountHelper(int acctNo, ALoA prev) {
		if (first.accountNum == acctNo) {
			prev.rest = this.rest;
		} else {
			this.rest.removeAccountHelper(acctNo, this);
		}
		
	}

	public void add(Account acct) {	
	}
    
    /* Template
     *  Fields:
     *    ... this.first ...         --- Account
     *    ... this.rest ...          --- ILoA
     *
     *  Methods:
     *
     *  Methods for Fields:
     *
     */
}