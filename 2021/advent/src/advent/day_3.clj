(ns advent.day-3
  (:require [advent.core :refer [read-strings read-bit-matrix row col]]
            [clojure.string :as string]))

(defn most-common-bits
  [matrix]
  (let [col-count (->> matrix first count)
        row-count (count matrix)]
    (map
     (fn [col-idx]
       (let [sum (reduce + (col matrix col-idx))]
         (if (< (/ row-count 2) sum)
           1
           0)))
     (range col-count))))

(defn parse-binary
  [s]
  (Long/parseLong (cond
                    (string? s) s
                    (seq? s) (reduce str s)
                    (vector? s) (reduce str s)
                    :else (throw (ex-info "unsupported type" {:type (type s)})))
                  2))

(defn power-level
  [matrix]
  (let [common   (most-common-bits matrix)
        uncommon (map #(case %
                         1 0
                         0 1)
                      common)]
    (* (parse-binary common)
       (parse-binary uncommon))))

(defn filter-rows
  [matrix criteria]
  (loop [m       matrix
         col-idx 0]
    (if (= 1 (count m))
      ;; return the only row left
      (first m)
      ;;
      (let [row-count (count m)
            sum (reduce + (col m col-idx))
            look-for (criteria row-count sum)]
        (recur (filter (fn [row] (= look-for (nth row col-idx)))
                       m)
               (inc col-idx))))))

(defn oxygen-rating
  [matrix]
  (filter-rows matrix
               (fn [row-count sum]
                 (if (<= (/ row-count 2) sum)
                   1
                   0))))

(defn scrubber-rating
  [matrix]
  (filter-rows matrix
               (fn [row-count sum]
                 (if (<= (/ row-count 2) sum)
                   0
                   1))))

(comment

  (first (read-bit-matrix "inputs/day3.test"))

  (= 198
     (->> "inputs/day3.test"
          read-bit-matrix
          power-level))

  (->> "inputs/day3.p1"
       read-bit-matrix
       power-level)

  (->> "inputs/day3.test"
       read-bit-matrix
       oxygen-rating)

  (->> "inputs/day3.test"
       read-bit-matrix
       scrubber-rating
       parse-binary)

;; P2

  (let [matrix (->> "inputs/day3.p2"
                    read-bit-matrix)]
    (* (-> matrix scrubber-rating parse-binary)
       (-> matrix oxygen-rating parse-binary)))

  ;;
  )
