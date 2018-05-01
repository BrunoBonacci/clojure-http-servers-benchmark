(defproject httpkit-server "0.1.0"
  :description "Simple server to evaluate performances"
  :url "https://github.com/BrunoBonacci/clojure-http"

  :dependencies [[org.clojure/clojure "1.8.0"]
                 [http-kit "2.2.0"]]

  :uberjar-name "httpkit-server.jar"

  :main server.core)
