let rec user_input prompt cb =
  match LNoise.linenoise prompt with
  | None -> ()
  | Some v ->
    cb v;
    user_input prompt cb

let () =
  (* LNoise.set_multiline true; *)
  LNoise.history_load ~filename:"history.txt" |> ignore;
  LNoise.history_set ~max_length:100 |> ignore;
  LNoise.set_completion_callback begin fun line_so_far ln_completions ->
    if line_so_far <> "" && line_so_far.[0] = 'h' then
      ["Hey"; "Howard"; "Hughes";"Hocus"]
      |> List.iter (LNoise.add_completion ln_completions);
  end;
  ["These are OCaml bindings to linenoise";
   "get tab completion with <TAB>, type h then hit <TAB>";
   "type quit to exit gracefully";
   "By Edgar Aroutiounian\n"]
  |> List.iter print_endline;
  (fun from_user ->
     if from_user = "quit" then exit 0;
     LNoise.history_add from_user |> ignore;
     LNoise.history_save ~filename:"history.txt" |> ignore;
     Printf.sprintf "Got: %s" from_user |> print_endline
  )
  |> user_input "test_program> "
