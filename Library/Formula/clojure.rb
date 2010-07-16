require 'formula'

class Clojure <Formula
  url 'http://clojure.googlecode.com/files/clojure-1.1.0.zip'
  md5 '9c9e92f85351721b76f40578f5c1a94a'
  head 'git://github.com/richhickey/clojure.git'
  homepage 'http://clojure.org/'

  def jar
    'clojure.jar'
  end

  def script
<<-EOS
#!/bin/sh
# Runs clojure.
# With no arguments, runs Clojure's REPL.

# resolve links - $0 may be a softlink
CLOJURE=$CLASSPATH:$(brew --cellar)/#{name}/#{version}/#{jar}

java -cp $CLOJURE clojure.main "$@"
EOS
  end

  def install
    system "ant" if ARGV.build_head?
    prefix.install jar
    (bin+'clj').write script
  end
end
