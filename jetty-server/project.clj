(defproject jetty-server "0.1.0-SNAPSHOT"
  :description "Simple server to evaluate performances"
  :url "https://github.com/BrunoBonacci/clojure-http-servers-benchmark"

  :dependencies [[org.clojure/clojure "1.8.0"]
                 [ring/ring-jetty-adapter "1.6.3"]]

  :uberjar-name "jetty-server.jar"

  :main server.core)
