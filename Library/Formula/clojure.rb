require 'formula'

class Clojure < Formula
  homepage 'http://clojure.org/'
  url 'http://repo1.maven.org/maven2/org/clojure/clojure/1.4.0/clojure-1.4.0.zip'
  sha1 '34daf1bb035aba4c0e5ff3b4afef837d21700e72'

  head 'https://github.com/clojure/clojure.git'

  devel do
    url 'http://central.maven.org/maven2/org/clojure/clojure/1.5.0-beta2/clojure-1.5.0-beta2.zip'
    sha1 '54785a5de0b20e4da2d98703c3fb15b16fa3bbb1'
  end

  def script; <<-EOS.undent
    #!/bin/sh
    # Clojure wrapper script.
    # With no arguments runs Clojure's REPL.

    # Put the Clojure jar from the cellar and the current folder in the classpath.
    CLOJURE=$CLASSPATH:#{prefix}/#{jar}:${PWD}

    if [ "$#" -eq 0 ]; then
        java -cp "$CLOJURE" clojure.main --repl
    else
        java -cp "$CLOJURE" clojure.main "$@"
    fi
    EOS
  end

  def jar
    "clojure-#{version}.jar"
  end

  def install
    system "ant" if build.head?
    prefix.install jar
    (prefix+jar).chmod(0644) # otherwise it's 0600
    (prefix+'classes').mkpath
    (bin+'clj').write script
  end

  def caveats; <<-EOS.undent
    If you `brew install repl` then you may find this wrapper script from
    MacPorts useful:
      http://trac.macports.org/browser/trunk/dports/lang/clojure/files/clj-rlwrap.sh?format=txt
    EOS
  end

  def test
    system "#{bin}/clj", "-e", '(println "Hello World")'
  end
end
