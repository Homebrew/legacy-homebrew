require 'formula'

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript'
  url 'https://github.com/clojure/clojurescript/archive/r1853.tar.gz'
  sha1 '19e07e266ea189d791bfe06507e4560483b8f0d6'

  head "https://github.com/clojure/clojurescript.git"

  def install
    system "./script/bootstrap"
    prefix.install Dir['*'] 
    [bin/'cljsc', prefix/'script/repl', prefix/'script/repljs', prefix/'script/browser-repl'].map { | file | set_env(file) }
    [prefix/'script/repljs', prefix/'script/browser-repl'].map { | file | bin.install(file) }
  end

  test do
    system "cljsc"
  end

  def caveats; <<-EOS.undent
    This formula is useful if for some reason you need to use the ClojureScript compiler directly.  
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
