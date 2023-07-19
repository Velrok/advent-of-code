(local utils (require :utils))

;; (let [(s r) (pcall tonumber "12")]
;;   (utils.prettyprint s))
;; (utils.prettyprint (utils.read-numbers "day1.test.input"))

(utils.prettyprint
  (utils.table-split (utils.read-numbers "day1.test.input") :nan))
