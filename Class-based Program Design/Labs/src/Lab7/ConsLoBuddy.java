package Lab7;

// represents a list of Person's buddies
class ConsLoBuddy implements ILoBuddy {

    Person first;
    ILoBuddy rest;

    ConsLoBuddy(Person first, ILoBuddy rest) {
        this.first = first;
        this.rest = rest;
    }

	public boolean inList(Person that) {
		return first == that || rest.inList(that);
	}

	public ILoBuddy addBuddy(Person buddy) {
		return new ConsLoBuddy(buddy, this);
	}

	public int countCommonBuddies(Person that, int count) {
		if(that.hasDirectBuddy(this.first)) {
			return rest.countCommonBuddies(that, count + 1);
		} else {
			return rest.countCommonBuddies(that, count);
		}
	}

	public boolean hasExtendedBuddy(Person that, ILoBuddy seen) {
		if (first == that) {
			return true;
		} else if (seen.inList(first)) {
			return rest.hasExtendedBuddy(that, seen);
		} else {
			ILoBuddy newSeen = new ConsLoBuddy(this.first, seen);
			return first.buddies.hasExtendedBuddy(that, newSeen) || rest.hasExtendedBuddy(that, newSeen);
		}
	}

	public int partyCount(SeenBuddies seen) {
		if (seen.seen.inList(first)) {
			return rest.partyCount(seen);
		} else {
			seen.addBuddy(first);
			return 1 + first.buddies.partyCount(seen) + rest.partyCount(seen);
		}
		
	}

}

class SeenBuddies{
	ILoBuddy seen = new MTLoBuddy();
	
	void addBuddy(Person that) {
		this.seen =  this.seen.addBuddy(that);
	}
}
