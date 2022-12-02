(local utils (require :utils))





(utils.prettyprint (utils.partition-by (fn [x] (< x 3))
                                        [1 2 3 4 5 6]))
;; (print (utils.hello))
