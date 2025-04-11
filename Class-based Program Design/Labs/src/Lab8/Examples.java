package Lab8;

import tester.*;

// Bank Account Examples and Tests
public class Examples {

    public Examples(){ reset(); }
    
    Account check1;
    Account ch2;
    Account ch3;
    
    Account savings1;
    Account s2;
    Account s3;
    
    Account cr1;
    Account cr2;
    Account cr3;
    
    Bank seng;
    Bank ming;
    
    // Initializes accounts to use for testing with effects.
    // We place inside reset() so we can "reuse" the accounts
    public void reset(){
        
        // Initialize the account examples
        check1 = new Checking(1, 100, "First Checking Account", 20);
        ch2 = new Checking(2, 300, "2nd check", 50);
        ch3 = new Checking(3, 250, "3rd Check", 10);
        
        savings1 = new Savings(4, 200, "First Savings Account", 2.5);
        s2 = new Savings(1, 100, "s2", 10.0);
        s3 = new Savings(2, 500, "s3", 100.0);
        
        cr1 = new Credit(1, 250, "cr1", 1000, 2.5);
        cr2 = new Credit(2, 580, "cr2", 1500, 10.0);
        cr3 = new Credit(3, 1000, "cr3", 10000, 100.0);
        
        seng = new Bank("Seng");
        ming = new Bank("Ming");
    }
    
    // Tests the exceptions we expect to be thrown when
    //   performing an "illegal" action.
    public void testExceptions(Tester t){
        reset();
        t.checkException("Test for invalid Checking withdraw",
                         new RuntimeException("1000 is not available"),
                         this.check1,
                         "withdraw",
                         1000);
        t.checkExpect(ch2.withdraw(200), 100);
        t.checkExpect(s2.withdraw(100), 0);
        t.checkExpect(cr1.withdraw(500), 750);
        
    }
    
    // Test the deposit method(s)
    public void testDeposit(Tester t){
        reset();
        t.checkExpect(check1.withdraw(25), 75);
        t.checkExpect(check1, new Checking(1, 75, "First Checking Account", 20));
        t.checkExpect(s2.deposit(10000), 10100);
        t.checkExpect(cr1.deposit(249), 1);
        reset();
        t.checkExpect(seng.accounts, ming.accounts);
        seng.add(ch2);
        seng.deposit(10000, 2);
        seng.removeAccount(2);
        t.checkExpect(seng.accounts, ming.accounts);
    }
}
