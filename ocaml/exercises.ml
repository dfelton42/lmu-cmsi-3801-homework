exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(* First then apply function *)
let first_then_apply (xs : 'a list) (p : 'a -> bool) (f : 'a -> 'b option) : 'b option =
  match List.find_opt p xs with
  | Some x -> f x
  | None -> None

(* Powers generator function *)
let rec int_pow (base : int) (exp : int) : int =
  if exp = 0 then 1
  else base * int_pow base (exp - 1)

let powers_generator (b : int) : int Seq.t =
  let rec generate n =
    Seq.Cons (int_pow b n, fun () -> generate (n + 1))
  in
  fun () -> generate 0

(* Meaningful line count function *)
let meaningful_line_count (filename : string) : int =
  let is_valid_line line =
    let trimmed = String.trim line in
    trimmed <> "" && not (String.length trimmed > 0 && trimmed.[0] = '#')
  in
  let ic = open_in filename in
  let rec count_lines count =
    match input_line ic with
    | line ->
        let new_count = if is_valid_line line then count + 1 else count in
        count_lines new_count
    | exception End_of_file ->
        close_in ic;
        count
  in
  count_lines 0

(* Define the Shape type and associated functions *)
type shape =
  | Box of float * float * float
  | Sphere of float

let volume (s : shape) : float =
  match s with
  | Box (width, height, depth) -> width *. height *. depth
  | Sphere radius -> (4.0 /. 3.0) *. Float.pi *. (radius ** 3.0)

let surface_area (s : shape) : float =
  match s with
  | Box (width, height, depth) ->
      2.0 *. (width *. height +. height *. depth +. width *. depth)
  | Sphere radius -> 4.0 *. Float.pi *. (radius ** 2.0)

let to_string (s : shape) : string =
  match s with
  | Box (width, height, depth) ->
      Printf.sprintf "Box (width: %.2f, height: %.2f, depth: %.2f)" width height depth
  | Sphere radius ->
      Printf.sprintf "Sphere (radius: %.2f)" radius

(* Define a binary search tree type and associated functions *)
type 'a bst =
  | Empty
  | Node of {
      value : 'a;
      left : 'a bst;
      right : 'a bst;
    }

(* Default integer comparison function *)
let int_compare (a : int) (b : int) : int = compare a b

(* General insert function *)
let rec insert (cmp : 'a -> 'a -> int) (x : 'a) (tree : 'a bst) : 'a bst =
  match tree with
  | Empty -> Node { value = x; left = Empty; right = Empty }
  | Node { value; left; right } ->
      if cmp x value < 0 then
        Node { value; left = insert cmp x left; right }
      else if cmp x value > 0 then
        Node { value; left; right = insert cmp x right }
      else
        tree

(* Specialized insert function for integers *)
let insert_int x t = insert int_compare x t

(* Alias insert to insert_int for integer compatibility in tests *)
let insert = insert_int

(* General lookup function *)
let rec lookup (cmp : 'a -> 'a -> int) (x : 'a) (tree : 'a bst) : bool =
  match tree with
  | Empty -> false
  | Node { value; left; right } ->
      if cmp x value < 0 then lookup cmp x left
      else if cmp x value > 0 then lookup cmp x right
      else true

(* Specialized contains function for integers *)
let contains_int x t = lookup int_compare x t

(* Alias contains to contains_int for integer compatibility in tests *)
let contains = contains_int

(* Count function to determine the size of the tree *)
let rec count (tree : 'a bst) : int =
  match tree with
  | Empty -> 0
  | Node { left; right; _ } -> 1 + count left + count right

(* Alias count as size to match the test file *)
let size = count

(* Inorder traversal function to produce a sorted list *)
let rec inorder (tree : 'a bst) : 'a list =
  match tree with
  | Empty -> []
  | Node { value; left; right } -> inorder left @ [value] @ inorder right
