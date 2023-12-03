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

(def numbers-mapping
  {"one" 1
   "two" 2
   "three" 3
   "four" 4
   "five" 5
   "six" 6
   "seven" 7
   "eight" 8
   "nine" 9
   "zero" 0
   "0" 0
   "1" 1
   "2" 2
   "3" 3
   "4" 4
   "5" 5
   "6" 6
   "7" 7
   "8" 8
   "9" 9})

(defn parse-line
  [line]
  (let [pattern #"(\d|zero|one|two|three|four|five|six|seven|eight|nine)"]
    (->> line
         (re-seq pattern)
         (map first))))

(defn part2
  []
  (->>  "./day01.input1"
        (io/reader)
        line-seq
        (map parse-line)
        (map #(map numbers-mapping %))
        (map first-last-pair)
        (map #(apply str %))
        (map #(Integer/parseInt %))
        ; (take 3)
        (reduce +)
        prn))
