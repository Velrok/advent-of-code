(require '[clojure.java.io :as io])

(defn first-last-pair
  [line]
  [(-> line first)
   (-> line last)])

(let [numbers (->> "0123456789"
                   char-array
                   seq
                   set)]
  (->>  "./day01.input1"
        (io/reader)
        line-seq
        (map (fn [line] (filter numbers line)))
        (map first-last-pair)
        (map #(apply str %))
        (map #(Integer/parseInt %))
        (reduce +)
        prn))
