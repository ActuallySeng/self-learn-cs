(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)
use "hw2.sml";

val test1 = all_except_option ("string", ["string"]) = SOME [];
val test1b = all_except_option ("bro", []) = NONE;
val test1c = all_except_option ("bro", ["string", "cheese", "bro", "pizza"])
	     = SOME ["string", "cheese", "pizza"];
							    

val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = [];
val test2b = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") =  ["Fredrick","Freddie","F"];
								  
val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = [];
val test3b = get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") =  ["Fredrick","Freddie","F"];
		
val test4 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]

val test5 = card_color (Clubs, Num 2) = Black;
val test5b = card_color (Hearts, Queen) = Red;

val test6 = card_value (Clubs, Num 2) = 2;
val test6b = card_value (Clubs, Num 8) = 8;
val test6c = card_value (Hearts, Ace) = 11;
val test6d = card_value (Spades, King) = 10;

val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [];
val test7b = remove_card ([(Spades, Num 10), (Clubs, King), (Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Spades, Num 10), (Clubs, King)];

val test8 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8b = all_same_color [(Hearts, Ace), (Hearts, Ace), (Clubs, King)] = false;
val test8c = all_same_color [(Hearts, Ace), (Spades, King), (Hearts, Ace)] = false;
val test8d = all_same_color [(Hearts, Ace), (Diamonds, Num 10)] = true;

val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4;
val test9b = sum_cards [(Clubs, Num 10),(Clubs, King)] = 20;
val test9c = sum_cards [(Clubs, Ace),(Clubs, Queen)] = 21;
									
val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4;
val test10b = score ([(Hearts, Num 2), (Diamonds, Num 5)], 5) = 3;

val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6;

val cardList = [(Hearts, King), (Clubs, Num 4), (Spades, Queen), (Diamonds, Ace), (Spades, Num 3)];

val test11b = officiate(cardList, [], 10) = score([], 10);
val test11c = officiate([(Hearts, King)], [Draw, Draw], 10) = score([(Hearts, King)], 10);
		  
