(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

	     
fun all_except_option (str, strs) =
    let fun helper(xs, currentlist, status) =
	    case xs of
		[] => (currentlist, status)
	      | x::xs'  => if same_string(x, str)
			   then helper(xs', currentlist, true)
			   else helper(xs',  x::currentlist, status)
	val (result, status) = helper(strs, [], false)
    in if status = true then SOME (rev result) else NONE
    end

(* String list  list * String -> String list  *) 
fun get_substitutions1(los, str) =
    case los of
	[] => []
      | first::rest =>
	case  all_except_option(str, first) of
	    NONE => get_substitutions1(rest, str)
	  | SOME x => x @ get_substitutions1(rest, str);

fun get_substitutions2(los, str) =
    let fun helper(los_2, rsf) =
            case los_2 of
		[] => rsf
	      | first::rest =>
		case  all_except_option(str, first) of
		    NONE => helper(rest, rsf)
		  | SOME x => helper(rest, rsf @ x)
    in helper(los, [])
    end

(* String list list * Name -> Name list *)
fun similar_names(subs, name) =
    let
	val {first=fst, middle=mid, last=lst} = name;
	val subs_result = get_substitutions1(subs, fst);

	fun replace_helper(lof) =
	    case lof of
		[] => []
	      | first::rest => {first=first, middle=mid, last=lst}::replace_helper(rest)
    in name::replace_helper(subs_result)
    end;
	   



					    

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

fun card_color(c) =
    case c of
	(s, r) => if s = Spades orelse s = Clubs
		  then Black
		  else Red;

fun card_value(c) =
    let val (s, r) = c
    in case r of
	   Num x => x
	 | Ace => 11
	 | _ => 10
    end
	
		       
fun remove_card(cs, c, e) =
    case cs of
	[] => raise e
      | first::rest => if (first = c) then rest else first::remove_card(rest, c, e);

fun all_same_color(cs) =
    case cs of
	[] => true
      | head::[] => true
      | head::neck::rest => card_color(head) = card_color(neck) andalso all_same_color(neck::rest)
	
	
fun sum_cards(cs) =
    let fun helper(cs_2, rsf) =
	case cs_2 of
	    [] => rsf
	  | first::rest => helper(rest, card_value(first) + rsf)
    in helper(cs, 0)
    end;
	
fun score(cs, goal) =
    let
	val sum = sum_cards(cs);
	
	fun prelim_calc() =
	    if (sum > goal)
	    then 3 * ( sum - goal )
	    else goal - sum

	fun same_color(prelim) =
	    if all_same_color(cs)
	    then prelim div 2
	    else prelim
    in same_color(prelim_calc())
    end
				      
		     
fun officiate(loc, lom, goal) =
    let
	fun helper_moves(loc_2, lom_2, held_cards) =
	    case lom_2 of
		[] => score(held_cards, goal)
	      | first::rest => case first of
				   Discard c => helper_moves(loc_2, rest, remove_card(held_cards, c, IllegalMove))
				 | Draw => case loc_2 of
					       [] => score(held_cards, goal)
					     | head::tail  => if (sum_cards(head::held_cards) > goal)
							      then score(head::held_cards, goal)
							      else helper_moves(remove_card(loc_2, head, IllegalMove), rest, head::held_cards) 
    in
	helper_moves(loc, lom, [])
    end
			     
