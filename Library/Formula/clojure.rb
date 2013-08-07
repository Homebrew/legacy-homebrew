require 'formula'

class Clojure < Formula
  homepage 'http://clojure.org/'
  url 'http://repo1.maven.org/maven2/org/clojure/clojure/1.5.1/clojure-1.5.1.zip'
  sha1 '90d09dff6e6ded4382d06ff3b3ab03be471fcab2'

  head 'https://github.com/clojure/clojure.git'

  depends_on 'rlwrap' => :optional

  def script
    if build.with? 'rlwrap'
      rlwrap = "rlwrap "
    else
      rlwrap = ""
    end
    <<-EOS.undent
      #!/bin/sh
      # Clojure wrapper script.
      # With no arguments runs Clojure's REPL.

      # Put the Clojure jar from the cellar and the current folder in the classpath.
      CLOJURE=$CLASSPATH:#{prefix}/#{jar}:${PWD}

      if [ "$#" -eq 0 ]; then
          #{rlwrap}java -cp "$CLOJURE" clojure.main --repl
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

  def test
    system "#{bin}/clj", "-e", '(println "Hello World")'
  end

  def caveats
    s = <<-EOS.undent
      This is NOT the recommended way to use Clojure.

     You should install Leiningen either via homebrew or from https://github.com/technomancy/leiningen in order to use Clojure or ClojureScript.

     Clojure isn't really a program but a library, and leiningen is the user interface to that library.

     You can't build a real project with this homebrew formula for Clojure, and you can't work with existing code and libraries. If you come into the IRC channel looking for help with a Clojure project and you're using homebrew, we CANNOT help you.

     Please uninstall this and use Leiningen instead.
    EOS
  end
end
