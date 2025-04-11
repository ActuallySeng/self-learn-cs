package Assignment8;

import java.util.*;
import tester.Tester;

/**
 * A class that defines a new permutation code, as well as methods for encoding
 * and decoding of the messages that use this code.
 */
class PermutationCode {
    // The original list of characters to be encoded
    ArrayList<Character> alphabet = 
        new ArrayList<Character>(Arrays.asList(
                    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 
                    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 
                    't', 'u', 'v', 'w', 'x', 'y', 'z'));

    ArrayList<Character> code = new ArrayList<Character>(26);

    // A random number generator
    Random rand = new Random();

    // Create a new instance of the encoder/decoder with a new permutation code 
    PermutationCode() {
        this.code = this.initEncoder();
    }

    // Create a new instance of the encoder/decoder with the given code 
    PermutationCode(ArrayList<Character> code) {
        this.code = code;
    }

    // Initialize the encoding permutation of the characters
    ArrayList<Character> initEncoder() {
        ArrayList<Character> alphabetClone = 
                new ArrayList<Character>(Arrays.asList(
                            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 
                            'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 
                            't', 'u', 'v', 'w', 'x', 'y', 'z'));
        
    	int oriSize = alphabetClone.size();
    	ArrayList<Character> result = new ArrayList<Character>();
    	
        for (int i = 0; i < oriSize; i = i + 1) {
        	int random = rand.nextInt(alphabetClone.size());
        	Character chosen = alphabetClone.get(random);
        	result.add(chosen);
        	alphabetClone.remove(random);
        }
        
        return result;
    }

    // produce an encoded String from the given String
    String encode(String source) {
        return encodeHelper(source, 0);
    }
    
    String encodeHelper(String source, int index) {
    	if (index < source.length()) {
    		return this.convertChar(source.charAt(index), this.alphabet, this.code) + this.encodeHelper(source, index + 1); 
    	} else {
    		return "";
    	}
    }
    
    String convertChar(Character chars, ArrayList<Character> source, ArrayList<Character> effect) {
    	
    	for (int i = 0; i < source.size(); i = i + 1) {
    		if (source.get(i).equals(chars)) {
    			return effect.get(i).toString();
    		}
    	}
    	return "";
    }

    // produce a decoded String from the given String
    String decode(String code) {
        return decodeHelper(code, 0);
    }
    
    String decodeHelper(String code, int index) {
    	if (index < code.length()) {
    		return this.convertChar(code.charAt(index), this.code, this.alphabet) + this.encodeHelper(code, index + 1); 
    	} else {
    		return "";
    	}
    }
}

class ExamplesPermutation {
	  PermutationCode c0 = new PermutationCode(new ArrayList<Character>(Arrays.asList(
	      'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
	      'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
	      't', 'u', 'v', 'w', 'x', 'y', 'z')));
	  PermutationCode c1 = new PermutationCode(new ArrayList<Character>(Arrays.asList(
	      'z', 'y', 'x', 'w', 'v', 'u', 't', 's', 'r', 'q',
	      'p', 'o', 'n', 'm', 'l', 'k', 'j', 'i', 'h', 'g',
	      'f', 'e', 'd', 'c', 'b', 'a')));
	  PermutationCode c2 = new PermutationCode(new ArrayList<Character>(Arrays.asList(
	      'e', 'd', 'c', 'b', 'a', 'f', 'g', 'h', 'i', 'j',
	      'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
	      'u', 'v', 'w', 'x', 'y', 'z')));
	  PermutationCode c3 = new PermutationCode();

	  void testDecode(Tester t) {
	    t.checkExpect(c2.decode(""), "");
	    t.checkExpect(c0.decode("hello"), "hello");
	    t.checkExpect(c1.decode("abcde"), "zyxwv");
	    t.checkExpect(c2.decode("eda"), "abe");
	  }

	  void testEncode(Tester t) {
	    t.checkExpect(c2.encode(""), "");
	    t.checkExpect(c0.encode("hello"), "hello");
	    t.checkExpect(c1.encode("zyxwv"), "abcde");
	    t.checkExpect(c2.encode("abe"), "eda");
	  }

//	  void testInitDecoder(Tester t) {
//	    t.checkExpect(c3.encode(""), "");
//	    t.checkExpect(c3.decode(""), "");
//	    t.checkExpect(c3.decode(c3.encode("hello")), "hello");
//	    t.checkExpect(c3.decode(c3.encode("abcdefghijklmnopqrstuvwxyz")),
//	        "abcdefghijklmnopqrstuvwxyz");
//
//
//	  }

	}