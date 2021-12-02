(ns advent.core
  (:require [clojure.java.io :as io]))

(defn read-ints
  [filename]
  (some->> filename
           io/reader
           line-seq
           (map #(Integer/parseInt %))))
