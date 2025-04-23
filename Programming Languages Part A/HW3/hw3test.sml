(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)
use "hw3.sml";

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]
val test1b = only_capitals ["A", "b", "1", "C"] = ["A", "C"]
					
val test2 = longest_string1 ["A","bc","C"] = "bc"
val test2b = longest_string1 [] = ""
val test2c = longest_string1 ["bc", "a", "ab"] = "bc";				      
				      
val test3 = longest_string2 ["A","bc","C"] = "bc";
val test3b = longest_string2 ["da", "a", "23", "KK"] = "KK";


val test4a = longest_string3 ["A","bc","C"] = "bc"
val test4b = longest_string4 ["A","B","C"] = "C"

val test5 = longest_capitalized ["A","bc","C"] = "A";
val test5b = longest_capitalized ["AS", "a", "A", "BB"] = "AS";
						     
val test6 = rev_string "abc" = "cba";

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8b = all_answers (fn x => if x < 8 then SOME [x] else NONE) [2,3,4,5,6,7] = SOME [2,3,4,5,6,7]

val test8c = all_answers (fn x => if x > 1 then SOME [x] else NONE) [] = SOME []

val test9a = count_wildcards Wildcard = 1
val test9a2 = count_wildcards (Variable "Joe") = 0;
val test9a3 = count_wildcards (TupleP [UnitP, Wildcard, UnitP, Variable "s", Wildcard]) = 2;
						    
val test9b = count_wild_and_variable_lengths (Variable("a")) = 1;
val test9b2 = count_wild_and_variable_lengths (Variable("abc")) = 3;

val test9c = count_some_var ("x", Variable("x")) = 1;
val test9c2 = count_some_var ("x", Wildcard) = 0;
val test9c3 = count_some_var ("s", TupleP [UnitP, Wildcard, UnitP, Variable "s", Wildcard]) = 1;

val test10 = check_pat (Variable("x")) = true;
val test10b = check_pat (TupleP [Variable "x", Variable "y", Variable "x"]) = false;
						       
								   
val test11 = match (Const(1), UnitP) = NONE;
val test11b = match (Const 5, Wildcard) = SOME [];
val test11c = match (Tuple [Const 5, Unit], TupleP [ConstP 5, ConstP 5]) = NONE;
val test11c = match (Tuple [Const 5, Unit], TupleP [ConstP 5, Variable "b"]) = SOME [("b", Unit)];

val test12 = first_match Unit [UnitP] = SOME [];
