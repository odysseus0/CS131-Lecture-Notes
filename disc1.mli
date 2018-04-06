(* Variable Declaration *)
let x = 5;;
let x = "hi";;
x;;

(* Arithmetic Expression *)
1 + 3;;
4 - 2;;
2 * 3;;
6 / 2;;
1.3 +. 2.4;;
4.2 *. 3.3;;
2.2 + 3.2;;
1 +. 3;;
3 > 2;;
3.0 > 2.0;;
3 > 2.0;;

(* String Concatination *)
"Hello " ^ "World!";;

(* Boolean Expression *)
true && false;;
true || false;;
not true;;

(* Function *)
let double x = 2 * x;;
let double2 = fun x -> 2 * x;;
function x -> 2 * x;;
double 3;;
double double;;
double2 3;;

let twice f x = f(f x);;
let twice (f, x) =  f(f(x));;
let twice f x = f(f x);;
let twice2 (f, x) = f(f x);;
twice double;;
twice double 2;;
twice2 double;;
twice2(double, 2);;

(* Recursive function *)
let rec fact x =
  if x <= 0 then 1
  else x * fact(x - 1);;

fact 5;;

(* List *)
[];;
[3; 4; 5];;
[3; 4.0];;
3::[];;
4::3::[];;

(* Tuples *)
(3, 4);;
("b", 4, 3.0, 'z');;
fst (3, 4);;
snd (3, 4);;

(* Pattern Matching *)
let rec sumList l =
  match l with
    [] -> 0
  | x::xs -> x + sumList xs;;

let multTuple t =
  match t with
    (a, b, c) -> a * b * c;;

multTuple (3, 4, 5);;

let multTuple2 t =
  let (a, b, c) = t in
  a * b * c;;

multTuple2 (3, 4, 5);;

