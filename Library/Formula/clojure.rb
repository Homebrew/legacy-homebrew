require 'brewkit'

class Clojure <Formula
  url 'http://clojure.googlecode.com/files/clojure_1.0.0.zip'
  homepage 'http://clojure.org/'
  md5 'e7a50129040df7fe52287006988ecbb2'
  JAR = "clojure-1.0.0.jar"

  def install
    prefix.install JAR

    # create helpful scripts to start clojure
    bin.mkdir
    clojure_exec = bin+'clj'
    clojure_exec.write <<-EOS
#!/bin/sh
java -Xmx512M -cp #{prefix}/#{JAR} clojure.lang.Script "$@"
EOS

    File.chmod(0755, clojure_exec)

    clojure_repl_exec = bin+'clj_repl'
    clojure_repl_exec.write <<-EOS
#!/bin/sh
java -Xmx512M -cp #{prefix}/#{JAR} clojure.lang.Repl "$@"
EOS
    File.chmod(0755, clojure_repl_exec)
  end
end
