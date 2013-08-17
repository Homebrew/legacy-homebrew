require 'formula'

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript'
  url 'https://github.com/clojure/clojurescript/archive/r1853.tar.gz'
  sha1 '19e07e266ea189d791bfe06507e4560483b8f0d6'

  head "https://github.com/clojure/clojurescript.git"

  def install
    system "./script/bootstrap"
  
    # Before copying the temporary directory tree, 
    # we are setting a home variable in three shell 
    # executables that otherwise would poke the shell 
    # environment to get its value, saving the end-user 
    # from extraneous configuration.

    inreplace %w(bin/cljsc script/repl script/repljs script/browser-repl), "#!/bin/sh", "#!/bin/sh\nCLOJURESCRIPT_HOME=#{prefix}" 
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
  
end
