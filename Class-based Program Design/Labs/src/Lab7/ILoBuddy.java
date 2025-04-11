package Lab7;


// represents a list of Person's buddies
interface ILoBuddy {
	// Checks if THAT is in buddies list.
	boolean inList(Person that);
	
	// Adds a buddy to buddies list.
	ILoBuddy addBuddy(Person buddy);
	
	// Add 1 to count if THAT has first as his buddy.
	int countCommonBuddies(Person that, int count);
	
	// True if THAT is a direct/indirect buddy.
	boolean hasExtendedBuddy(Person that, ILoBuddy seen);
	
	// Add 1 if person is not in seen.
	int partyCount(SeenBuddies seen);
}
