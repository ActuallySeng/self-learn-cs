package Lab8;

class SentinelNode extends ALoA{
	
	SentinelNode(ILoA rest){
		super(rest);
	}

	public int deposit(int amt, int id) {
		return rest.deposit(amt, id);
	}

	public void removeAccount(int acctNo) {
		rest.removeAccountHelper(acctNo, this);
		
	}

	public void removeAccountHelper(int acctNo, ALoA prev) {
	}

	public void add(Account acct) {
		this.rest = new ConsLoA(acct, rest);
	}
	
}