(ns server.core
  (:require [aleph.http :as http])
  (:gen-class))

(defn app [{:keys [body]}]
  (let [size (if-not body 0 (count (slurp body)))]
    {:status 200 :body (str "length:" size)}))

(defn -main []
  (println "Server started at: http://127.0.0.1:3000/")
  (http/start-server app {:port 3000})
  @(promise))
