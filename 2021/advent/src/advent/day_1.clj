(ns advent.day-1
  (:require [advent.core :refer [read-ints]]))

(defn count-increases
  [numbers-seq]
  (some->> (partition 2 1 numbers-seq)
           (filter (fn [[n nn]] (< n nn)))
           count))

(defn count-increases-denoised
  [numbers-seq]
  (some->> (partition 3 1 numbers-seq)
           (map (partial apply +))
           count-increases))

(comment
  ; To do this, count the number of times a depth measurement increases from
  ; the previous measurement. (There is no measurement before the first measurement.)
  ; In the example above, the changes are as follows:
  ;; P1
  ;; test
  (= 7
     (->>  "inputs/day1.p1.test"
           read-ints
           count-increases))

  (->> "inputs/day1.p1"
       read-ints
       count-increases)

;; P2
  (= 5
     (->> "inputs/day1.p1.test"
           read-ints
           count-increases-denoised))
  (->> "inputs/day1.p2"
       read-ints
       count-increases-denoised)

;;
  )
