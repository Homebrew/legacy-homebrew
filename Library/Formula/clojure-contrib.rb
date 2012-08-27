require 'formula'

class ClojureContrib < Formula
  head 'https://github.com/clojure/clojure-contrib.git'
  url 'https://github.com/downloads/clojure/clojure-contrib/clojure-contrib-1.2.0.zip'
  md5 '83cc86fd2929ca417a9ab9f2a0dedadb'

  homepage 'http://clojure.github.com/clojure-contrib/'

  depends_on 'clojure'
  depends_on 'maven' if build.head?

  def jar
    return build.head? ? "*" : 'clojure-contrib.jar'
  end

  def install
    if build.head?
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

  def caveats; <<-EOS.undent
    For Clojure to detect the contrib libs, the following path must be in your
    CLASSPATH ENV variable:
      #{prefix}/#{jar}

    To do this with bash, add the following to your ~/.profile file:
      export CLASSPATH=$CLASSPATH:#{prefix}/#{jar}
    EOS
  end
end
