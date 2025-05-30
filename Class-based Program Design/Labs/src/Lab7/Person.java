package Lab7;


// represents a Person with a user name and a list of buddies
class Person {

    String username;
    ILoBuddy buddies;

    Person(String username) {
        this.username = username;
        this.buddies = new MTLoBuddy();
    }

    // returns true if this Person has that as a direct buddy
    boolean hasDirectBuddy(Person that) {
        return buddies.inList(that);
    }

    // returns the number of people who will show up at the party 
    // given by this person
    int partyCount(){
        return buddies.partyCount(new SeenBuddies());
    }

    // returns the number of people that are direct buddies 
    // of both this and that person
    int countCommonBuddies(Person that) {
        return this.buddies.countCommonBuddies(that, 0);
    }

    // will the given person be invited to a party 
    // organized by this person?
    boolean hasExtendedBuddy(Person that) {
        return buddies.hasExtendedBuddy(that, new MTLoBuddy());
    }
    
	 // EFFECT:
	 // Change this person's buddy list so that it includes the given person
	 void addBuddy(Person buddy){
		 this.buddies = this.buddies.addBuddy(buddy);
	 }

}
