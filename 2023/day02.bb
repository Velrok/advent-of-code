(require '[clojure.java.io :as io])
(require '[clojure.string :as str])
(require '[clojure.pprint :refer [pprint]])

(defn parse-line
  [line]
  (let [[_ game-id results-str] (re-matches #"Game (\d+): (.*)"
                                            line)
        draws-strings (str/split results-str #";")
        draws (map (fn [l]
                     (map str/trim (str/split l #",")))
                   draws-strings)]
    {:game-id (Integer/parseInt game-id)
     :draws (for [cube-sets draws]
              (into {}
                    (map (fn [s]
                           (let [[_ count colour] (re-matches #"(\d+) (\w+)" s)]
                             [(keyword colour) (Integer/parseInt count)]))
                         cube-sets)))}))

(defn valid-game?
  [{:keys [draws]}])

(defn part1
  []
  (let [limits {:red 12, :green 13, :blue 13}]
    (->>  "./day02.example"
          (io/reader)
          line-seq
          (map parse-line)
          ; (filter (valid-game? limits))
          (take 2)
          pprint)))

(part1)
(println "---")
