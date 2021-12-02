(ns advent.day-2
  (:require [advent.core :refer [read-strings]]
            [clojure.string :as string]))

(defn- parse-command-line
  [s]
  (let [[cmd value] (string/split s #" ")]
    {:cmd (keyword cmd)
     :val (Integer/parseInt value)}))

(defn parse-commands
  [filename]
  (->> filename
       read-strings
       (map parse-command-line)))

(defn process-commands
  [cmd-seq]
  (reduce (fn [state {:keys [cmd val]}]
            (case cmd
              :forward (update state :pos + val)
              :up      (update state :depth - val)
              :down    (update state :depth + val)))
          {:pos 0 :depth 0}
          cmd-seq))

(defn process-aiming-commands
  [cmd-seq]
  (reduce (fn [state {:keys [cmd val]}]
            (let [aim (:aim state)]
              (case cmd
                :forward (-> state
                             (update :pos + val)
                             (update :depth + (* aim val)))
                :up      (update state :aim - val)
                :down    (update state :aim + val))))
          {:pos 0 :depth 0 :aim 0}
          cmd-seq))

(comment
  ;; P1
  ;; test
  (= 150
     (->> "inputs/day2.test"
          parse-commands
          process-commands
          vals
          (reduce *)))

  (->> "inputs/day2.p1"
       parse-commands
       process-commands
       vals
       (reduce *))

  ;; P2
  (= {:pos 15, :depth 60, :aim 10}
     (->> "inputs/day2.test"
          parse-commands
          process-aiming-commands))

  (let [{:keys [pos depth]} (->> "inputs/day2.p2"
                                 parse-commands
                                 process-aiming-commands)]
    (* pos depth))

;;
  )
