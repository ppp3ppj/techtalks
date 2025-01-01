(* Safe division using Option Monad *)
let safe_divide x y =
  if y = 0 then None else Some (x / y)

(* Monad bind function *)
let bind opt f =
  match opt with
  | None -> None
  | Some value -> f value

let () =
  let result = bind (safe_divide 10 2) (fun x ->
                safe_divide x 0) in
  match result with
  | None -> print_endline "Error: Division by zero!"
  | Some value -> print_endline (string_of_int value)
(* Output: Error: Division by zero! *)
