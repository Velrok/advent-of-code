(require '[clojure.java.io :as io])
(require '[clojure.pprint :refer [pprint]])
(require '[clojure.string :as str])

(defn checkable?
  [{:keys [springs]}]
  (not (str/includes? springs "?")))

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
  (->> (parse-file "./day12.example")
       (filter checkable?)
       pprint))

(-main)
