use "HW1.sml";

(* Test is_older *)
val test1 = is_older((1,1,1), (1,1,1)) = false
val test2 = is_older((1,1,0), (1,1,1)) = true
val test3 = is_older((1,1,1), (1,1,0)) = false
			   

(* Test number_in_month *)
val test6 = number_in_month([], 2) = 0					     
val test4 = number_in_month([(1,1,1), (2,2,2), (3,3,3), (3,2,3)], 2) = 2
val test5 = number_in_month([(1,1,1)], 2) = 0	

(* Test number_in_months *)
val test7 = number_in_months([], []) = 0
val test8 = number_in_months([(1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,2,5), (6,4,6)], [2,4]) = 4					   
val test9 = number_in_months([(1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,5,5), (6,6,6)], [2,4]) = 2				   

(* Test dates in month *)
val test10 = dates_in_month([], 2) = []
val test11 = dates_in_month([(1,1,1), (2,2,2), (3,3,3), (4,4,4)], 2) = [(2,2,2)];
val test12 = dates_in_month([(1,1,1), (2,2,2), (3,3,3), (4,2,4)], 2) = [(2,2,2), (4,2,4)];

(* Test dates in months *)
val test14 = dates_in_months([], []) = []
val test13 = dates_in_months([(1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,2,5), (6,4,6)], [2,4]) = [(2,2,2), (5,2,5), (4,4,4), (6,4,6)];
val test15 = dates_in_months([(1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,5,5), (6,6,6)], [2,4]) = [(2,2,2), (4,4,4)];
												  
(* Test get_nth *)
val test16 = get_nth(["a", "b", "c"], 2) = "b";
val test17 = get_nth(["a", "b", "c", "d", "e"], 5) = "e";

(* Test date_to_string *)
val test18 = date_to_string((2013, 1, 20)) =  "January 20, 2013";
val test19 = date_to_string((2025, 4, 14)) = "April 14, 2025";

(* Test number_before_reaching_sum *)
val test21 = number_before_reaching_sum(5, []) = 0
val test20 = number_before_reaching_sum(5, [2, 3, 4, 5, 6, 7]) = 1;
val test22 = number_before_reaching_sum(10 , [2, 3, 4, 5, 6, 7]) = 3;
								     
(* Test what_month *)
val test23 = what_month(15) = 1;
val test24 = what_month(33) = 2;
val test25 = what_month(365) = 12;

(* Test month_range *)
val test26 = month_range(15, 33) = [1,2];
val test27 = month_range(33, 365) = [2,3,4,5,6,7,8,9,10,11,12];

(* Test oldest *)
val test28 = oldest([]) = NONE;
val test29 = oldest([(1,1,1), (2,2,2), (3,3,3)]) = SOME((1,1,1));
val test30 = oldest([(3,3,3), (2,2,2), (1,1,1)]) = SOME((1,1,1));
