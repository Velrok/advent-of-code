(require '[clojure.string :as str])

(defn parse-point
  [s]
  (let [[x, y] (str/split s #",")]
    {:x (Integer/parseInt x)
     :y (Integer/parseInt y)}))

(defn length
  [{:keys [x y]}]
  (Math/sqrt (+ (* x x)
                (* y y))))

(defn area
  [p1 p2]
  (let [x1 (:x p1)
        x2 (:x p2)

        y1 (:y p1)
        y2 (:y p2)

        width (inc (Math/abs (- x2 x1)))
        height (inc (Math/abs (- y2 y1)))]
    (* width height)))

(defn main
  []
  (let [squares-by-dist
        (->> (slurp "inputs/day09")
             str/split-lines
             (map parse-point)
             (sort-by length))
        closest (first squares-by-dist)
        furthest (last squares-by-dist)]
    (println (area closest furthest))))

(main)
