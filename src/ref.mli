(** Module for the type [ref], mutable indirection cells [r] containing a value of type
    ['a], accessed with [!r] and set by [r := a]. *)

open! Import

type 'a t = 'a Caml.ref = { mutable contents : 'a }
[@@deriving_inline compare, sexp]
include
sig
  [@@@ocaml.warning "-32"]
  val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
  val t_of_sexp :
    (Ppx_sexp_conv_lib.Sexp.t -> 'a) -> Ppx_sexp_conv_lib.Sexp.t -> 'a t
  val sexp_of_t :
    ('a -> Ppx_sexp_conv_lib.Sexp.t) -> 'a t -> Ppx_sexp_conv_lib.Sexp.t
end
[@@@end]

(*_ defined as externals to avoid breaking the inliner *)
external create : 'a   -> 'a t       = "%makemutable"
external ( ! )  : 'a t -> 'a         = "%field0"
external ( := ) : 'a t -> 'a -> unit = "%setfield0"

(** [swap t1 t2] swaps the values in [t1] and [t2]. *)
val swap : 'a t -> 'a t -> unit

(** [replace t f] is [t := f !t] *)
val replace : 'a t -> ('a -> 'a) -> unit

(** [set_temporarily t a ~f] sets [t] to [a], calls [f ()], and then restores [t] to its
    value prior to [set_temporarily] being called, whether [f] returns or raises. *)
val set_temporarily : 'a t -> 'a -> f:(unit -> 'b) -> 'b
