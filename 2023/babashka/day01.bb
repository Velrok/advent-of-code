(require '[clojure.java.io :as io])

(defn first-last-pair
  [line]
  [(-> line first)
   (-> line last)])

(defn part1
  []
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
          prn)))

(defn parse-line
  [line]
  (prn "line: " line)
  (let [pattern #"(\d|one|two|three|four|five|six|seven|eight|nine|ten)"]
    (->> line
         (re-seq pattern)
         )))

(defn part2
  []
    (->>  "./day01.input1"
          (io/reader)
          line-seq
          (map parse-line)
          first
          ; (map first-last-pair)
          ; (map #(apply str %))
          ; (map #(Integer/parseInt %))
          ; (reduce +)
          prn))

(part2)
