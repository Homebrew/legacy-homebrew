require 'formula'

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript'
  url 'https://github.com/clojure/clojurescript/archive/r1853.tar.gz'
  sha1 '19e07e266ea189d791bfe06507e4560483b8f0d6'

  head "https://github.com/clojure/clojurescript.git"

  def install
    system "./script/bootstrap"
    ['bin/cljsc', 'script/repl', 'script/repljs', 'script/browser-repl'].each { |file| set_env(file) } 
    prefix.install Dir['*']
  end

  test do
    system "cljsc"
  end

  def caveats; <<-EOS.undent
    This formula is useful if you need to use the ClojureScript compiler directly.  
    For a more integrated workflow, Leiningen with lein-cljsbuild is recommended.
    EOS
  end
  
  private

  def set_env(file)
    lines = IO.readlines(file)
    lines.insert(1, "CLOJURESCRIPT_HOME=#{prefix}")
    File.open(file, 'w') do |file|
      file.puts lines
    end
  end

end
