require 'formula'

class ClojureContrib <Formula
  url 'http://clojure-contrib.googlecode.com/files/clojure-contrib-1.1.0.zip'
  md5 'ffaa8d5ea72abd9547186ec38f37c198'
  head 'git://github.com/richhickey/clojure-contrib.git'
  homepage 'http://richhickey.github.com/clojure-contrib/branch-1.1.x/index.html'

  depends_on 'clojure'
  depends_on 'maven' if ARGV.build_head?

  def jar
    'clojure-contrib.jar'
  end

  def install
    if ARGV.build_head?
      system "mvn package -Dclojure.jar=#{HOMEBREW_PREFIX}/Cellar/clojure/HEAD/clojure.jar"
      system "mv target/clojure-contrib-*.jar #{jar}"
    end
    prefix.install jar
  end

  def caveats
    <<-END_CAVEATS
For Clojure to detect the contrib libs, the following path must be in your
CLASSPATH ENV variable:

    #{prefix}/#{jar}

To do this with bash, add the following to your ~/.profile file:

    export CLASSPATH=$CLASSPATH:#{prefix}/#{jar}
    END_CAVEATS
  end
end
