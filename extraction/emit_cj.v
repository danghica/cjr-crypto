From Coq Require Import String ZArith List.
From cjr Require Import lang.
From cjr.examples Require Import cj_print generic_print.
Import ListNotations.
Local Open Scope string_scope.
From cjr.aes_ige Require Import extract.
Definition cj_bundle : string := "@@FILE aes_ige" ++ nl ++ print_prog aes_program.
