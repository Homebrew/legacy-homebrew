require "formula"

class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2356.tar.gz"
  sha1 "a35ee217bb9d32aaf084fbe853826ce4df198056"

  bottle do
    cellar :any
    sha1 "258033dcd57bd7c60e459196dc27f2defce1f5fe" => :mavericks
    sha1 "cf38e509c0bc9973884cfebb89949bad9201dfa5" => :mountain_lion
    sha1 "3382ba5e90def2df4b69cca762b5878274bbe38f" => :lion
  end

  def install
    system "./script/bootstrap"
    inreplace %w(bin/cljsc script/repl script/repljs script/browser-repl),
      "#!/bin/sh", "#!/bin/sh\nCLOJURESCRIPT_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/cljsc"
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
