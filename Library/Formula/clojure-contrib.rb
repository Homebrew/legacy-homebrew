require 'formula'

class ClojureContrib <Formula
  head 'git://github.com/richhickey/clojure-contrib.git'
  homepage 'http://github.com/richhickey/clojure-contrib'

  depends_on 'clojure'
  depends_on 'maven'

  def install
    system "mvn package"
    prefix.install Dir["target/clojure-contrib-*.jar"]
  end

  def caveats
    <<-END_CAVEATS
For Clojure to detect the contrib libs, the following path must be in your
CLASSPATH ENV variable:

    #{prefix}

To do this with bash, add the following to your ~/.profile file:

    export CLASSPATH=$CLASSPATH:#{prefix}
    END_CAVEATS
  end
end
