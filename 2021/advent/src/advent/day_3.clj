(ns advent.day-3
  (:require [advent.core :refer [read-strings]]
            [clojure.string :as string]))

(defn most-common-bits
  [str-seq]
  (let [row-count (count str-seq)
        matrix (->> str-seq
                    (map seq))]
    (map
     (fn [col]
       (let [total (->> matrix
                        (map #(nth % col))
                        (map #(Integer/parseInt (str %)))
                        (reduce +))]
         (if (< (/ row-count 2) total)
           \1
           \0)))

     (range (-> matrix first count)))))

(defn parse-binary
  [s]
  (Long/parseLong (if (string? s) s (reduce str s))
                  2))

(defn power-level
  [str-seq]
  (let [common   (most-common-bits str-seq)
        _ (prn (map type common))
        uncommon (map #(case %
                         \1 \0
                         \0 \1)
                      common)]
    (* (parse-binary common)
       (parse-binary uncommon))))

(comment

  (= 198
     (->> "inputs/day3.test"
          read-strings
          power-level))

  (->> "inputs/day3.p1"
          read-strings
          power-level)

  ;;
  )
