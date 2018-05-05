# Clojure HTTP servers benchmark


## how to run

To run need a few packages to be installed:

  * Install the Java JDK
  * Install leingen
  * Install wrk2
  * Install neofetch
  * Install planck-repl

then clone the repo:

    git clone ...
    cd clojure..
    ./bin/run-all.plk

by default it runs a the test for 5 minutes with a warm up time of 10
seconds.  To change these values create a file called `config.edn`
with the following content:

    {:duration "3h" :warm-up-time "120s"}

then run it with:

    ./bin/run-all.plk -c config.edn

The script will build and run all the tests for all the servers.
Once completed the resulting data will be available in the folder `./results`
under a folder with the timestamp of when the test was started.

You can generate the graphs with:

    ./bin/plot-all.sh ./results/yyyy-mm-dd_hh-mm-ss/

You need python3 installed along with a bunch of libraries, to install
them run:

    pip3 install --user pandas matplotlib

## License

Copyright © 2018 Bruno Bonacci - Distributed under the [Apache License v 2.0](http://www.apache.org/licenses/LICENSE-2.0)
