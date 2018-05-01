(ns server.core
  (:require [ring.adapter.jetty :as http])
  (:gen-class))


(defn app [{:keys [body]}]
  (let [size (if-not body 0 (count (slurp body)))]
    {:status 200 :body (str "length:" size)}))


(defn -main []
  (println "Server started at: http://127.0.0.1:3000/")
  (http/run-jetty app {:port 3000}))
