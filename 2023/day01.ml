#!/usr/bin/env ocaml

let file_handle = (In_channel.open_text  "./day01.example") in
  let lines = In_channel.input_lines file_handle in
  print_endline (List.hd lines);;
