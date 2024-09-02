(require '[clojure.java.io :as io])
(require '[clojure.pprint :refer [pprint]])
(require '[clojure.string :as str])

(defn parse-file
  [filename]
  (->> filename
       io/reader
       line-seq
       (map (fn [row]
              (let [[springs checks] (str/split row #" ")]
                {:springs springs
                 :checks (map #(Integer/parseInt %) (str/split checks #","))})))))

(defn -main
  []
  (pprint (parse-file "./day12.example")))

(-main)
