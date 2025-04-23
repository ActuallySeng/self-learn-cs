(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)			      

  
fun only_capitals los =
    let val fncomp = fn s => String.sub(s, 0)
    in     List.filter (Char.isUpper o fncomp)  los
    end
 

fun longest_string1 los =
    foldl (fn (rsf, s) => if size rsf > size s then rsf else s) "" los

fun longest_string2 los =
    foldl (fn (rsf, s) => if size rsf >= size s then rsf else s) "" los

fun longest_string_helper f los =
    foldl (fn (rsf, s) => if f (size rsf, size s)  then rsf else s) "" los
			     
	  
val longest_string3 =
    longest_string_helper (fn (x,y) => x > y)

    
val longest_string4 =
    longest_string_helper (fn (x,y) => x >= y)
			  
val longest_capitalized =
    longest_string1 o only_capitals
    
val rev_string =
    implode o rev o explode

fun first_answer f l =
    case l of
	[] => raise NoAnswer
      | first::rest => case f first of
			   NONE => first_answer f rest

			 | SOME v => v
fun all_answers f l =
    let fun helper l rsf =
	    case l of
		[] => SOME rsf
	      | first::rest => case f first of
				   NONE => NONE
				 | SOME v => helper rest (rsf @ v)
    in helper l []
    end


val count_wildcards =
    g (fn x => 1) (fn x => 0)

val count_wild_and_variable_lengths =
    g (fn x => 1) (fn x => String.size x)

fun count_some_var (s, p) =
    g (fn x => 0) (fn x => if x = s then 1 else 0) p

fun check_pat p =
    let fun get_strin (pat, rsf) =
	    case pat of
		Wildcard          => rsf
	      | Variable x        => rsf @ [x]
	      | TupleP ps         => (List.foldl get_strin [] ps) @ rsf
	      | ConstructorP(_,p) => get_strin(p, rsf)
	      | _    => rsf;
	val los = get_strin(p, []);
	
	fun repeat los =
	    case los of
		[] => true
	      | first::rest => if List.exists (fn x => x = first) rest then false else repeat rest
    in
	repeat los
    end

fun match (v,p) =
    let fun helper (SOME rsf) =
		   case (v,p) of
		       (_, Wildcard) => SOME rsf
		     | (v, Variable s) => SOME (rsf @ [(s, v)])
		     | (Unit, UnitP) => SOME rsf
		     | (Const v, ConstP v) => SOME rsf
		     | (Constructor(s2, v), ConstructorP(s1, p)) => match (v,p)
		     | (Tuple vs, TupleP ps) => let val zipped = ListPair.zip (vs, ps)
					       in
						   case (all_answers match zipped) of
						       NONE => NONE
						    |  SOME v => SOME (rsf @ v)
					       end
		
		     | _ => NONE
    in helper (SOME [])
    end

fun first_match v lop =
    let fun helper p = match (v,p)
    in SOME (first_answer helper lop) handle NoAnswer => NONE
    end
