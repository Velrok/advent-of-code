(ns advent.day-4
  (:require
   [clojure.set :refer [subset? difference]]
   [advent.core :refer [read-strings read-bit-matrix rows cols col parse-int]]
   [clojure.string :as string]))

(defn draw-seq
  [numbers]
  (for [len (range (count numbers))]
    (take (inc len) numbers)))

(defn parse-board
  [str-seq]
  (mapv
   (fn [line]
     (->> (-> line (string/split #" +"))
          (remove empty?)
          (mapv parse-int)))
   str-seq))

(defn parse-bingo-input
  [filename]
  (let [lines (read-strings filename)
        [numbers-line & more] lines
        numbers (->> (string/split  numbers-line #",")
                     (map #(Integer/parseInt %)))
        boards (->> more
                    (partition-by empty?)
                    (remove #(= '("") %))
                    (map parse-board))]
    {:numbers numbers
     :boards boards}))

(defn winner?
  [numbers board]
  (let [numbers (set numbers)]
    (some->> (concat (rows board)
                     (cols board))
             (filter #(subset? % numbers))
             first
             nil?
             not)))

;; TODO filter out wnners from the pool of players
(defn winning-boards
  [{:keys [numbers boards]}]
  (loop [draws (draw-seq numbers)
         remaining-boards (set boards)
         winners []]
    (if (or (empty? remaining-boards)
            (empty? draws))
      winners
      (let [local-winners (->> remaining-boards
                               (filter (partial winner? (first draws)))
                               (map (fn [winner]
                                      {:board winner
                                       :draws (first draws)})))]
        (recur (rest draws)
               (difference remaining-boards (set (map :board local-winners)))
               (concat winners local-winners))))))

(defn score
  [{:keys [board draws]}]
  (* (last draws)
     (->> board
          flatten
          (remove (partial contains? (set draws)))
          (reduce +))))

(comment
  (->> (parse-bingo-input "inputs/day4.test")
       (winning-boards)
       first
       score)
  (->> (parse-bingo-input "inputs/day4.p1")
       (winning-boards)
       last
       score))
