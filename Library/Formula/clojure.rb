require 'formula'

class Clojure < Formula
  url 'https://github.com/downloads/clojure/clojure/clojure-1.2.1.zip'
  md5 'c5724c624fd6ce6a1d00252c27d53ebe'
  head 'https://github.com/clojure/clojure.git'
  homepage 'http://clojure.org/'

  def script; <<-EOS.undent
    #!/bin/sh
    # Clojure wrapper script.
    # With no arguments runs Clojure's REPL.

    # Put the Clojure jar from the cellar and the current folder in the classpath.
    CLOJURE=$CLASSPATH:#{prefix}/clojure.jar:${PWD}

    if [ "$#" -eq 0 ]; then
        java -cp $CLOJURE clojure.main --repl
    else
        java -cp $CLOJURE clojure.main "$@"
    fi
    EOS
  end

  def install
    system "ant" if ARGV.build_head?
    prefix.install 'clojure.jar'
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
    system "#{bin}/clj -e \"(println \\\"Hello World\\\")\""
  end
end
