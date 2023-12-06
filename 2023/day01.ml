#!/usr/bin/env ocaml

(* let () = print_endline "Hello, World!";; *)
(**)
(* let add a b = a + b;; *)
(**)
(* let x = 2 in *)
(* let y = 4 in *)
(* let out = string_of_int (add x y) in *)
(* print_endline out;; *)
(**)
(* let last arr = *)
(*   match arr with *)
(*   | [] -> None *)
(*   | l -> Some(List.hd(List.rev l));; *)
(**)
(* let my_list = [1;2;3] in *)
(* let out = match last my_list with *)
(*   | None -> "Empty list." *)
(*   | Some e -> "Last item: " ^ (string_of_int e) *)
(* in *)
(* print_endline out;; *)

let file_handle = (In_channel.open_text  "./day01.example") in
  let lines = In_channel.input_lines file_handle in
print_endline (List.hd lines);;
