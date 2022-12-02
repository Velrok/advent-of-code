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

(fn read-lines
  [filename]
  (icollect [line (io.lines filename)]
            line))

(fn read-numbers
  [filename]
  (icollect [_ line (ipairs (read-lines filename))]
            (tonumber line)))

(fn partition-by
  [match-fn seq]
  (accumulate [result []
               _ item (ipairs seq)]
              (do
                (if (match-fn item)
                  (table.insert result [item])
                  (let [last-index (length result) 
                        current-partition (. result last-index)]
                    (table.insert current-partition item)))
                result)))


;; exports
{
 : hello
 : slurp
 : split
 : prettyprint
 : read-lines
 : read-numbers
 : partition-by
}
