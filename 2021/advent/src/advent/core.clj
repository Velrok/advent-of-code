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
