package Lab7;


// represents an empty list of Person's buddies
class MTLoBuddy implements ILoBuddy {
    MTLoBuddy() {}

	public boolean inList(Person that) {
		return false;
	}

	public ILoBuddy addBuddy(Person buddy) {
		return new ConsLoBuddy(buddy, this);
	}

	public int countCommonBuddies(Person that, int count) {
		return count;
	}

	public boolean hasExtendedBuddy(Person that, ILoBuddy seen) {
		return false;
	}

	@Override
	public int partyCount(SeenBuddies seen) {
		return 0;
	}


}
