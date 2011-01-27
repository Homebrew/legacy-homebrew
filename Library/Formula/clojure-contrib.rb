require 'formula'

class ClojureContrib <Formula
  url 'http://github.com/downloads/clojure/clojure-contrib/clojure-contrib-1.2.0.zip'
  md5 '83cc86fd2929ca417a9ab9f2a0dedadb'
  head 'git://github.com/clojure/clojure-contrib.git'
  homepage 'http://richhickey.github.com/clojure-contrib/branch-1.1.x/index.html'

  depends_on 'clojure'
  depends_on 'maven' if ARGV.build_head?

  def jar
    return ARGV.build_head? ? "*" : 'clojure-contrib.jar'
  end

  def install
    if ARGV.build_head?
      system "mvn package -Dclojure.jar=#{prefix}/clojure.jar"
      Dir.glob("**/target/*.jar").each do |f|
        new_file = File.basename(f).gsub(/\-\d\.\d\.\d\-SNAPSHOT/,'')
        mv f, new_file
        prefix.install(new_file)
      end
    else
      system "mv target/clojure-contrib-*.jar clojure-contrib.jar"
      prefix.install jar
    end
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
