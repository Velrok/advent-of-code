(local fennel (require :fennel))

(fn hello
  []
  :hello)

(fn prettyprint
  [x]
  (print (fennel.view x)))

(fn slurp
  [filename]
  (let [f (assert (io.open filename "r"))
        content (f:read "*all")]
    content))

(fn str-split
  [str seperator]
  (let [sep (or seperator "%s")
        pattern (.. "([^" sep "]+)")]
    (icollect [m (string.gmatch str pattern)]
              m)))

(fn table-split
  [tbl splitter-element]
  (let [x (accumulate [state {:results [] :buffer []}
               i n (ipairs tbl)]
              (do
                (if (= n splitter-element)
                  ;; flush buffer
                  (do
                    (table.insert state.results state.buffer)
                    (set state.buffer []))
                  ;; append to buffer
                  (table.insert state.buffer n))
                state))]
    (table.insert x.results x.buffer)
    x.results))

(fn read-lines
  [filename]
  (icollect [line (io.lines filename)]
            line))

(fn read-numbers
  [filename]
  (icollect [_ line (ipairs (read-lines filename))]
            (let [number (tonumber line)]
              (if number number :nan))))

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
 : str-split
 : table-split
 : prettyprint
 : read-lines
 : read-numbers
 : partition-by
}
