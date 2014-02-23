require 'formula'

class Clojurescript < Formula
  homepage 'https://github.com/clojure/clojurescript'
  head 'https://github.com/clojure/clojurescript.git'
  url 'https://github.com/clojure/clojurescript/archive/r2156.tar.gz'
  sha1 'e95d37ed1c93af606a5825826688be801c65194d'

  def install
    system "./script/bootstrap"
    inreplace %w(bin/cljsc script/repl script/repljs script/browser-repl),
      "#!/bin/sh", "#!/bin/sh\nCLOJURESCRIPT_HOME=#{libexec}"
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/cljsc'
  end

  def caveats; <<-EOS.undent
    This formula is useful if you need to use the ClojureScript compiler directly.
    For a more integrated workflow, Leiningen with lein-cljsbuild is recommended.
    EOS
  end

  test do
    system "#{bin}/cljsc"
  end
end
