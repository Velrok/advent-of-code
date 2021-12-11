(ns advent.core
  (:require [clojure.java.io :as io]))

(defn read-strings
  [filename]
  (some->> filename
           io/reader
           line-seq))

(defn read-ints
  [filename]
  (some->> filename
           read-strings
           (map #(Integer/parseInt %))))

(defn read-bit-matrix
  [filename]
  (some->> filename
           read-strings
           (mapv (fn [line] (->> line (mapv #(Integer/parseInt (str %))))))))

(def row nth)

(defn col
  [matrix index]
  (map #(nth % index) matrix))

(defn parse-int
  [s]
  (Integer/parseInt s))

(defn rows
  [matrix]
  matrix)

(defn cols
[m]
(let [col-count (->> m first count)]
  (for [i (range col-count)]
    (col m i)))
)
