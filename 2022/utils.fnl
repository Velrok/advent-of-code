(local fennel (require :fennel))

(fn hello
  []
  :hello)

(fn slurp
  [filename]
  (let [f (assert (io.open filename "r"))
        content (f:read "*all")]
    content))

(fn split
  [str seperator]
  (let [sep (or seperator "%s")
        pattern (.. "([^" sep "]+)")]
    (icollect [m (string.gmatch str pattern)]
              m)))

(fn prettyprint
  [x]
  (print (fennel.view x)))

;; exports
{
 : hello
 : slurp
 : split
 : prettyprint
}
