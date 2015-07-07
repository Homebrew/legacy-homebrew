class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2913.tar.gz"
  sha1 "ff33a93516b3c91923667d667d34cc4b404489c8"

  bottle do
    cellar :any
    sha1 "aa8b2bd64da090c12d508e63bbf56a5128abfbcf" => :yosemite
    sha1 "f56c2dfcd8ee828a2734ea1c39c6c1f1c147178b" => :mavericks
    sha1 "63127cb547b78d3a7fac2770fe3ed56ce39acc10" => :mountain_lion
  end

  def install
    system "./script/bootstrap"
    inreplace %w[bin/cljsc script/repl script/repljs script/browser-repl],
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
    (testpath/"t.cljs").write <<-EOF.undent
    (ns hello)
    (defn ^:export greet [n]
      (str "Hello " n))
    EOF

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
