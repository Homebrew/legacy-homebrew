require 'formula'

class Clojure <Formula
  url 'http://clojure.googlecode.com/files/clojure_1.0.0.zip'
  head 'git://github.com/richhickey/clojure.git'
  homepage 'http://clojure.org/'
  md5 'e7a50129040df7fe52287006988ecbb2'
  JAR = "clojure-1.0.0.jar"

  def install
    prefix.install JAR

    # create helpful scripts to start clojure
    bin.mkdir
    clojure_exec = bin + 'clj'

    script = DATA.read
    script.sub! "CLOJURE_JAR_PATH_PLACEHOLDER", "#{prefix}/#{JAR}"

    clojure_exec.write script

    File.chmod(0755, clojure_exec)
  end
end

__END__
#!/bin/bash
# Runs clojure.
# With no arguments, runs Clojure's REPL.
# With one or more arguments, the first is treated as a script name, the rest
# passed as command-line arguments.

# resolve links - $0 may be a softlink
CLOJURE=$CLASSPATH:CLOJURE_JAR_PATH_PLACEHOLDER

if [ -z "$1" ]; then
	java -server -cp $CLOJURE clojure.lang.Repl
else
	scriptname=$1
	java -server -cp $CLOJURE clojure.lang.Script $scriptname -- $*
fi
