require 'formula'

class Clojure <Formula
  url 'https://github.com/downloads/clojure/clojure/clojure-1.2.0.zip'
  md5 'da0cc71378f56491d6ee70dee356831f'
  head 'git://github.com/clojure/clojure.git'
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

  def caveats; <<-EOS.undent
    If you `brew install repl` then you may find this wrapper script from
    MacPorts useful:
      http://trac.macports.org/browser/trunk/dports/lang/clojure/files/clj-rlwrap.sh?format=txt
    EOS
  end
end
