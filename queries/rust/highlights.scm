;; extends

((macro_invocation
   macro: (identifier) @name (#any-of? @name "todo" "unimplemented" "panico" "panic")) @comment.error)

(call_expression
   function: (field_expression
   field: (field_identifier) @name (#eq? @name "unwrap"))) @comment.error
